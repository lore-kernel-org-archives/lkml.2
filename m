Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906Ab2EQMtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:49:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965770Ab2EQMs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/24] GFS2: Update glock doc to add new stats info
Date: Thu, 17 May 2012 13:23:28 +0100
Message-Id: <1337257411-3173-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently added some glock statistics to GFS2, so this is
a docs update to explain what they all mean. It is based
upon the checkin comment of the patch in question.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/Documentation/filesystems/gfs2-glocks.txt b/Documentation/filesystems/gfs2-glocks.txt
index 0494f78..fcc7995 100644
--- a/Documentation/filesystems/gfs2-glocks.txt
+++ b/Documentation/filesystems/gfs2-glocks.txt
@@ -61,7 +61,9 @@ go_unlock        | Called on the final local unlock of a lock
 go_dump          | Called to print content of object for debugfs file, or on
                  | error to dump glock to the log.
 go_type          | The type of the glock, LM_TYPE_.....
-go_min_hold_time | The minimum hold time
+go_callback	 | Called if the DLM sends a callback to drop this lock
+go_flags	 | GLOF_ASPACE is set, if the glock has an address space
+                 | associated with it
 
 The minimum hold time for each lock is the time after a remote lock
 grant for which we ignore remote demote requests. This is in order to
@@ -89,6 +91,7 @@ go_demote_ok  |       Sometimes         |       Yes
 go_lock       |       Yes               |       No
 go_unlock     |       Yes               |       No
 go_dump       |       Sometimes         |       Yes
+go_callback   |       Sometimes (N/A)   |       Yes
 
 N.B. Operations must not drop either the bit lock or the spinlock
 if its held on entry. go_dump and do_demote_ok must never block.
@@ -111,4 +114,118 @@ itself (locking order as above), and the other, known as the iopen
 glock is used in conjunction with the i_nlink field in the inode to
 determine the lifetime of the inode in question. Locking of inodes
 is on a per-inode basis. Locking of rgrps is on a per rgrp basis.
+In general we prefer to lock local locks prior to cluster locks.
+
+                            Glock Statistics
+                           ------------------
+
+The stats are divided into two sets: those relating to the
+super block and those relating to an individual glock. The
+super block stats are done on a per cpu basis in order to
+try and reduce the overhead of gathering them. They are also
+further divided by glock type. All timings are in nanoseconds.
+
+In the case of both the super block and glock statistics,
+the same information is gathered in each case. The super
+block timing statistics are used to provide default values for
+the glock timing statistics, so that newly created glocks
+should have, as far as possible, a sensible starting point.
+The per-glock counters are initialised to zero when the
+glock is created. The per-glock statistics are lost when
+the glock is ejected from memory.
+
+The statistics are divided into three pairs of mean and
+variance, plus two counters. The mean/variance pairs are
+smoothed exponential estimates and the algorithm used is
+one which will be very familiar to those used to calculation
+of round trip times in network code. See "TCP/IP Illustrated,
+Volume 1", W. Richard Stevens, sect 21.3, "Round-Trip Time Measurement",
+p. 299 and onwards. Also, Volume 2, Sect. 25.10, p. 838 and onwards.
+Unlike the TCP/IP Illustrated case, the mean and variance are
+not scaled, but are in units of integer nanoseconds.
+
+The three pairs of mean/variance measure the following
+things:
+
+ 1. DLM lock time (non-blocking requests)
+ 2. DLM lock time (blocking requests)
+ 3. Inter-request time (again to the DLM)
+
+A non-blocking request is one which will complete right
+away, whatever the state of the DLM lock in question. That
+currently means any requests when (a) the current state of
+the lock is exclusive, i.e. a lock demotion (b) the requested
+state is either null or unlocked (again, a demotion) or (c) the
+"try lock" flag is set. A blocking request covers all the other
+lock requests.
+
+There are two counters. The first is there primarily to show
+how many lock requests have been made, and thus how much data
+has gone into the mean/variance calculations. The other counter
+is counting queuing of holders at the top layer of the glock
+code. Hopefully that number will be a lot larger than the number
+of dlm lock requests issued.
+
+So why gather these statistics? There are several reasons
+we'd like to get a better idea of these timings:
+
+1. To be able to better set the glock "min hold time"
+2. To spot performance issues more easily
+3. To improve the algorithm for selecting resource groups for
+allocation (to base it on lock wait time, rather than blindly
+using a "try lock")
+
+Due to the smoothing action of the updates, a step change in
+some input quantity being sampled will only fully be taken
+into account after 8 samples (or 4 for the variance) and this
+needs to be carefully considered when interpreting the
+results.
+
+Knowing both the time it takes a lock request to complete and
+the average time between lock requests for a glock means we
+can compute the total percentage of the time for which the
+node is able to use a glock vs. time that the rest of the
+cluster has its share. That will be very useful when setting
+the lock min hold time.
+
+Great care has been taken to ensure that we
+measure exactly the quantities that we want, as accurately
+as possible. There are always inaccuracies in any
+measuring system, but I hope this is as accurate as we
+can reasonably make it.
+
+Per sb stats can be found here:
+/sys/kernel/debug/gfs2/<fsname>/sbstats
+Per glock stats can be found here:
+/sys/kernel/debug/gfs2/<fsname>/glstats
+
+Assuming that debugfs is mounted on /sys/kernel/debug and also
+that <fsname> is replaced with the name of the gfs2 filesystem
+in question.
+
+The abbreviations used in the output as are follows:
+
+srtt     - Smoothed round trip time for non-blocking dlm requests
+srttvar  - Variance estimate for srtt
+srttb    - Smoothed round trip time for (potentially) blocking dlm requests
+srttvarb - Variance estimate for srttb
+sirt     - Smoothed inter-request time (for dlm requests)
+sirtvar  - Variance estimate for sirt
+dlm      - Number of dlm requests made (dcnt in glstats file)
+queue    - Number of glock requests queued (qcnt in glstats file)
+
+The sbstats file contains a set of these stats for each glock type (so 8 lines
+for each type) and for each cpu (one column per cpu). The glstats file contains
+a set of these stats for each glock in a similar format to the glocks file, but
+using the format mean/variance for each of the timing stats.
+
+The gfs2_glock_lock_time tracepoint prints out the current values of the stats
+for the glock in question, along with some addition information on each dlm
+reply that is received:
+
+status - The status of the dlm request
+flags  - The dlm request flags
+tdiff  - The time taken by this specific request
+(remaining fields as per above list)
+
 
-- 
1.7.4

