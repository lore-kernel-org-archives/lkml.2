Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3AAWyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:54:37 -0500
Received: from nm20.access.bullet.mail.mud.yahoo.com ([66.94.237.221]:32206
	"EHLO nm20.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab3AAWy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:29 -0500
X-Yahoo-Newman-Id: 45703.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DQ212_MVM1ny1sOnFnYnL4ozFMd0cR0kA8.ZTgXBYFpPU1e
 Wn19ODktlRcvCZRqjsFV.LD44Mf4eUNleyuJjKdwfbMmFyLiRvAPv0Yp4ekB
 glhQbhwjkJxvpbTZ2SKxFbQ0QgxiqMkF7b5nr.EAquR2VqDpB7KCTvbc6RHi
 6fEpK581Zwuy8uP.PfupsrH0yB2XNaUPLtSDPKg4Q_kr2pSFsbdUZTanxfGm
 E6yYbFciXu6rWWljv0ccYaDtknusACnXQD6sFNWsUtxUjAMrIFQq.QSvzXTK
 qMdD5x_hC70a_LrUJCKgxCYg1d_i4Zlcj.KkUXVX4vQC1e2Wo0aSZQ32CVTI
 CNOHGSp0NBsiAvT_MjSbIo1x8pyXCKjTY8YQVOXMdgiZm6aSMBeaxwMliXJy
 cAAuWeisYhWhq9M3cgQD5Z_4OtEawR2TW6fnwc4Em.7uTiDtO1t6yfA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v8 6/9] bug.h: Prevent double evaulation of in BUILD_BUG_ON
Date: Tue,  1 Jan 2013 16:54:08 -0600
Message-Id: <1357080851-30938-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling BUILD_BUG_ON in an optimized build using gcc 4.3 and later,
the condition will be evaulated twice, possibily with side-effects.
This patch eliminates that error.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 27d404f..0d75762 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -59,8 +59,9 @@ struct pt_regs;
 extern int __build_bug_on_failed;
 #define BUILD_BUG_ON(condition)					\
 	do {							\
-		((void)sizeof(char[1 - 2*!!(condition)]));	\
-		if (condition) __build_bug_on_failed = 1;	\
+		bool __cond = !!(condition);			\
+		((void)sizeof(char[1 - 2 * __cond]));		\
+		if (__cond) __build_bug_on_failed = 1;		\
 	} while(0)
 #endif
 
-- 
1.7.8.6

