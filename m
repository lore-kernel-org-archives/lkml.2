Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab1FFJnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab1FFJnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:43:31 -0400
Subject: GFS2: Pull request (fix)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 06 Jun 2011 10:44:27 +0100
Message-ID: <1307353467.2880.4.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following change. Since there is only
one patch I included it at the end of this email rather than as a
separate message,

Steve.

-------------------------------------------------------------------------------

The following changes since commit 1fa7b6a29c61358cc2ca6f64cef4aa0e1a7ca74c:

  Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not configured" (2011-06-02 06:11:24 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Bob Peterson (1):
      GFS2: Processes waiting on inode glock that no processes are holding

 fs/gfs2/glock.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

--------------------------------------------------------------------------------------------

>From f90e5b5b136ede1f0fd15999e95f13124d6b0dbd Mon Sep 17 00:00:00 2001
From: Bob Peterson <rpeterso@redhat.com>
Date: Tue, 24 May 2011 10:44:42 -0400
Subject: [PATCH] GFS2: Processes waiting on inode glock that no processes are holding

This patch fixes a race in the GFS2 glock state machine that may
result in lockups.  The symptom is that all nodes but one will
hang, waiting for a particular glock.  All the holder records
will have the "W" (Waiting) bit set.  The other node will
typically have the glock stuck in Exclusive mode (EX) with no
holder records, but the dinode will be cached.  In other words,
an entry with "I:" will appear in the glock dump for that glock,
but nothing else.

The race has to do with the glock "Pending Demote" bit, which
can be set, then immediately reset, thus losing the fact that
another node needs the glock.  The sequence of events is:

1. Something schedules the glock workqueue (e.g. glock request from fs)
2. The glock workqueue gets to the point between the test of the reply pending
bit and the spin lock:

        if (test_and_clear_bit(GLF_REPLY_PENDING, &gl->gl_flags)) {
                finish_xmote(gl, gl->gl_reply);
                drop_ref = 1;
        }
        down_read(&gfs2_umount_flush_sem);         <---- i.e. here
        spin_lock(&gl->gl_spin);

3. In comes (a) the reply to our EX lock request setting GLF_REPLY_PENDING and
            (b) the demote request which sets GLF_PENDING_DEMOTE

4. The following test is executed:

        if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
            gl->gl_state != LM_ST_UNLOCKED &&
            gl->gl_demote_state != LM_ST_EXCLUSIVE) {

This resets the pending demote flag, and gl->gl_demote_state is not equal to
exclusive, however because the reply from the dlm arrived after we checked for
the GLF_REPLY_PENDING flag, gl->gl_state is still equal to unlocked, so
although we reset the GLF_PENDING_DEMOTE flag, we didn't then set the
GLF_DEMOTE flag or reinstate the GLF_PENDING_DEMOTE_FLAG.

The patch closes the timing window by only transitioning the
"Pending demote" bit to the "demote" flag once we know the
other conditions (not unlocked and not exclusive) are met.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a2a6abb..7137750 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -663,14 +663,19 @@ static void glock_work_func(struct work_struct *work)
 		drop_ref = 1;
 	}
 	spin_lock(&gl->gl_spin);
-	if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
+	if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
 	    gl->gl_state != LM_ST_UNLOCKED &&
 	    gl->gl_demote_state != LM_ST_EXCLUSIVE) {
 		unsigned long holdtime, now = jiffies;
+
 		holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
 		if (time_before(now, holdtime))
 			delay = holdtime - now;
-		set_bit(delay ? GLF_PENDING_DEMOTE : GLF_DEMOTE, &gl->gl_flags);
+
+		if (!delay) {
+			clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags);
+			set_bit(GLF_DEMOTE, &gl->gl_flags);
+		}
 	}
 	run_queue(gl, 0);
 	spin_unlock(&gl->gl_spin);
-- 
1.7.4




