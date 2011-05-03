Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1ECNjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1ECNjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:39:13 -0400
Date: Tue, 3 May 2011 16:39:01 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, avi@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: make guest mode entry to be rcu quiescent
 state
Message-ID: <20110503133901.GW2265@redhat.com>
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-3-git-send-email-gleb@redhat.com>
 <20110503131317.GA4244@amt.cnet>
 <20110503132123.GV2265@redhat.com>
 <20110503132952.GA5022@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503132952.GA5022@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:29:52AM -0300, Marcelo Tosatti wrote:
> On Tue, May 03, 2011 at 04:21:23PM +0300, Gleb Natapov wrote:
> > On Tue, May 03, 2011 at 10:13:17AM -0300, Marcelo Tosatti wrote:
> > > Hi Gleb,
> > > 
> > > Thats a neat idea.
> > > 
> > > On Thu, Apr 28, 2011 at 12:52:03PM +0300, Gleb Natapov wrote:
> > > > KVM does not hold any references to rcu protected data when it switches
> > > > CPU into a guest mode. In fact switching to a guest mode is very similar
> > > > to exiting to userspase from rcu point of view. In addition CPU may stay
> > > > in a guest mode for quite a long time (up to one time slice). Lets treat
> > > > guest mode as quiescent state, just like we do with user-mode execution.
> > > > 
> > > > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > > > ---
> > > >  include/linux/kvm_host.h |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 0bc3d37..a347bce 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -593,6 +593,7 @@ static inline void kvm_guest_enter(void)
> > > >  {
> > > >  	account_system_vtime(current);
> > > >  	current->flags |= PF_VCPU;
> > > > +	rcu_note_context_switch(smp_processor_id());
> > > >  }
> > > >  
> > > >  static inline void kvm_guest_exit(void)
> > > > -- 
> > > > 1.7.2.3
> > > 
> > > Please have it in x86's vcpu_enter_guest, then its more explicit
> > > (uncertain about the context of kvm_guest_enter call in other arches).
> > > 
> > I checked all of them and kvm_guest_enter() is always called with local
> > irq disabled. Paul confirmed that rcu_note_context_switch() can be
> > called in such context.
> 
> OK then. Perhaps have an assert to verify interrupts are disabled?
Yes. Can add BUG_ON(preemptible()).

--
			Gleb.
