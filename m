Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0KDLrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 07:47:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0KDLrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:47:17 -0400
Date: Thu, 4 Nov 2010 12:46:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcus Meissner <meissner@suse.de>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101104114648.GA23381@elte.hu>
References: <20101104100914.GC25118@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104100914.GC25118@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcus Meissner <meissner@suse.de> wrote:

> Hi,
> 
> Making /proc/kallsyms readable only for root makes it harder for attackers to 
> write generic kernel exploits by removing one source of knowledge where things are 
> in the kernel.

Cc:-ed Linus - i think he argued in favor of such a patch in the past.

I generally agree with such patches (i have written some myself), but there's a few 
questions with this one, which make this limited change ineffective and which make 
it harder to implement a fuller patch that makes it truly harder to figure out the 
precise kernel build:

 - The real security obstruction effect is very small from this measure alone: the 
   overwhelming majority of our users are running distro kernels, so the Symbol.map 
   file (and hence 99% of /proc/kallsyms content) is well-known - unless we also 
   restrict 'uname -r' from nonprivileged users-ace. Hiding that might make sense - 
   but the two should be in one patch really.

 - ( It will break a few tools that can be run as a plain user out of box - perf
     for example. "chmod a+r /proc/kallsyms" during bootup will work that around so
     it's not the end of the world. )

 - For self-built kernels it might make sense - but there's "chmod a-r
   /proc/kallsyms" during bootup one can do already.

 - There's the side-question of module symbols - those are dynamically allocated
   hence arguably per system. But module symbols make up only 1% on a typical 
   booted up full distro box.

So what does a distribution like Suse expect from this change alone? Those have 
public packages in rpms which can be downloaded by anyone, so it makes little sense 
to hide it - unless _all_ version information is hidden.

So i'd like to see a _full_ version info sandboxing patch that thinks through all 
the angles and restricts uname -r kernel version info as well, and makes dmesg 
unaccessible to users - and closes a few other information holes as well that give 
away the exact kernel version - _that_ together will make it hard to blindly attack 
a very specific kernel version.

But without actually declaring and achieving that sandboxing goal this security 
measure is just a feel-good thing really - and makes it harder to make more 
difficult steps down the road, like closing 'uname -r' ...

I fully expect Linus to overrule me on this, but hey, i had to try it and lay out my 
arguments :-)

Thanks,

	Ingo
