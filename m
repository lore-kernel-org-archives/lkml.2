Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab0KDM3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 08:29:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:33072 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0KDM3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:29:08 -0400
Date: Thu, 4 Nov 2010 13:29:06 +0100
From: Marcus Meissner <meissner@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101104122906.GH25118@suse.de>
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104114648.GA23381@elte.hu>
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 12:46:48PM +0100, Ingo Molnar wrote:
> 
> * Marcus Meissner <meissner@suse.de> wrote:
> 
> > Hi,
> > 
> > Making /proc/kallsyms readable only for root makes it harder for attackers to 
> > write generic kernel exploits by removing one source of knowledge where things are 
> > in the kernel.
> 
> Cc:-ed Linus - i think he argued in favor of such a patch in the past.
> 
> I generally agree with such patches (i have written some myself), but there's a few 
> questions with this one, which make this limited change ineffective and which make 
> it harder to implement a fuller patch that makes it truly harder to figure out the 
> precise kernel build:
> 
>  - The real security obstruction effect is very small from this measure alone: the 
>    overwhelming majority of our users are running distro kernels, so the Symbol.map 
>    file (and hence 99% of /proc/kallsyms content) is well-known - unless we also 
>    restrict 'uname -r' from nonprivileged users-ace. Hiding that might make sense - 
>    but the two should be in one patch really.

Of course. System.map and others also need to turn to mode 400.

>  - ( It will break a few tools that can be run as a plain user out of box - perf
>      for example. "chmod a+r /proc/kallsyms" during bootup will work that around so
>      it's not the end of the world. )

I was wondering about how much tools there are... I was also thinking of oprofile too.

>  - For self-built kernels it might make sense - but there's "chmod a-r
>    /proc/kallsyms" during bootup one can do already.
> 
>  - There's the side-question of module symbols - those are dynamically allocated
>    hence arguably per system. But module symbols make up only 1% on a typical 
>    booted up full distro box.
> 
> So what does a distribution like Suse expect from this change alone? Those have 
> public packages in rpms which can be downloaded by anyone, so it makes little sense 
> to hide it - unless _all_ version information is hidden.

It is the first patch, mostly an acceptance test balloon.

There are several other files handing information out, but kallsyms has
it all very nice and ready.

(timer_list, /proc/*/stat*, sl?binfo )
 
> So i'd like to see a _full_ version info sandboxing patch that thinks through all 
> the angles and restricts uname -r kernel version info as well, and makes dmesg 
> unaccessible to users - and closes a few other information holes as well that give 
> away the exact kernel version - _that_ together will make it hard to blindly attack 
> a very specific kernel version.

I am personally thinking of a "small steps" philosophy, one step after the other.

> But without actually declaring and achieving that sandboxing goal this security 
> measure is just a feel-good thing really - and makes it harder to make more 
> difficult steps down the road, like closing 'uname -r' ...
> 
> I fully expect Linus to overrule me on this, but hey, i had to try it and lay out my 
> arguments :-)

The goal we (SUSE Security and the oss-security list) had in mind is:

- Do not leak kernel addresses from kernel space to user space to make
  writing kernel exploits harder.

Even if attackers get to have lists of addresses in their exploits it will have made
the world a bit better.

Ciao, Marcus
