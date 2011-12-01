Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1LAV1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:27:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab1LAV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:27:13 -0500
Date: Thu, 1 Dec 2011 19:22:19 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, qemu-devel@nongnu.org,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] Guest stop notification
Message-ID: <20111201212219.GA25290@amt.cnet>
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
 <4ED79138.60603@siemens.com>
 <20111201171938.GA8803@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201171938.GA8803@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 12:19:38PM -0500, Eric B Munson wrote:
> On Thu, 01 Dec 2011, Jan Kiszka wrote:
> 
> > On 2011-11-29 22:36, Eric B Munson wrote:
> > > Often when a guest is stopped from the qemu console, it will report spurious
> > > soft lockup warnings on resume.  There are kernel patches being discussed that
> > > will give the host the ability to tell the guest that it is being stopped and
> > > should ignore the soft lockup warning that generates.
> > > 
> > > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > > Cc: ryanh@linux.vnet.ibm.com
> > > Cc: aliguori@us.ibm.com
> > > Cc: mtosatti@redhat.com
> > > Cc: avi@redhat.com
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  target-i386/kvm.c |    6 ++++++
> > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> > > index 5bfc21f..defd364 100644
> > > --- a/target-i386/kvm.c
> > > +++ b/target-i386/kvm.c
> > > @@ -336,12 +336,18 @@ static int kvm_inject_mce_oldstyle(CPUState *env)
> > >      return 0;
> > >  }
> > >  
> > > +static void kvm_put_guest_paused(CPUState *penv)
> > > +{
> > > +    kvm_vcpu_ioctl(penv, KVM_GUEST_PAUSED, 0);
> > > +}
> > 
> > I see no need in encapsulating this in a separate function.
> > 
> 
> The encapsulated function was from a previous idea, I will remove it for V2.
> 
> > > +
> > >  static void cpu_update_state(void *opaque, int running, RunState state)
> > >  {
> > >      CPUState *env = opaque;
> > >  
> > >      if (running) {
> > >          env->tsc_valid = false;
> > > +	kvm_put_guest_paused(env);
> > 
> > checkpatch.pl would have asked you to remove this tab.
> 
> Will change to spaces for V2.
> 
> > 
> > More general:
> > 
> > Why is this x86-only? If the kernel interface is x86-only, what prevents
> > making it generic right from the beginning?
> > 
> > Why do we need a new IOCTL for this? Was there no space left in the
> > kvm_run structure e.g. to pass this flag down on next vcpu execution? No
> > big deal, just wondering.
> 
> Thanks for your review/feedback.
> 
> When I started looking into this problem, the ioctl was the first suggestion I
> got for how to communicate from qemu to guest kernel.  I don't see a technical
> reason that this could not be added to the kvm_run structure in one of the
> bytes currently used as padding.  I would prefer to keep the ioctl because I
> have the corresponding kernel patches out to work with this, however, if there
> is a strong preference for using kvm_run, I can rework both sets.
> 
> Eric

This functionality being on top of kvmclock, it is more natural for this
command to be an ioctl (in similarity with other kvmclock commands).


