Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2GDJIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:08:16 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:32965 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2GDJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:08:14 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chinmay V S <cvs268@gmail.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Date: Wed, 04 Jul 2012 12:08:12 +0300
Message-ID: <6448205.KkruCZixvF@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.4 (Linux/3.2.0-26-generic; KDE/4.8.4; i686; ; )
In-Reply-To: <20120703142348.3c963378.akpm@linux-foundation.org>
References: <2325453.OX7ktP55U1@vlad> <CAK-9PRBi3XOVtW3gs3doO=ecD0XWfNffVefdRCC1sGnLdT_9LA@mail.gmail.com> <20120703142348.3c963378.akpm@linux-foundation.org>
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

On Tuesday 03 July 2012 14:23:48 Andrew Morton wrote:
> On Mon, 2 Jul 2012 23:54:09 +0530
> 
> Chinmay V S <cvs268@gmail.com> wrote:
> > Hi Vlad,
> > 
> > I suppose we both are looking at opposite sides of the same coin.
> > While i am wary of the potential pitfalls,
> > you have focused on the benefits of using __read_mostly.
> > 
> > At this point i would like to send out a shout to everyone concerned to
> > please clarify the status of __read_mostly:
> > 
> > 1. Is it being actively pursued? (systems that *will* clearly benefit from
> > it) 2. Any actual results on real world use-cases? (w/ & w/o
> > __read_mostly) 3. Is __read_mostly being accepted in non-architecture
> > specific kernel code? 4. Is anyone working on a potential replacement for
> > it?
> 

Andrew, thanks for joining! :)

> I don't recall ever having seen any serious work justifying or
> condemning __read_mostly.  

Back in the thread I've pointed out that __read_mostly variables (are meant 
to) have actually the same nature as the constants except the fact that they 
are initialized with the some value that may change from one boot (of the 
kernel) to another: e.g. kalloc() returned value, values initialized in __init 
functions, etc.

Have u ever seen any serious work justifying or condemning the usage for 
"const" qualifier? 
If u did, (could u, pls., point us to it) the same reasoning hold in the 
context of __read_mostly. 
If not - do u think somebody should perform such a work? Or maybe we all 
understand that if there a constant in my code I should define it as const? 
And we all agree on const, why do we still arguing about __read_mostly which 
are actually the same?

> It's one of those things which seemed a good idea at the time, got added and 
> nobody did anything further with it, as far as I know.  

Hmmm... ~1300 __read_mostly appearances in the kernel doesn't sound like 
nothing to me... ;) People use it! ;) 


> I've always been rather wobbly about it, for reasons discussed up-thread.

Could u, pls., comment on the following statements that conclude this thread:

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

> 
> 
> If some problem has indeed been observed then an alternative to
> __read_mostly is to pad bh_cachep to a cacheline boundary with
> ____cacheline_aligned_in_smp or similar.  Or, perhaps better, identify
> the variable which bh_cachep is sharing with, and pad *that* variable
> to a cacheline so it can't cause cache thrashing with something else in
> the future.  And once this mystery variable is identified, we can
> perhaps beneficially group it into the same cacheline with some other
> variables which are related to it.

Again, I don't understand it - we are talking about a constant here. Why to 
pad it or do anything else except for defining it as a constant? The one who 
originally wrote this line (with bh_cachep) either missed that fact or there 
wasn't __read_mostly infrastructure at that time. Either way this patch fixes 
it. What else should be told? Why do we have to justify declaring the const 
object as const?

Thanks in advance for your comments.
vlad

> 
> But I'm madly guessing and can't say aything dispositive or even
> useful, because we haven't been told what the problem was.  Still.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
