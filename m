Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0DORP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:15:59 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:49509 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab0DORP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=odWdh9Q8uXFVhtxI5/Oa7KLzh3pOEK6kl1V808CJtHW3DfvMwAutHxhtJcIhRCCNjy
         WAasWIPjOgN5Talmc5Vjj2JwOFYg1+K4S7Nj7ch4ccRzHps1Wdwx9hP9DbLlZ+/w0uRR
         uHzUkuWb1uh6I5W1KNtzS4Q2Ttya5NIAhZb2c=
Date: Thu, 15 Apr 2010 19:15:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: PowerPC WARN_ON_ONCE() after merge of the final
	tree (tip related)
Message-ID: <20100415171551.GA5069@nowhere>
References: <20100415161214.04637496.sfr@canb.auug.org.au> <20100415064940.GA9240@elte.hu> <20100415130032.GA6789@nowhere> <20100415140358.GA19981@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415140358.GA19981@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 04:03:58PM +0200, Ingo Molnar wrote:
> > In this case, I guess the following fix should be sufficient?
> > I'm going to test it and provide a sane changelog.
> > 
> > 
> > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > index 78325f8..65d4336 100644
> > --- a/kernel/lockdep.c
> > +++ b/kernel/lockdep.c
> > @@ -2298,7 +2298,11 @@ void trace_hardirqs_on_caller(unsigned long ip)
> >  		return;
> >  
> >  	if (unlikely(curr->hardirqs_enabled)) {
> > +		unsigned long flags;
> > +
> > +		raw_local_irq_save(flags);
> >  		debug_atomic_inc(redundant_hardirqs_on);
> > +		raw_local_irq_restore(flags);
> >  		return;
> >  	}
> >  	/* we'll do an OFF -> ON transition: */
> 
> that looks rather ugly. Why not do a raw:
> 
> 	this_cpu_inc(lockdep_stats.redundant_hardirqs_on);
> 
> which basically open-codes debug_atomic_inc(), but without the warning?


Because that would open a race against interrupts that might
touch lockdep_stats.redundant_hardirqs_on too.

If you think it's not very important (this race must be pretty rare I guess),
I can use your solution.



> 
> Btw., using the this_cpu() methods might result in faster code for all the 
> debug_atomic_inc() macros as well?


Indeed, will change that too.

Thanks.

