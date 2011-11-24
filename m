Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1KXNqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:46:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab1KXNq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:46:28 -0500
Date: Thu, 24 Nov 2011 15:45:42 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
Message-ID: <20111124134542.GK2557@redhat.com>
References: <20111117123029.GB16853@redhat.com>
 <1321534159.27735.33.camel@twins>
 <20111121131739.GF16853@redhat.com>
 <1322140980.2921.49.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322140980.2921.49.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 02:23:00PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-21 at 15:17 +0200, Gleb Natapov wrote:
> > So how about throttling it like the patch below does until stop_machine()
> > no longer needed for patching (and it is possible that new way of patching
> > will still have significant overhead).
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> > index 66f23dc..a4687f6 100644
> > --- a/include/linux/jump_label.h
> > +++ b/include/linux/jump_label.h
> > @@ -3,12 +3,15 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/compiler.h>
> > +#include <linux/workqueue.h>
> >  
> >  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> >  
> >  struct jump_label_key {
> >         atomic_t enabled;
> >         struct jump_entry *entries;
> > +       unsigned long rl_timeout;
> > +       struct delayed_work rl_work;
> >  #ifdef CONFIG_MODULES
> >         struct jump_label_mod *next;
> 
> 
> I'm not sure its worth it doing in generic code like this, it bloats the
> jump_label_key structure quite significantly (and there's tons of those
> around) for only 1 real user.
To do it in the perf code we will have to replicate "enabled" accounting
of jump_label in the perf code. The code will be much uglier this way
IMO. On the other hand the feature fits nicely into generic jump_label
code and apart from jump_label_key structure size overhead has no other
downsides.  And size overhead will be eliminated by your suggestion below.

> 
> If we want to do this in generic code, I think its best to introduce
> something like:
> 
> struct jump_label_key_deferred {
> 	struct jump_label_key key;
> 	unsigned long timeout;
> 	struct delayed_work work;
> }
> 
Yes, I contemplated this. I didn't realized that there are tons of
jump_labels though.

> But is there really any other user for this? All the trace bits are root
> only iirc and kvm itself only sets them on the guest kernel I think for
> paravirt, so that's not a problem.
> 
The problem I am trying to fix with this patch is not strictly
virtualization related. As I showed in my previous email on the
subject you can trigger this jump label patching very often without
virtualization at all. Of course with virtulization the problem is much
more serious since the patching is going on in the host kernel and guest
kernel.

--
			Gleb.
