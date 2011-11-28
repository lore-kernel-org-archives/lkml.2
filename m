Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1K1PWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:22:08 -0500
Received: from postman.teamix.net ([194.150.191.120]:33682 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751427Ab1K1PWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:22:06 -0500
From: Martin Steigerwald <ms@teamix.de>
Organization: teamix GmbH
To: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] Replace io by I/O where approbiate.
Date: Mon, 28 Nov 2011 16:22:01 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-686-pae; KDE/4.6.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
References: <201111281542.22258.ms@teamix.de> <4ED39EA5.4000706@kernel.dk>
In-Reply-To: <4ED39EA5.4000706@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201111281622.02200.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. November 2011 schrieb Jens Axboe:
> On 2011-11-28 15:42, Martin Steigerwald wrote:
> > Hi jens und Vivek,
> > 
> > Vivek, I cc'd you, cause you wrote the new cfq-iosched.txt.
> > 
> > 
> > In trying to understand how I/O priorities actually really work, I tried
> > to dd with
> > 
> > rm nullen-id ; sync ; /usr/bin/time ionice -c3 dd if=/dev/zero
> > of=nullen-id count=500 bs=1M conv=fsync
> > 
> > versus
> > 
> > rm nullen-rl; sync ; /usr/bin/time ionice -c1 -n0 dd if=/dev/zero
> > of=nullen-rl count=500 bs=1M conv=fsync
> > 
> > concurrently. No differences. At first I was puzzled, then I thought
> > maybe direct I/O makes a difference. So I tried with oflag=direct.
> > 
> > And it does.
> > 
> > Then I actually read the documentation block/ioprio.txt (3.1 here):
> >> With the introduction of cfq v3 (aka cfq-ts or time sliced cfq), basic
> >> io priorities are supported for reads on files.  This enables users to
> >> io nice processes or process groups, similar to what has been possible
> >> with cpu scheduling for ages.  This document mainly details the current
> >> possibilities with cfq; other io schedulers do not support io priorities
> >> thus far.
> > 
> > According to it I/O priorities will even only work on reads. Is that
> > correct? I mean they do work on reads, I tested it, but *only* on reads?
> > 
> > From what I see here, it also works for direct I/O write requests
> > 
> > So from what I conclude is that CFQ I/O priorities work for all requests
> > that are issued via synchronous system calls, but not for those issued
> > via asynchronous calls, i. e. everything that goes through the
> > pagecache.
> > 
> > Is that correct?
> 
> Priorities work for reads AND direct writes. In other words, it does not
> work for buffered writes.

I also replaced io by I/O where approbiate:

>From 10a319a1c1782e40c84fddb79f0f7ed719ece774 Mon Sep 17 00:00:00 2001
From: Martin Steigerwald <ms@teamix.de>
Date: Mon, 28 Nov 2011 16:12:55 +0100
Subject: [PATCH 2/3] Replace io by I/O where approbiate.

---
 Documentation/block/ioprio.txt |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/block/ioprio.txt b/Documentation/block/ioprio.txt
index a555c59..4775a95 100644
--- a/Documentation/block/ioprio.txt
+++ b/Documentation/block/ioprio.txt
@@ -5,37 +5,37 @@ Block io priorities
 Intro
 -----
 
-With the introduction of cfq v3 (aka cfq-ts or time sliced cfq), basic io
+With the introduction of cfq v3 (aka cfq-ts or time sliced cfq), basic I/O
 priorities are supported for reads and direct, not buffered, writes on files
-This enables users to io nice processes or process groups, similar to what
+This enables users to I/O nice processes or process groups, similar to what
 has been possible with cpu scheduling for ages. This document mainly details
-the current possibilities with cfq; other io schedulers do not support io
+the current possibilities with cfq; other I/O schedulers do not support I/O
 priorities thus far.
 
 Scheduling classes
 ------------------
 
-CFQ implements three generic scheduling classes that determine how io is
+CFQ implements three generic scheduling classes that determine how I/O is
 served for a process.
 
-IOPRIO_CLASS_RT: This is the realtime io class. This scheduling class is given
+IOPRIO_CLASS_RT: This is the realtime I/O class. This scheduling class is given
 higher priority than any other in the system, processes from this class are
 given first access to the disk every time. Thus it needs to be used with some
-care, one io RT process can starve the entire system. Within the RT class,
+care, one I/O RT process can starve the entire system. Within the RT class,
 there are 8 levels of class data that determine exactly how much time this
 process needs the disk for on each service. In the future this might change
 to be more directly mappable to performance, by passing in a wanted data
 rate instead.
 
 IOPRIO_CLASS_BE: This is the best-effort scheduling class, which is the default
-for any process that hasn't set a specific io priority. The class data
-determines how much io bandwidth the process will get, it's directly mappable
+for any process that hasn't set a specific I/O priority. The class data
+determines how much I/O bandwidth the process will get, it's directly mappable
 to the cpu nice levels just more coarsely implemented. 0 is the highest
-BE prio level, 7 is the lowest. The mapping between cpu nice level and io
+BE prio level, 7 is the lowest. The mapping between cpu nice level and I/O
 nice level is determined as: io_nice = (cpu_nice + 20) / 5.
 
 IOPRIO_CLASS_IDLE: This is the idle scheduling class, processes running at this
-level only get io time when no one else needs the disk. The idle class has no
+level only get I/O time when no one else needs the disk. The idle class has no
 class data, since it doesn't really apply here.
 
 Tools
-- 
1.7.7.3


Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
