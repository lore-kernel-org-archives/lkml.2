Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0DVUOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:14:42 -0400
Received: from kroah.org ([198.145.64.141]:59881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab0DVUBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:07 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:14 2010
Message-Id: <20100422195414.284203075@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Perepechko <andrew.perepechko@sun.com>, Jan Kara <jack@suse.cz>
Subject: [091/139] quota: Fix possible dq_flags corruption
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Perepechko <andrew.perepechko@sun.com>

commit 08261673cb6dc638c39f44d69b76fffb57b92a8b upstream.

dq_flags are modified non-atomically in do_set_dqblk via __set_bit calls and
atomically for example in mark_dquot_dirty or clear_dquot_dirty.  Hence a
change done by an atomic operation can be overwritten by a change done by a
non-atomic one. Fix the problem by using atomic bitops even in do_set_dqblk.

Signed-off-by: Andrew Perepechko <andrew.perepechko@sun.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/quota/dquot.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2321,34 +2321,34 @@ static int do_set_dqblk(struct dquot *dq
 	if (di->dqb_valid & QIF_SPACE) {
 		dm->dqb_curspace = di->dqb_curspace - dm->dqb_rsvspace;
 		check_blim = 1;
-		__set_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags);
+		set_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_BLIMITS) {
 		dm->dqb_bsoftlimit = qbtos(di->dqb_bsoftlimit);
 		dm->dqb_bhardlimit = qbtos(di->dqb_bhardlimit);
 		check_blim = 1;
-		__set_bit(DQ_LASTSET_B + QIF_BLIMITS_B, &dquot->dq_flags);
+		set_bit(DQ_LASTSET_B + QIF_BLIMITS_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_INODES) {
 		dm->dqb_curinodes = di->dqb_curinodes;
 		check_ilim = 1;
-		__set_bit(DQ_LASTSET_B + QIF_INODES_B, &dquot->dq_flags);
+		set_bit(DQ_LASTSET_B + QIF_INODES_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_ILIMITS) {
 		dm->dqb_isoftlimit = di->dqb_isoftlimit;
 		dm->dqb_ihardlimit = di->dqb_ihardlimit;
 		check_ilim = 1;
-		__set_bit(DQ_LASTSET_B + QIF_ILIMITS_B, &dquot->dq_flags);
+		set_bit(DQ_LASTSET_B + QIF_ILIMITS_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_BTIME) {
 		dm->dqb_btime = di->dqb_btime;
 		check_blim = 1;
-		__set_bit(DQ_LASTSET_B + QIF_BTIME_B, &dquot->dq_flags);
+		set_bit(DQ_LASTSET_B + QIF_BTIME_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_ITIME) {
 		dm->dqb_itime = di->dqb_itime;
 		check_ilim = 1;
-		__set_bit(DQ_LASTSET_B + QIF_ITIME_B, &dquot->dq_flags);
+		set_bit(DQ_LASTSET_B + QIF_ITIME_B, &dquot->dq_flags);
 	}
 
 	if (check_blim) {


