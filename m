Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489Ab0GPMtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:49:33 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40004 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965398Ab0GPMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:13 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 00/16] kill unnecessary bdi wakeups + cleanups
Date: Fri, 16 Jul 2010 15:44:56 +0300
Message-Id: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
X-OriginalArrivalTime: 16 Jul 2010 12:48:56.0586 (UTC) FILETIME=[40F156A0:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a series of patches which lessens amount of unnecessary wake-ups in
the linux kernel.

THE PROBLEM
~~~~~~~~~~~

Each block device has corresponding "flusher" thread, which are usually seen
as "flusher-x:y" in your 'ps' output. Flusher threads are responsible to do
background write-back for different kernel code paths like memory reclamation
as well as the periodic background writeout.

The flusher threads wake up every 5 seconds and check whether they have to
write anything back or not. In idle systems with good dynamic power-management
this means that they force it to wake up from deep sleep, find out that there
is nothing to do, and waste power. This hurts small battery-powered devices,
e.g., linux-based phones.

But idle wake-ups do not last forever, the bdi threads kill themselves if
nothing useful has been done for 5 minutes.

Also, there is the bdi forker thread, seen as 'bdi-default' in your 'ps'
output. This thread also wakes up every 5 seconds and checks whether it has to
fork a bid flusher thread, in case there is dirt to write-back, but the thread
was killed. This is also bad for battery-powered embedded devices.

SOLUTION
~~~~~~~~

This patch set makes bdi threads and the forker thread wake-up only if there is
job to do, otherwise they will sleep. The main idea is to wake-up the needed
thread when adding dirty data to the bdi.

To implement this:

1. I address various rare race conditions in the current code.
2. Then I move the killing logic from bdi threads to the forker thread, so that
we would have one central place where we make decisions about killing inactive
bdi threads. The reason I do this is because otherwise it is difficult to make
sure that a bdi thread does not decide to exit while you are waking it up.
3. I add a small piece of code to '__mark_inode_dirt()' which wakes up the bdi
   thread when dirty inodes arrive
4. There are also clean-up patches and nicification patches which I found to be
   good for better code readability.
5. Some patches are just preparations which make the following real patches
   simpler and easier to review.
6. Some patches are just simplifications of current code.

With this patchset bdi threads wake up considerably less.

This is RFC so far, because:
1. I'm new to this area
2. patches really need review
3. patches need more testing and polishing

Side note, there is another set of patches which are solving a similar problem
waiting for comments/acceptance:
http://thread.gmane.org/gmane.linux.file-systems/42834

Artem.
