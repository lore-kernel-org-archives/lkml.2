Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab2EVLct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:32:49 -0400
Received: from thoth.sbs.de ([192.35.17.2]:20120 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770Ab2EVLcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:32:48 -0400
Message-ID: <4FBB794A.5060504@siemens.com>
Date: Tue, 22 May 2012 08:32:26 -0300
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
Subject: Re: [PATCH 3/3] deal with guest panicked event
References: <4FB9E4CE.8060709@cn.fujitsu.com> <4FB9E5CB.2020208@cn.fujitsu.com>
In-Reply-To: <4FB9E5CB.2020208@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-21 03:50, Wen Congyang wrote:
> When the guest is panicked, it will write 0x1 to the port 0x505. So if
> qemu reads 0x1 from this port, we can do the folloing three things
> according to the parameter -onpanic:
> 1. emit QEVENT_GUEST_PANICKED only
> 2. emit QEVENT_GUEST_PANICKED and pause VM
> 3. emit QEVENT_GUEST_PANICKED and quit VM
> 
> Note: if we emit QEVENT_GUEST_PANICKED only, and the management
> application does not receive this event(the management may not
> run when the event is emitted), the management won't know the
> guest is panicked.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  kvm-all.c        |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kvm-stub.c       |    9 ++++++
>  kvm.h            |    3 ++
>  monitor.c        |    3 ++
>  monitor.h        |    1 +
>  qapi-schema.json |    6 +++-
>  qemu-options.hx  |   14 +++++++++
>  qmp.c            |    3 +-
>  vl.c             |   17 ++++++++++-
>  9 files changed, 137 insertions(+), 3 deletions(-)
> 
> diff --git a/kvm-all.c b/kvm-all.c
> index 9b73ccf..b5b0531 100644
> --- a/kvm-all.c
> +++ b/kvm-all.c
> @@ -19,6 +19,7 @@
>  #include <stdarg.h>
>  
>  #include <linux/kvm.h>
> +#include <linux/kvm_para.h>
>  
>  #include "qemu-common.h"
>  #include "qemu-barrier.h"
> @@ -29,6 +30,8 @@
>  #include "bswap.h"
>  #include "memory.h"
>  #include "exec-memory.h"
> +#include "iorange.h"
> +#include "qemu-objects.h"
>  
>  /* This check must be after config-host.h is included */
>  #ifdef CONFIG_EVENTFD
> @@ -1707,3 +1710,84 @@ int kvm_on_sigbus(int code, void *addr)
>  {
>      return kvm_arch_on_sigbus(code, addr);
>  }
> +
> +/* Possible values for action parameter. */
> +#define PANICKED_REPORT 1   /* emit QEVENT_GUEST_PANICKED only */
> +#define PANICKED_PAUSE  2   /* emit QEVENT_GUEST_PANICKED and pause VM */
> +#define PANICKED_QUIT   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
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
> +    switch(panicked_action) {
> +    case PANICKED_REPORT:
> +        panicked_mon_event("report");
> +        break;
> +
> +    case PANICKED_PAUSE:
> +        panicked_mon_event("pause");
> +        vm_stop(RUN_STATE_GUEST_PANICKED);
> +        break;
> +
> +    case PANICKED_QUIT:
> +        panicked_mon_event("quit");
> +        exit(0);
> +        break;
> +    }
> +}
> +
> +static void kvm_pv_port_write(IORange *iorange, uint64_t offset, unsigned width,
> +                              uint64_t data)
> +{
> +    if (data == KVM_PV_PANICKED)
> +        panicked_perform_action();
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
> +void kvm_pv_port_init(void)
> +{
> +    IORange *pv_io_range = g_malloc(sizeof(IORange));
> +
> +    iorange_init(pv_io_range, &pv_io_range_ops, 0x505, 1);
> +    ioport_register(pv_io_range);

Not sure if the discussion about the PV channel already settled, but if
PIO is the way to go, please model this as a proper QEMU device (e.g.
"panic", implemented in hw/kvm/panic.c), not just an open-coded PIO range.

Jan

PS: checkpatch.pl...

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
