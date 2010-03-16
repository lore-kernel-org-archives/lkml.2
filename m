Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936656Ab0CPHqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:46:35 -0400
Received: from mga10.intel.com ([192.55.52.92]:9478 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757156Ab0CPHqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:46:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,649,1262592000"; 
   d="scan'208";a="781153426"
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
In-Reply-To: <4B9F19F7.6000309@redhat.com>
References: <1268717232.2813.36.camel@localhost>
	 <4B9F19F7.6000309@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 16 Mar 2010 15:48:44 +0800
Message-Id: <1268725724.2813.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 07:41 +0200, Avi Kivity wrote:
> On 03/16/2010 07:27 AM, Zhang, Yanmin wrote:
> > From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
> >
> > Based on the discussion in KVM community, I worked out the patch to support
> > perf to collect guest os statistics from host side. This patch is implemented
> > with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
> > critical bug and provided good suggestions with other guys. I really appreciate
> > their kind help.
> >
> > The patch adds new subcommand kvm to perf.
> >
> >    perf kvm top
> >    perf kvm record
> >    perf kvm report
> >    perf kvm diff
> >
> > The new perf could profile guest os kernel except guest os user space, but it
> > could summarize guest os user space utilization per guest os.
> >
> > Below are some examples.
> > 1) perf kvm top
> > [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
> > --guestmodules=/home/ymzhang/guest/modules top
> >
> >    
> 
Thanks for your kind comments.

> Excellent, support for guest kernel != host kernel is critical (I can't 
> remember the last time I ran same kernels).
> 
> How would we support multiple guests with different kernels?
With the patch, 'perf kvm report --sort pid" could show
summary statistics for all guest os instances. Then, use
parameter --pid of 'perf kvm record' to collect single problematic instance data.

>   Perhaps a 
> symbol server that perf can connect to (and that would connect to guests 
> in turn)?

> 
> > diff -Nraup linux-2.6_tipmaster0315/arch/x86/kvm/vmx.c linux-2.6_tipmaster0315_perfkvm/arch/x86/kvm/vmx.c
> > --- linux-2.6_tipmaster0315/arch/x86/kvm/vmx.c	2010-03-16 08:59:11.825295404 +0800
> > +++ linux-2.6_tipmaster0315_perfkvm/arch/x86/kvm/vmx.c	2010-03-16 09:01:09.976084492 +0800
> > @@ -26,6 +26,7 @@
> >   #include<linux/sched.h>
> >   #include<linux/moduleparam.h>
> >   #include<linux/ftrace_event.h>
> > +#include<linux/perf_event.h>
> >   #include "kvm_cache_regs.h"
> >   #include "x86.h"
> >
> > @@ -3632,6 +3633,43 @@ static void update_cr8_intercept(struct
> >   	vmcs_write32(TPR_THRESHOLD, irr);
> >   }
> >
> > +DEFINE_PER_CPU(int, kvm_in_guest) = {0};
> > +
> > +static void kvm_set_in_guest(void)
> > +{
> > +	percpu_write(kvm_in_guest, 1);
> > +}
> > +
> > +static int kvm_is_in_guest(void)
> > +{
> > +	return percpu_read(kvm_in_guest);
> > +}
> >    
> 

> There is already PF_VCPU for this.
Right, but there is a scope between kvm_guest_enter and really running
in guest os, where a perf event might overflow. Anyway, the scope is very
narrow, I will change it to use flag PF_VCPU.

> 
> > +static struct perf_guest_info_callbacks kvm_guest_cbs = {
> > +	.is_in_guest 		= kvm_is_in_guest,
> > +	.is_user_mode		= kvm_is_user_mode,
> > +	.get_guest_ip		= kvm_get_guest_ip,
> > +	.reset_in_guest		= kvm_reset_in_guest,
> > +};
> >    
> 
> Should be in common code, not vmx specific.
Right. I discussed with Yangsheng. I will move above data structures and
callbacks to file arch/x86/kvm/x86.c, and add get_ip, a new callback to
kvm_x86_ops.

Yanmin


