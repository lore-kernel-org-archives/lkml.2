Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2F0Ojh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:39:37 -0400
Received: from goliath.siemens.de ([192.35.17.28]:19598 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2F0Ojg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:39:36 -0400
Message-ID: <4FEB1B06.4050309@siemens.com>
Date: Wed, 27 Jun 2012 16:39:02 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 5/6 v5] deal with guest panicked event accoring to -onpanic
 parameter
References: <4FEAAE6E.7070302@cn.fujitsu.com> <4FEAAFFF.40401@cn.fujitsu.com>
In-Reply-To: <4FEAAFFF.40401@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-27 09:02, Wen Congyang wrote:
> When the guest is panicked, it will write 0x1 to the port KVM_PV_PORT.
> So if qemu reads 0x1 from this port, we can do the folloing three
> things according to the parameter -onpanic:
> 1. emit QEVENT_GUEST_PANICKED only
> 2. emit QEVENT_GUEST_PANICKED and pause the guest
> 3. emit QEVENT_GUEST_PANICKED and poweroff the guest
> 4. emit QEVENT_GUEST_PANICKED and reset the guest
> 
> Note: if we emit QEVENT_GUEST_PANICKED only, and the management
> application does not receive this event(the management may not
> run when the event is emitted), the management won't know the
> guest is panicked.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  kvm-all.c       |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kvm-stub.c      |    9 +++++
>  kvm.h           |    3 ++
>  qemu-options.hx |   15 ++++++++
>  vl.c            |   10 +++++
>  5 files changed, 138 insertions(+), 0 deletions(-)
> 
> diff --git a/kvm-all.c b/kvm-all.c
> index f8e4328..9494dd2 100644
> --- a/kvm-all.c
> +++ b/kvm-all.c
> @@ -19,6 +19,8 @@
>  #include <stdarg.h>
>  
>  #include <linux/kvm.h>
> +#include <linux/kvm_para.h>
> +#include <asm/kvm_para.h>
>  
>  #include "qemu-common.h"
>  #include "qemu-barrier.h"
> @@ -32,6 +34,9 @@
>  #include "bswap.h"
>  #include "memory.h"
>  #include "exec-memory.h"
> +#include "iorange.h"
> +#include "qemu-objects.h"
> +#include "monitor.h"
>  
>  /* This check must be after config-host.h is included */
>  #ifdef CONFIG_EVENTFD
> @@ -1931,3 +1936,99 @@ int kvm_on_sigbus(int code, void *addr)
>  {
>      return kvm_arch_on_sigbus(code, addr);
>  }
> +
> +/* Possible values for action parameter. */
> +#define PANICKED_REPORT     1   /* emit QEVENT_GUEST_PANICKED only */
> +#define PANICKED_PAUSE      2   /* emit QEVENT_GUEST_PANICKED and pause VM */
> +#define PANICKED_POWEROFF   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
> +#define PANICKED_RESET      4   /* emit QEVENT_GUEST_PANICKED and reset VM */
> +
> +static int panicked_action = PANICKED_REPORT;
> +
> +static void kvm_pv_port_read(IORange *iorange, uint64_t offset, unsigned width,
> +                             uint64_t *data)
> +{
> +    *data = (1 << KVM_PV_FEATURE_PANICKED);
> +}
> +
> +static void panicked_mon_event(const char *action)
> +{
> +    QObject *data;
> +
> +    data = qobject_from_jsonf("{ 'action': %s }", action);
> +    monitor_protocol_event(QEVENT_GUEST_PANICKED, data);
> +    qobject_decref(data);
> +}
> +
> +static void panicked_perform_action(void)
> +{
> +    switch (panicked_action) {
> +    case PANICKED_REPORT:
> +        panicked_mon_event("report");
> +        break;
> +
> +    case PANICKED_PAUSE:
> +        panicked_mon_event("pause");
> +        vm_stop(RUN_STATE_GUEST_PANICKED);
> +        break;
> +
> +    case PANICKED_POWEROFF:
> +        panicked_mon_event("poweroff");
> +        exit(0);
> +        break;
> +    case PANICKED_RESET:
> +        panicked_mon_event("reset");
> +        qemu_system_reset_request();
> +        break;
> +    }
> +}
> +
> +static void kvm_pv_port_write(IORange *iorange, uint64_t offset, unsigned width,
> +                              uint64_t data)
> +{
> +    if (data == KVM_PV_PANICKED) {
> +        panicked_perform_action();
> +    }
> +}
> +
> +static void kvm_pv_port_destructor(IORange *iorange)
> +{
> +    g_free(iorange);
> +}
> +
> +static IORangeOps pv_io_range_ops = {
> +    .read = kvm_pv_port_read,
> +    .write = kvm_pv_port_write,
> +    .destructor = kvm_pv_port_destructor,
> +};
> +
> +#if defined(KVM_PV_PORT)
> +void kvm_pv_port_init(void)
> +{
> +    IORange *pv_io_range = g_malloc(sizeof(IORange));
> +
> +    iorange_init(pv_io_range, &pv_io_range_ops, KVM_PV_PORT, 1);
> +    ioport_register(pv_io_range);

This modeling is still not ok. We don't open-code ports anymore, we
introduce devices. And this doesn't belong inro generic code as it is
x86-only. Will avoid that #ifdef as well.

Thanks
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux


