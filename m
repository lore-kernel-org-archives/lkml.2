Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0JFNim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:38:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22064 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JFNil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:38:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56910435"
Subject: Re: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <4CABEECB.4030301@codeaurora.org>
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
	 <1285644827-6846-2-git-send-email-sboyd@codeaurora.org>
	 <1286299355.18791.11.camel@c-dwalke-linux.qualcomm.com>
	 <4CABEECB.4030301@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 06:38:33 -0700
Message-ID: <1286372313.22265.54.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 20:36 -0700, Stephen Boyd wrote:
> On 10/05/2010 10:22 AM, Daniel Walker wrote:
> > You shouldn't really reference this series in this comment. You have to
> > look at this as a changeset comment. So you really want to describe what
> > this change is doing not what the over all series is doing.
> >
> > It would be better to say something like,
> >
> > "We're implementing this in C to give us further flexibility in allowing
> > overrides."
> >
> > But don't references "next patch" or "this series" , but you can do that
> > in the intro email.
> >
> 
> Why not? This is a common thing to do when multiple patches are related
> to one topic. Doing a git log and searching for "next patch" shows
> others doing the same.

I would not say it's common .. I don't recall seeing many other series
which do this. You shouldn't do it because the patch description doesn't
stand on it own. What if this patch is accepted in isolation, and the
others rejected would your description make sense? Also people don't
always look at a "series" in git history, sometimes you only look at one
commit so saying "next patch" or "this series" can be confusing.

You can have an intro email where you can describe the whole series,
including what your intending for each patch to do.

> >>
> >>  $ scripts/bloat-o-meter vmlinux.orig vmlinux.new
> >>  add/remove: 0/0 grow/shrink: 2/0 up/down: 12/0 (12)
> >>  function                                     old     new   delta
> >>  __udelay                                      48      56      +8
> >>  __const_udelay                                40      44      +4
> >
> > I think the "size" command might be better for this type of stuff. It
> > should give you the same output (or similar).. It's just used more
> > frequently. 
> 
> Ok.
> 
> $ size vmlinux.orig
>    text    data     bss     dec     hex filename
> 6533503  530232 1228296 8292031  7e86bf vmlinux.orig
> $ size vmlinux.new
>    text    data     bss     dec     hex filename
> 6533607  530232 1228296 8292135  7e8727 vmlinux.new
> 
> I should mention GCC decided to inline __delay() into __udelay() and
> __const_udelay() and also decided to inline __const_udelay() into
> __delay() meaning we lost the function interleaving the assembly file
> had. I'll make a note of that and sorry for being misleading.
> 
> > Is this an -Os kernel, or -O2 ?
> 
> -Os.
> 
> >> +/*
> >> + * 0 <= xloops <= 0x7fffff06
> >> + * loops_per_jiffy <= 0x01ffffff (max. 3355 bogomips)
> >
> > As long as your doing a re-write may as well add some real text here,
> > and for the others.
> 
> Any suggestions on what to add? I hoped the original comments would be
> good enough already considering the code is unchanged.

you might want to say what the purpose of the function is ..

> >> + */
> >> +void __const_udelay(unsigned long xloops)
> >> +{
> >> +	unsigned long lpj;
> >> +	unsigned long loops;
> >> +
> >> +	xloops >>= 14;			/* max = 0x01ffffff */
> >> +	lpj = loops_per_jiffy >> 10;	/* max = 0x0001ffff */
> >> +	loops = lpj * xloops;		/* max = 0x00007fff */
> >> +	loops >>= 6;			/* max = 2^32-1 */
> >> +
> >> +	if (loops)
> >> +		__delay(loops);
> >
> > likely/unlikely ?
> 
> likely. Although I'm doubtful on how much it will help considering the
> assembly and the code are equivalent already for this part of the code.

I don't know, shouldn't hurt tho.

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


