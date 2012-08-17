Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2HQSps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:45:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34926 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932163Ab2HQSpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:45:40 -0400
Message-ID: <1345229139.10014.5.camel@joe2Laptop>
Subject: Re: [PATCH] ratelimit: check the condition in WARN_RATELIMIT first
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 11:45:39 -0700
In-Reply-To: <502E8A2C.3060606@suse.cz>
References: <1345210942-26906-1-git-send-email-jslaby@suse.cz>
	 <1345225144.10014.2.camel@joe2Laptop> <502E8A2C.3060606@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 20:15 +0200, Jiri Slaby wrote:
> On 08/17/2012 07:39 PM, Joe Perches wrote:
> > On Fri, 2012-08-17 at 15:42 +0200, Jiri Slaby wrote:
> >> Before calling __ratelimit in __WARN_RATELIMIT, check the condition
> >> first. When this check was not there, we got constant income of:
> >> tty_init_dev: 60 callbacks suppressed
> >> tty_init_dev: 59 callbacks suppressed
> > []
> >> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> > []
> >> @@ -49,8 +49,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
> >>  #define __WARN_RATELIMIT(condition, state, format...)		\
> >>  ({								\
> >>  	int rtn = 0;						\
> >> -	if (unlikely(__ratelimit(state)))			\
> >> -		rtn = WARN(condition, format);			\
> >> +	int __rtcond = !!condition;				\
> >> +	if (unlikely(__rtcond && __ratelimit(state)))		\
> >> +		rtn = WARN(__rtcond, format);			\
> >>  	rtn;							\
> >>  })
> >>  
> > 
> > Hi Jiri.
> > 
> > This seems fine to me but are there any conditions that
> > are computationally expensive?
> 
> It's not about expensiveness of the computation. The complexity remained
> the same except I moved the computation one layer up.

If ratelimit(state) is not true, condition wasn't tested
or performed at all.  With this change, it's always done.

> > Maybe something like this?
[]
> Yup, something like that looks OK to me.

OK, David, do you want an official patch?


