Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0EAOsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:48:07 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63918 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab0EAOfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:35:18 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Smith <danms@us.ibm.com>,
       linux-s390@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v21 059/100] c/r: add CKPT_COPY() macro
Date: Sat,  1 May 2010 10:15:41 -0400
Message-Id: <1272723382-19470-60-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Smith <danms@us.ibm.com>

As suggested by Dave[1], this provides us a way to make the copy-in and
copy-out processes symmetric.  CKPT_COPY_ARRAY() provides us a way to do
the same thing but for arrays.  It's not critical, but it helps us unify
the checkpoint and restart paths for some things.

Changelog:
    Mar 04:
            . Removed semicolons
            . Added build-time check for __must_be_array in CKPT_COPY_ARRAY
    Feb 27:
            . Changed CKPT_COPY() to use assignment, eliminating the need
              for the CKPT_COPY_BIT() macro
            . Add CKPT_COPY_ARRAY() macro to help copying register arrays,
              etc
            . Move the macro definitions inside the CR #ifdef
    Feb 25:
            . Changed WARN_ON() to BUILD_BUG_ON()

Cc: linux-s390@vger.kernel.org
Signed-off-by: Dan Smith <danms@us.ibm.com>
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>

1: https://lists.linux-foundation.org/pipermail/containers/2009-February/015821.html (all the way at the bottom)
---
 include/linux/checkpoint.h |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index 2f72a6a..cd76f70 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -246,6 +246,34 @@ static inline int ckpt_validate_errno(int errno)
 	return (errno >= 0) && (errno < MAX_ERRNO);
 }
 
+/* useful macros to copy fields and buffers to/from ckpt_hdr_xxx structures */
+#define CKPT_CPT 1
+#define CKPT_RST 2
+
+#define CKPT_COPY(op, SAVE, LIVE)				        \
+	do {							\
+		if (op == CKPT_CPT)				\
+			SAVE = LIVE;				\
+		else						\
+			LIVE = SAVE;				\
+	} while (0)
+
+/*
+ * Copy @count items from @LIVE to @SAVE if op is CKPT_CPT (otherwise,
+ * copy in the reverse direction)
+ */
+#define CKPT_COPY_ARRAY(op, SAVE, LIVE, count)				\
+	do {								\
+		(void)__must_be_array(SAVE);				\
+		(void)__must_be_array(LIVE);				\
+		BUILD_BUG_ON(sizeof(*SAVE) != sizeof(*LIVE));		\
+		if (op == CKPT_CPT)					\
+			memcpy(SAVE, LIVE, count * sizeof(*SAVE));	\
+		else							\
+			memcpy(LIVE, SAVE, count * sizeof(*SAVE));	\
+	} while (0)
+
+
 /* debugging flags */
 #define CKPT_DBASE	0x1		/* anything */
 #define CKPT_DSYS	0x2		/* generic (system) */
-- 
1.6.3.3

