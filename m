Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1EPG3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:29:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1EPG3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:29:53 -0400
Date: Mon, 16 May 2011 08:29:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: x86@kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Possible sandybridge livelock issue
Message-ID: <20110516062930.GA24836@elte.hu>
References: <1305303156.2611.51.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305303156.2611.51.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> We've just come off a large round of debugging a kswapd problem over on
> linux-mm:
> 
> http://marc.info/?t=130392066000001
> 
> The upshot was that kswapd wasn't being allowed to sleep (which we're
> now fixing).  However, in spite of intensive efforts, the actual hang
> was only reproducible on sandybridge laptops.
> 
> When the hang occurred, kswapd basically pegged one core in 100% system
> time.  This looks like there's something specific to sandybridge that
> causes this type of bad interaction.  I was wondering if it could be
> something to to with a scheduling problem in turbo mode?  Once kswapd
> goes flat out, the core its on will kick into turbo mode, which causes
> it to get preferentially scheduled there, leading to the live lock.

There's no explicit 'schedule Sandybridge differently' logic in the scheduler.

Thus turbo mode can only affect scheduling by executing code faster. Executing 
faster *does* mean more scheduling on that CPU: it's faster to do work so it's 
faster back to idle again.

I.e. i can see Sandybridge being special only due to timing and performance 
differences.

> The only evidence I have to support this theory is that when I reproduce the 
> problem with PREEMPT, the core pegs at 100% system time and stays there even 
> if I turn off the load.  However, if I can execute work that causes kswapd to 
> be kicked off the core it's running on, it will calm back down and go to 
> sleep.

At first sight this looks like some sort of kswapd problem: if you put kswapd 
into TASK_*INTERRUPTIBLE and schedule() it then the scheduler won't keep it 
running, on Sandybridge or elsewhere. The scheduler can't magically make kswapd 
runnable unless there's some big bug in it. So you first need to examine why 
kswapd never schedules to idle.

Thanks,

	Ingo
