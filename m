Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074Ab2J3Rhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:37:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22788 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965014Ab2J3RhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:37:07 -0400
Date: Tue, 30 Oct 2012 11:44:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jbeulich@suse.com
Cc: Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH 1/2] xen/hypercall: fix hypercall fallback code for very
 old hypervisors
Message-ID: <20121030154450.GA3000@phenom.dumpdata.com>
References: <1351519698-11069-1-git-send-email-konrad.wilk@oracle.com>
 <1351519698-11069-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351519698-11069-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 10:08:17AM -0400, Konrad Rzeszutek Wilk wrote:
> From: Jan Beulich <jbeulich@suse.com>
> 
> While copying the argument structures in HYPERVISOR_event_channel_op()
> and HYPERVISOR_physdev_op() into the local variable is sufficiently
> safe even if the actual structure is smaller than the container one,
> copying back eventual output values the same way isn't: This may
> collide with on-stack variables (particularly "rc") which may change
> between the first and second memcpy() (i.e. the second memcpy() could
> discard that change).
> 
> Move the fallback code into out-of-line functions, and handle all of
> the operations known by this old a hypervisor individually: Some don't
> require copying back anything at all, and for the rest use the
> individual argument structures' sizes rather than the container's.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> [v2: Reduce #define/#undef usage in HYPERVISOR_physdev_op_compat().]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

And it looks like I get 

ERROR: "HYPERVISOR_event_channel_op_compat" [drivers/xen/xen-evtchn.ko] undefined!

when I build xen-evtchn as module. Jan did you encounter this issue on 2.6.18?
> ---
>  arch/x86/include/asm/xen/hypercall.h |   21 +++------
>  drivers/xen/Makefile                 |    2 +-
>  drivers/xen/fallback.c               |   78 ++++++++++++++++++++++++++++++++++
>  3 files changed, 86 insertions(+), 15 deletions(-)
>  create mode 100644 drivers/xen/fallback.c
> 
> diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
> index 59c226d..c812360 100644
> --- a/arch/x86/include/asm/xen/hypercall.h
> +++ b/arch/x86/include/asm/xen/hypercall.h
> @@ -359,18 +359,14 @@ HYPERVISOR_update_va_mapping(unsigned long va, pte_t new_val,
>  		return _hypercall4(int, update_va_mapping, va,
>  				   new_val.pte, new_val.pte >> 32, flags);
>  }
> +int __must_check HYPERVISOR_event_channel_op_compat(int, void *);
>  
>  static inline int
>  HYPERVISOR_event_channel_op(int cmd, void *arg)
>  {
>  	int rc = _hypercall2(int, event_channel_op, cmd, arg);
> -	if (unlikely(rc == -ENOSYS)) {
> -		struct evtchn_op op;
> -		op.cmd = cmd;
> -		memcpy(&op.u, arg, sizeof(op.u));
> -		rc = _hypercall1(int, event_channel_op_compat, &op);
> -		memcpy(arg, &op.u, sizeof(op.u));
> -	}
> +	if (unlikely(rc == -ENOSYS))
> +		rc = HYPERVISOR_event_channel_op_compat(cmd, arg);
>  	return rc;
>  }
>  
> @@ -386,17 +382,14 @@ HYPERVISOR_console_io(int cmd, int count, char *str)
>  	return _hypercall3(int, console_io, cmd, count, str);
>  }
>  
> +int __must_check HYPERVISOR_physdev_op_compat(int, void *);
> +
>  static inline int
>  HYPERVISOR_physdev_op(int cmd, void *arg)
>  {
>  	int rc = _hypercall2(int, physdev_op, cmd, arg);
> -	if (unlikely(rc == -ENOSYS)) {
> -		struct physdev_op op;
> -		op.cmd = cmd;
> -		memcpy(&op.u, arg, sizeof(op.u));
> -		rc = _hypercall1(int, physdev_op_compat, &op);
> -		memcpy(arg, &op.u, sizeof(op.u));
> -	}
> +	if (unlikely(rc == -ENOSYS))
> +		rc = HYPERVISOR_physdev_op_compat(cmd, arg);
>  	return rc;
>  }
>  
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 0e863703..46de6cd 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -2,7 +2,7 @@ ifneq ($(CONFIG_ARM),y)
>  obj-y	+= manage.o balloon.o
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  endif
> -obj-y	+= grant-table.o features.o events.o
> +obj-y	+= grant-table.o features.o events.o fallback.o
>  obj-y	+= xenbus/
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
> diff --git a/drivers/xen/fallback.c b/drivers/xen/fallback.c
> new file mode 100644
> index 0000000..0bdc468
> --- /dev/null
> +++ b/drivers/xen/fallback.c
> @@ -0,0 +1,78 @@
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/bug.h>
> +#include <asm/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +
> +int HYPERVISOR_event_channel_op_compat(int cmd, void *arg)
> +{
> +	struct evtchn_op op;
> +	int rc;
> +
> +	op.cmd = cmd;
> +	memcpy(&op.u, arg, sizeof(op.u));
> +	rc = _hypercall1(int, event_channel_op_compat, &op);
> +
> +	switch (cmd) {
> +	case EVTCHNOP_close:
> +	case EVTCHNOP_send:
> +	case EVTCHNOP_bind_vcpu:
> +	case EVTCHNOP_unmask:
> +		/* no output */
> +		break;
> +
> +#define COPY_BACK(eop) \
> +	case EVTCHNOP_##eop: \
> +		memcpy(arg, &op.u.eop, sizeof(op.u.eop)); \
> +		break
> +
> +	COPY_BACK(bind_interdomain);
> +	COPY_BACK(bind_virq);
> +	COPY_BACK(bind_pirq);
> +	COPY_BACK(status);
> +	COPY_BACK(alloc_unbound);
> +	COPY_BACK(bind_ipi);
> +#undef COPY_BACK
> +
> +	default:
> +		WARN_ON(rc != -ENOSYS);
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +int HYPERVISOR_physdev_op_compat(int cmd, void *arg)
> +{
> +	struct physdev_op op;
> +	int rc;
> +
> +	op.cmd = cmd;
> +	memcpy(&op.u, arg, sizeof(op.u));
> +	rc = _hypercall1(int, physdev_op_compat, &op);
> +
> +	switch (cmd) {
> +	case PHYSDEVOP_IRQ_UNMASK_NOTIFY:
> +	case PHYSDEVOP_set_iopl:
> +	case PHYSDEVOP_set_iobitmap:
> +	case PHYSDEVOP_apic_write:
> +		/* no output */
> +		break;
> +
> +#define COPY_BACK(pop, fld) \
> +	case PHYSDEVOP_##pop: \
> +		memcpy(arg, &op.u.fld, sizeof(op.u.fld)); \
> +		break
> +
> +	COPY_BACK(irq_status_query, irq_status_query);
> +	COPY_BACK(apic_read, apic_op);
> +	COPY_BACK(ASSIGN_VECTOR, irq_op);
> +#undef COPY_BACK
> +
> +	default:
> +		WARN_ON(rc != -ENOSYS);
> +		break;
> +	}
> +
> +	return rc;
> +}
> -- 
> 1.7.7.6
