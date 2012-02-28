Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2B1IMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:12:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab2B1IMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:12:38 -0500
Date: Tue, 28 Feb 2012 09:12:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 4/7] time: Update timekeeper structure using a local
 shadow
Message-ID: <20120228081222.GE21106@elte.hu>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
 <1330388974-27793-5-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330388974-27793-5-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

>  static void update_wall_time(void)
>  {
>  	struct clocksource *clock;
> +	struct timekeeper tk;
>  	cycle_t offset;
>  	int shift = 0, maxshift;
>  	unsigned long flags;
> @@ -1063,10 +1064,11 @@ static void update_wall_time(void)
>  	if (unlikely(timekeeping_suspended))
>  		goto out;
>  
> -	clock = timekeeper.clock;
> +	tk = timekeeper;

'tk' is now an on-stack copy of a very non-trivial (read: large) 
structure - including locks, amongst other things. That's a 
no-no.

> +	timekeeper = tk;

You just broke lockdep here.

It's also ugly code: global data structures should almost always 
be updated in situ, instead of updating a local copy and then 
copying it back blindly ...

Thanks,

	Ingo
