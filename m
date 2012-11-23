Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161064Ab2KWKC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:02:27 -0500
Received: from science.horizon.com ([71.41.210.146]:49864 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030282Ab2KWKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:02:23 -0500
Date: 23 Nov 2012 05:02:22 -0500
Message-ID: <20121123100222.21774.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mgorman@suse.de
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Cc: dave@linux.vnet.ibm.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20121123085137.GA646@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tl;dr: Have installed Dave Hansen's patch as requested, rebooted.
       Now it's a matter of waiting for lockup...

Mel Gorman wrote:
> heh, those P4s are great for keeping the room warm in winter. Legacy
> high five?

I wanted a physically separate box for some lightly used outside-facing
network services, and it was lying around.  Since then, if it ain't broke,
don't fix it.

If you want *legacy*, a few months ago I installed recent kernels on
an original F00F-bug Pentium (96 MB RAM,bit only 64 MB cacheable!),
and an original MCM PPro.  They aren't actually in service, though.

> Joking aside, the UP aspect of this is the most relevant.

Yeah, I wondered how much testing that got these days. :-)

>> It's kind of a funny lockup.  Some things work:
>> 
>> - TCP SYN handshake
>> - Alt-SysRq
>> 
>> And others don't:
>> 
>> - Caps lock
>> - Shift-PgUp
>> - Alt-Fn
>> - Screen unblanking
>> - Actually talking to a daemon
>> 

> So basically interrupts work but the machine has otherwise locked up. On
> a uniprocessor, it's possible it is infinite looping in kswapd and
> nothing else is getting the chance to run if it never hits a
> cond_resched().

Did caps lock LED handling get moved to something above interrupt context?
I used to use that as the test of "is the machine locked hard".

It might be worth seeing if that functionality can be restored.  The fact
that I can make the console scroll down with Alt-SysRq, but can't scroll
back up to see what just got printed, is maddening.

> Ok, is there any chance you can capture more of sysrq+m, particularly the
> bits that say how much free memory there is and many pages of each order
> that is free? If you can't, it's ok. I ask because my kernel bug dowsing
> rod is twitching in the direction of the recent free page accounting bug
> Dave Hansen identified and fixed -- https://lkml.org/lkml/2012/11/21/504

Will do when I get in front of the machine again.  I had rebooted with
2.6.5, but I can remotely reboot with 2.7-rc6, then it's just a matter
of waiting.

> You might have a machine that is able to hit this particular bug faster. It's
> not a memory leak as such, but it acts like one. The kernel would think
> the watermarks are not met because it's using NR_FREE_PAGES instead of
> checking the free lists.
> 
> Can you try that patch out please?

Okay, so I've cherry-picked ef6c5be658f6a70c1256fbd18e18ee0dc24c3386
from mainline, and rebooted.

I've never tried disabling console blanking remotely, though.  I did
	# echo '^[[9;0]' > /dev/tty0
	# echo '^[[9;0]' > /dev/tty1
	# echo '^[[14;0]' > /dev/tty1
	# echo '^[[14;0]' > /dev/tty0
I hope that works...

> The interesting information in this case is further up. First look for
> the line that looks kinda like this

Will do if it locks up again.  I did notice that all three zones had
at least one free page of size 4096kb, FWIW.

> The free page counter and these free lists should be close together. If
> there is a big gap then it's almost certainly the bug Dave identified.
> 
> There is another potential infinite loop in kswapd that Johannes has
> identified and it could also be that. However, lets rule out Dave's bug
> first.

Thanks a lot!
