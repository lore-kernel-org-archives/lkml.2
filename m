Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0KYHjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:39:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32878 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KYHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:39:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TMJZvXYEgixB5MFYEi1NI9IeTeHGHf6OS8CQDq+vAeiSfXlCASbcpFtM1wuswUP9V6
         xxMIknGNB/XaMtXibBODTDrtnEbLhXEfas/+StR3Ns/ZAgaf8YXAIEFs/ZrqJ2REntQq
         4HiGBRN3yOK/A4lAJAFjlvkvZV/4pKvi9yC7c=
Date: Thu, 25 Nov 2010 08:38:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] rcu: Fix series of spurious RCU softirqs
Message-ID: <20101125073857.GB2538@nowhere>
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
 <4CEDDB2A.2020807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEDDB2A.2020807@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 11:42:34AM +0800, Lai Jiangshan wrote:
> On 11/24/2010 08:31 AM, Frederic Weisbecker wrote:
> > Hi,
> > 
> > I've observed some not so unfrequent series of spurious rcu
> > softirqs, sometimes happening at each ticks for a random
> > while.
> > 
> > These patches aims at fixing them.
> > 
> > Thanks.
> > 
> > Frederic Weisbecker (2):
> >   rcu: Don't chase unnecessary quiescent states after extended grace periods
> >   rcu: Stop checking quiescent states after grace period completion from remote
> > 
> 
> If we ensure rdp->gpnum >= rdp->completed is always true, the problems as
> you described will not be existed. Or maybe I misunderstand you.
> 
> rdp->gpnum >= rdp->completed is a very important guarantee I think.
> (In my RCURING, it is guaranteed.) I'm afraid there are some other
> problems still hidden if it is not guaranteed.
> 
> so I recommend: (code is better than words)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d5bc439..af4e87a 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -648,6 +648,13 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
>  
>  		/* Remember that we saw this grace-period completion. */
>  		rdp->completed = rnp->completed;
> +
> +		/* Ensure ->gpnum >= ->completed after NO_HZ */
> +		if (unlikely(rnp->completed - rdp->gpnum > 0
> +				|| rdp->gpnum - rnp->gpnum > 0)) {
> +			rdp->gpnum = rnp->completed;
> +			rdp->qs_pending = 0;


That's an alternative to my first patch yeah. And if rdp->gpnum >= rdp->completed
must be a guarantee outside the rnp lock, then it's certainly better because
the lock is relaxed between rcu_process_gp_end() and note_new_gpnum(), and
both values are async in this lockless frame.

But perhaps this shouldn't touch rdp->qs_pending:

"if (rnp->completed > rdp->gpnum || rdp->gpnum > rnp->gpnum)" is not
a guarantee that we don't need to find quiescent states.

but rnp->completed == rnp->gpnum would provide that guarantee.
That said, note_new_gp_new() would fix the value of rdp->qs_pending.

Thanks.
