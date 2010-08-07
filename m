Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278Ab0HGAaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:30:23 -0400
Received: from home.kolivas.org ([59.167.196.135]:58077 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0HGAaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:30:21 -0400
X-Greylist: delayed 1389 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2010 20:30:21 EDT
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BFS CPU scheduler v0.323 for 2.6.35
Date: Sat, 7 Aug 2010 10:07:09 +1000
User-Agent: KMail/1.13.5 (Linux/2.6.35-ck1; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008071007.09904.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to announce the availability of the updated BFS CPU scheduler for 
linux kernel v2.6.35.


http://ck.kolivas.org/patches/bfs/2.6.35-sched-bfs-323.patch


General BFS documentation:

http://ck.kolivas.org/patches/bfs/sched-BFS.txt


This will be included in 2.6.35-ck1 which is to be announced shortly. If time 
permits and demand is present I will slowly port v323 to some of the earlier 
kernels again.


Changes since the last announced version (0.318):

The most significant change has been some architectural change to work with 
changes in the mainline kernel as of 2.6.35. As suspend / halt and cpu offline 
code has been changed, the whole offline cpu/online cpu code had to be 
modified in BFS to suit. Previously an affined task that was bound to an 
offlining CPU had a temporary affinity placed in an "unplugged" CPU mask. This 
system was fragile and placed an extra cpumask_t into task struct, and really 
only worked for offlining of all CPUs during suspend/halt when all came back 
online. Now, tasks that are affined to CPUs that are not currently online can 
temporarily run on any CPU. This makes the system more robust and should work 
properly on all types of suspend/halt. Thanks to Radoslaw and others in #ck 
for pointing out this issue and helping test the modified version. None of 
this should be visible in userland unless you were already having suspend 
issues.

Alexei Podtelezhnikov pointed out that the code that modified the rr_interval 
was ugly and helped rework it to do close to what I desire in a much nicer 
fashion. Once again, the rr intervals have now been shrunk a little bit 
further, and do not go above 24ms on any sized machine by default. They can 
still be modified via /proc as per always. This may decrease throughput 
slightly but should keep latencies much more stable on the many-core machine.

Also thanks to Alexei, a number of microoptimisations were done in the 
SCHED_ISO refractory testing code. Should not be user visible.

Some debugging checks that weren't relevant to BFS were removed, and 
unnecessary preempt disable/enable calls were removed. May be user visible if 
you were getting warnings in dmesg previously.

CPU load calculation for use by the cpu frequency subsystem was improved to 
properly tell how busy each individual cpu was. This may cause noticeable 
improvements in how quickly cpufreq adapts to load in the ondemand governor.

The nohz_ratelimit function new in 2.6.35, and already noted to be buggy and 
slated for removal in 2.6.35.1 was added as a no op to prevent this bug from 
showing up on BFS, and to make easy patching come 2.6.35.1

Random other minor cleanups that I can't remember.


Enjoy!

-- 
-ck
