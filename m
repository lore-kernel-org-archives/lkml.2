Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1BHATy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:19:54 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1BHATx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:19:53 -0500
Message-ID: <4D508BDC.1020309@kernel.org>
Date: Mon, 07 Feb 2011 16:18:36 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: "hpa@kernel.org" <hpa@kernel.org>, dgc@kernel.org, elder@kernel.org,
        hch@kernel.org
Subject: do_raw_spin_lock using a lot of the system cpu time
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 Feb 2011 16:18:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Week and a half ago, all of a sudden, kernel.org's two US mirror
machines spiked in load.  While this does happen, this particular spike
defied what we had seen before.  Specifically the machine seems to be
CPU bound (specifically system cpu), as opposed to our more traditional
I/O bound scenarios.  Doing the obvious things didn't clear the problem
up, and even trying different kernels the problem would come back almost
immediately.

Digging even further into the problem, more or less led me in circles,
so I've been showing this around to HPA, Dave Chinner, Alex Elder and
Christoph Hellwig, but everyone seems as stumped as me so far.  HPA
noted the system is acting like it's run out of memory, when that is far
from the case (machines have 144G of ram and something like +120G of
cache to draw memory from).

The debugging that so far is (via perf top) claims that alloc_vmap_area,
rb_next and do_raw_spin_lock are involved in some combination, with
do_raw_spin_lock being the item taking up 80-90% of the time that perf
top can see.

I'm also seeing this on 3 different kernels:

2.6.34.7-61.korg.fc13.x86_64
	(which is the 34.7-61 kernel + two patches, one for xfs and one
	 to disable IMA)
2.6.35.10-74.fc14.x86_64
2.6.38-0.rc2.git5.1.fc14.x86_64

I have sysrq t + w from the 2.6.34 kernel at

http://userweb.kernel.org/~warthog9/messages.z2.cWpmrIf7

along with additional sysrq w's at

http://userweb.kernel.org/~warthog9/dmesg.output.sysrq.w.z1-nsUCsHUs
http://userweb.kernel.org/~warthog9/dmesg.output.sysrq.w-nsUCsHUs

output from two perf top runs:

http://userweb.kernel.org/~warthog9/perf-top-output-48UMEhyx

We've tried artificially lowering the memory on the systems, this only
lowered the load proportionally (seemingly) to the amount of ram, but
the base symptom that the system cpu load was still high and seemingly
spending all of it's time in a do_raw_spin_lock.

Tried disabling HT on the off chance that had something to do with it,
this didn't seem to affect anything.

I've added, at HCH's request, printk's at the vmalloc calls in fs/file.c
and fs/xfs/linux-2.6/xfs_buf.c.  The former is called on occasion, but
not seemingly enough to warrant what I'm seeing, and the later has yet
to be called on the system with that instrumented.

I've tried running debug kernels, with
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_LOCK_STAT=y

None of which complained about the locking that was occurring.

At one point when attempting to track down what was possibly going on
with vmalloc cat /proc/vmallocinfo actually paniced both machines, hard.
 They were each running different kernels (2.6.35-debug and 2.6.34
respectively for zeus1 and zeus2), and had vastly different uptimes /
system loads / running processes, etc.

Problem seems to be noticeable even when the systems are nearly idle,
loading up an rsync or two shoots the load up a *LOT* more than it has
in the past, with the system going from a load of near 0 with no rscyncs
to a load of 5-10 with 1-2 rsyncs running, and that load seems to be
coming from the system cpu usage.  (it was in the past not uncommon to
see 40-50 rsyncs running in various states and the load be under 5)

I've hit a brick wall, and I haven't been able to figure out what's
going on with the boxes.  Traffic / usage patterns have not increased,
but almost instantly loads went up dramatically.  I've already tried a
full OS upgrade on one machine, which didn't help, and I'm going to try
changing the primary filesystem to see what happens, but I'm guessing
I'm only going to rule out a specific code path as being the cause.

Does anyone have any suggestions on what's going on?  Like I said I've
hit a brick wall and whatever is going on is making the boxes a lot less
usable than they should be...

- John 'Warthog9' Hawley

Additional background:

Boxes in question are a DL380 G7 and DL380 G6 respectively, the former
with a pair of E5640 processors, 144G of RAM.  The later has a pair of
X5550 processors and 144G of ram.  They share identical storage
configurations, comprising two P812 raid cards and a smaller 410i (the
G7's is onboard, the G6's is a separate add-on card)
