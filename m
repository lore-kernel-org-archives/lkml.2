Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0KJVJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:09:51 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15251 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab0KJVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:09:50 -0500
Date: Wed, 10 Nov 2010 21:58:08 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Frank Rowand <frank.rowand@am.sony.com>
cc: Marcus Meissner <meissner@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>, "mort@sgi.com" <mort@sgi.com>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "security@kernel.org" <security@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
In-Reply-To: <4CD36E41.50505@am.sony.com>
Message-ID: <alpine.LNX.2.00.1011102141430.625@swampdragon.chaosbits.net>
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <4CD36E41.50505@am.sony.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Frank Rowand wrote:

> On 11/04/10 05:29, Marcus Meissner wrote:
> > On Thu, Nov 04, 2010 at 12:46:48PM +0100, Ingo Molnar wrote:
> >>
> >> * Marcus Meissner <meissner@suse.de> wrote:
> >>
> >>> Hi,
> >>>
> >>> Making /proc/kallsyms readable only for root makes it harder for attackers to 
> >>> write generic kernel exploits by removing one source of knowledge where things are 
> >>> in the kernel.
> 
> < snip >
> 
> >> So what does a distribution like Suse expect from this change alone? Those have 
> >> public packages in rpms which can be downloaded by anyone, so it makes little sense 
> >> to hide it - unless _all_ version information is hidden.
> > 
> > It is the first patch, mostly an acceptance test balloon.
> > 
> > There are several other files handing information out, but kallsyms has
> > it all very nice and ready.
> > 
> > (timer_list, /proc/*/stat*, sl?binfo )
> >  
> >> So i'd like to see a _full_ version info sandboxing patch that thinks through all 
> >> the angles and restricts uname -r kernel version info as well, and makes dmesg 
> >> unaccessible to users - and closes a few other information holes as well that give 
> >> away the exact kernel version - _that_ together will make it hard to blindly attack 
> >> a very specific kernel version.
> > 
> > I am personally thinking of a "small steps" philosophy, one step after the other.
> 
> < snip >
> 
> The idea of trying to hide the kernel version is absurd.  The number of different
> places that can provide a precise fingerprint of a kernel version, or a small range of
> possible kernel versions is immense.  Closing all of those places makes use and
> administration of a system more difficult, and encourages frequent use of su.
> 

I agree. Hiding the kernel version is silly. But that's not what the 
original patch was about. The original patch was about "Making 
/proc/kallsyms readable only for root ..." and that (IMVHO) makes sense 
for a number of reasons.

1. For those people running (popular) distro kernels, hiding the 
information on /proc/kallsyms doesn't achieve much, true, an attacker can 
get the information easily online. But it still makes it slightly more 
involved for exploits to gain access to information about the addresses of 
kernel functions - at the very least they now have to hard-code lists of 
addresses for the kernels they target - not much pain, but the more pain 
we can inflict upon these people without hurting legitimate users, the 
better.

2. For people running niche-distros that attackers cannot be bothered to 
target explicitly, but where they previously relied on obtaining these 
addresses from /proc/kallsyms we have a real gain - the attackers can no 
longer get the info they need.

3. For people running custom compiled kernels (and I personally know of a 
few large businesses that do so and several individuals, and I'll bet real 
money that there are more than you suspect "out there"), attacks relying 
on /proc/kallsyms for info are completely defeated.

4. Once we get (and I'm sure that's only a matter of time) randomization 
of the addresses that kernel functions are loaded at, even popular distros 
where the kernel version and config are known to attackers will gain a 
valuable defence by ths patch. Attackers will then no longer be able to 
just download the info from the distro repositories and hard-code 
addresses since they will be randomized, but if they have access to 
/proc/kallsyms they won't need to since they can then just look up the 
addresses there - this patch closes that info path to them which is good.


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

