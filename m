Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2F0Owm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:52:42 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:42666 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2F0Owk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:52:40 -0400
Date: Wed, 27 Jun 2012 16:52:32 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 5/6 v5] deal with guest panicked event
 accoring to -onpanic parameter
Message-ID: <20120627165232.77a97fd0@BR9GNB5Z>
In-Reply-To: <4FEAAFFF.40401@cn.fujitsu.com>
References: <4FEAAE6E.7070302@cn.fujitsu.com>
	<4FEAAFFF.40401@cn.fujitsu.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12062714-5024-0000-0000-0000030C8196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 15:02:23 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> When the guest is panicked, it will write 0x1 to the port KVM_PV_PORT.
> So if qemu reads 0x1 from this port, we can do the folloing three
> things according to the parameter -onpanic:
> 1. emit QEVENT_GUEST_PANICKED only
> 2. emit QEVENT_GUEST_PANICKED and pause the guest
> 3. emit QEVENT_GUEST_PANICKED and poweroff the guest
> 4. emit QEVENT_GUEST_PANICKED and reset the guest

Would it be useful to add some "dump the guest" actions here?

> 
> Note: if we emit QEVENT_GUEST_PANICKED only, and the management
> application does not receive this event(the management may not
> run when the event is emitted), the management won't know the
> guest is panicked.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

> +static void kvm_pv_port_read(IORange *iorange, uint64_t offset, unsigned width,
> +                             uint64_t *data)
> +{
> +    *data = (1 << KVM_PV_FEATURE_PANICKED);
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
> +}
> +#else
> +void kvm_pv_port_init(void)
> +{
> +}
> +#endif

> @@ -3641,6 +3647,10 @@ int main(int argc, char **argv, char **envp)
>          }
>      }
> 
> +    if (kvm_enabled()) {
> +        kvm_pv_port_init();
> +    }
> +
>      if (incoming) {
>          Error *errp = NULL;
>          int ret = qemu_start_incoming_migration(incoming, &errp);

I/O ports won't work for s390, yet we'll likely want panic
notifications there as well. This will need some more abstraction.

Cornelia

