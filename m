Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0JROhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab0JROhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:37 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/22] GFS2: Don't enforce min hold time when two demotes occur in rapid succession
Date: Mon, 18 Oct 2010 15:15:31 +0100
Message-Id: <1287411346-17855-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the design of the VFS, it is quite usual for operations on GFS2
to consist of a lookup (requiring a shared lock) followed by an
operation requiring an exclusive lock. If a remote node has cached an
exclusive lock, then it will receive two demote events in rapid succession
firstly for a shared lock and then to unlocked. The existing min hold time
code was triggering in this case, even if the node was otherwise idle
since the state change time was being updated by the initial demote.

This patch introduces logic to skip the min hold timer in the case that
a "double demote" of this kind has occurred. The min hold timer will
still be used in all other cases.

A new glock flag is introduced which is used to keep track of whether
there have been any newly queued holders since the last glock state
change. The min hold time is only applied if the flag is set.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 9adf8f9..8e478e2 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -441,6 +441,8 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 		else
 			gfs2_glock_put_nolock(gl);
 	}
+	if (held1 && held2 && list_empty(&gl->gl_holders))
+		clear_bit(GLF_QUEUED, &gl->gl_flags);
 
 	gl->gl_state = new_state;
 	gl->gl_tchange = jiffies;
@@ -1012,6 +1014,7 @@ fail:
 		if (unlikely((gh->gh_flags & LM_FLAG_PRIORITY) && !insert_pt))
 			insert_pt = &gh2->gh_list;
 	}
+	set_bit(GLF_QUEUED, &gl->gl_flags);
 	if (likely(insert_pt == NULL)) {
 		list_add_tail(&gh->gh_list, &gl->gl_holders);
 		if (unlikely(gh->gh_flags & LM_FLAG_PRIORITY))
@@ -1310,10 +1313,12 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 
 	gfs2_glock_hold(gl);
 	holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
-	if (time_before(now, holdtime))
-		delay = holdtime - now;
-	if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
-		delay = gl->gl_ops->go_min_hold_time;
+	if (test_bit(GLF_QUEUED, &gl->gl_flags)) {
+		if (time_before(now, holdtime))
+			delay = holdtime - now;
+		if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
+			delay = gl->gl_ops->go_min_hold_time;
+	}
 
 	spin_lock(&gl->gl_spin);
 	handle_callback(gl, state, delay);
@@ -1660,6 +1665,8 @@ static const char *gflags2str(char *buf, const unsigned long *gflags)
 		*p++ = 'I';
 	if (test_bit(GLF_FROZEN, gflags))
 		*p++ = 'F';
+	if (test_bit(GLF_QUEUED, gflags))
+		*p++ = 'q';
 	*p = 0;
 	return buf;
 }
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 578234b..b12ca10 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -196,6 +196,7 @@ enum {
 	GLF_REPLY_PENDING		= 9,
 	GLF_INITIAL			= 10,
 	GLF_FROZEN			= 11,
+	GLF_QUEUED			= 12,
 };
 
 struct gfs2_glock {
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 148d55c..cedb0bb 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -39,7 +39,8 @@
 	{(1UL << GLF_INVALIDATE_IN_PROGRESS),	"i" },		\
 	{(1UL << GLF_REPLY_PENDING),		"r" },		\
 	{(1UL << GLF_INITIAL),			"I" },		\
-	{(1UL << GLF_FROZEN),			"F" })
+	{(1UL << GLF_FROZEN),			"F" },		\
+	{(1UL << GLF_QUEUED),			"q" })
 
 #ifndef NUMPTY
 #define NUMPTY
-- 
1.7.1.1

