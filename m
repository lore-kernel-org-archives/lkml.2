Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab2HNPh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab2HNPhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:37:21 -0400
Date: Tue, 14 Aug 2012 12:32:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: kvm@vger.kernel.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: disable stealtime via reboot notifier to avoid mem
 corruption
Message-ID: <20120814153221.GD14582@amt.cnet>
References: <1344594982-8516-1-git-send-email-fw@strlen.de>
 <20120813215231.GA19294@amt.cnet>
 <20120814091506.GA13610@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814091506.GA13610@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 11:15:06AM +0200, Florian Westphal wrote:
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Fri, Aug 10, 2012 at 12:36:22PM +0200, Florian Westphal wrote:
> > > --- a/arch/x86/kernel/kvmclock.c
> > > +++ b/arch/x86/kernel/kvmclock.c
> > > @@ -191,7 +191,6 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
> > >  static void kvm_shutdown(void)
> > >  {
> > >  	native_write_msr(msr_kvm_system_time, 0, 0);
> > > -	kvm_disable_steal_time();
> > >  	native_machine_shutdown();
> > >  }
> > This part below will introduce a bug for shutdown. Can you retest with
> > the addition of kvm_disable_steal_time to kvm_pv_guest_cpu_reboot only,
> > retest and resend please?
> 
> I can, but the problem with kvm_disable_steal_time() in
> kvmclock.c is that with CONFIG_KVM_CLOCK=n the entire
> file won't be compiled.
> 
> And steal time doesn't depend on CONFIG_KVM_CLOCK=y.
> So if removing it there is a bug leaving it in only avoids
> that bug for CONFIG_KVM_CLOCK=y.

I meant to add kvm_disable_steal_time() call to arch/x86/kernel/kvm.c,
the first part of your patch, here:

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index c1d61ee..1596cc8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -354,6 +354,7 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
      if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
              wrmsrl(MSR_KVM_PV_EOI_EN, 0);
      kvm_pv_disable_apf();
+     kvm_disable_steal_time();
 }
 
 static int kvm_pv_reboot_notify(struct notifier_block *nb,

Can you test only that part and resend? 

The call to kvm_disable_steal_time() in kvmclock.c should not be
removed.

