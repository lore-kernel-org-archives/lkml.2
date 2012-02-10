Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab2BJUbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:31:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49687 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753045Ab2BJUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:31:22 -0500
Date: Fri, 10 Feb 2012 15:31:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
cc: Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Bug in disk event polling
Message-ID: <Pine.LNX.4.44L0.1202101519020.1281-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun:

Don't ask me why this hasn't shown up earlier...  There's a big fat bug 
in the implementation of disk event polling.

The polling is done using the system_nrt_wq work queue, which isn't
freezable.  As a result, polling continues while the system is
preparing for suspend or hibernation.

Obviously I/O to suspended devices doesn't work well.  Somewhat less 
obviously, error recovery for the failed I/O attempts can interfere 
with normal system resume.

You can see this for yourself easily enough by suspending or
hibernating while a USB flash drive is plugged in.  You don't even need
to go through the full suspend procedure; the first two stages are
enough (echo devices >/sys/power/pm_test).  Check the system log
afterward; most likely you'll find the flash drive got errors and had
to be unregistered and re-enumerated.

I have verified that changing all occurrences of system_nrt_wq in 
block/genhd.c to system_freezable_wq fixes the bug.  However this may 
not be the way you want to solve it; you may prefer to have a freezable 
non-reentrant work queue.

Alan Stern

