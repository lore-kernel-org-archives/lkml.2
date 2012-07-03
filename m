Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2GCJFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:05:14 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:34386 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2GCJFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:05:12 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Chinmay V S <cvs268@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Date: Tue, 03 Jul 2012 12:05:08 +0300
Message-ID: <3372544.yMUH0INvUP@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.3 (Linux/3.2.0-26-generic; KDE/4.8.3; i686; ; )
In-Reply-To: <CAK-9PRBi3XOVtW3gs3doO=ecD0XWfNffVefdRCC1sGnLdT_9LA@mail.gmail.com>
References: <2325453.OX7ktP55U1@vlad> <2779342.rcjlfQh1rr@vlad> <CAK-9PRBi3XOVtW3gs3doO=ecD0XWfNffVefdRCC1sGnLdT_9LA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012 23:54:09 Chinmay V S wrote:
> Hi Vlad,
> 
> I suppose we both are looking at opposite sides of the same coin.
> While i am wary of the potential pitfalls,
> you have focused on the benefits of using __read_mostly.

Exactly! I'm also afraid that u refuse to agree that those "pitfalls" u are 
referring are not caused by the __read_mostly but by the bad code that HAVE to 
be fixed. And that this bad code remains bad whether u use __read_mostly or 
not. I think this matter has been nicely covered in the thread u've referred 
before: thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-
it.html .

So, again, my statements are as follows:
1) There are no "pitfalls" in the __read_mostly usage/infrastructure - there 
is a bad code that is being revealed by the usage of __read_mostly.
2) The bad code mentioned above is bad and may regress the performance 
regardless the usage of __read_mostly, thus it must be fixed.
3) From (1) and (2) above follows that __read_mostly is a tool that helps to 
discover the bad code thus it should be used as much as possible to do so.
4) To make the discovery of bad code easy __read_mostly qualifiers should be 
added one-by-one despite the natural desire to replace all variables of a 
certain type/nature (like "struct kmem_cache") in one shot.
5) __read_mostly as it's implemented today for x86 arch is good for any SMP 
architecture that have L1 cache. More than that, the less is the level of the 
associativity in the L1 cache the more this platform's performance is 
susceptible to the bad code mentioned in (1) and (2). Therefore according to 
(3) these platforms should use __read_mostly both to gain from straight 
forward benefits of the __read_mostly mechanism and to locate the bad code 
mentioned above and fix it. ARM is one of such platforms and there must have 
been REALLY GOOD reason not to use it. 

Pls., comment.

By the way, note what is the current implementation of __read_mostly in the 
Linus tree:

------------------------------------------------------------------
arch/arm/include/asm/cache.h: line 26:

#define __read_mostly __attribute__((__section__(".data..read_mostly")))
-----------------------------------------------------------------

It's there since 2010-12-04, added by Russell King. Why did u think it's 
defined to nothing? Pls., correct me if I'm missing anything.

 

> 
> At this point i would like to send out a shout to everyone concerned to
> please clarify the status of __read_mostly:
> 
> 1. Is it being actively pursued? (systems that *will* clearly benefit from 
it) 
> 2. Any actual results on real world use-cases? (w/ & w/o __read_mostly)
> 3. Is __read_mostly being accepted in non-architecture specific kernel code? 
> 4. Is anyone working on a potential replacement for it?

I think u'll find the most answers at  thecodeartist.blogspot.com/2011/12/why-
readmostly-does-not-work-as-it.html ;)

thanks,
vlad

> 
> regards
> ChinmayVS
> 
> >I think your point is clear and has actually been nicely stated at
> >thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.htm
> >(by u? :))
> 
> PS: Yes, the link i referred to *is* indeed my own article that i posted a
> few months ago after my experiments with __read_mostly. I was initially
> excited when i found this bit while digging through the code. But upon
> seeing that an entire arch had disabled it, and then understanding why, i
> feel its usage needs to be restricted to arch specific code and even then
> thoroughly tested too. (then again, i may be wrong.)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
