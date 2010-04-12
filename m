Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0DLSzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:55:36 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:19522 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0DLSzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:55:35 -0400
From: Chris Mason <chris.mason@oracle.com>
To: chris.mason@oracle.com, zach.brown@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH RFC] Optimize semtimedop
Date: Mon, 12 Apr 2010 14:49:21 -0400
Message-Id: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
X-Mailer: git-send-email 1.7.0.3
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BC36C9B.01A5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been poking around in semtimedop for a while now, mostly because
it is consistently showing up at the top of the CPU profiles for benchmarking
runs on big numa systems.  The biggest problem seems to be the IPC lock, and
the fact that we hold it for a long time while we loop over different lists and
try to do semaphore operations.

Zach Brown came up with a set of patches a while ago that switched away from
the global pending list, and semtimedop was recently optimized for the
single sop case by Nick and Manfred.

This patch series tries to build on ideas from all of these patches.  The
list of pending semaphore operations is pushed down to the individual
semaphore and the locking is also pushed down into the semaphore.  The
result is much faster with my micro benchmark:

http://oss.oracle.com/~mason/sembench.c

It more than doubles the total number of post/wait cycles the benchmark
is able to get in 30s.  Before this patch, semtimedop scored about the
same as futexes for the post/wait cycles, and so now it is 2x faster.

I did run this code through all of the ltp ipc tests, and later this week I
hope to get a full tpc database benchmark on it.

