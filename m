Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3AAVQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:16:40 -0500
Received: from nm1-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.94]:29607
	"EHLO nm1-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab3AAVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:16:37 -0500
X-Yahoo-Newman-Id: 120148.17119.bm@smtp109.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ce2lUVwVM1mQWqgDjHAl2TQF8rI2K0HmZ84mOkFDP08Q0ie
 SeBP48raLfzLYaCyBZ0ZN.lpnTV05CHMo7dlAkkyJ8I3OSAWdDu6tFQIVEVK
 skwJ7e1tNHfiLm7mZ41oYDMMpzDAlXDWThhr6.ziGZpFJTLqGaC.B1xdZYNO
 xOXqzNbCHJJxcXigtDKyRKa9Mxxp_rcdPhmQTueSoDzThTyg1yS8MZXpgs0W
 7lsgci7lojQ_dfmMBqwSecyC7jNpLbk4T8xhdFPIHy1_JZlfoVwkkrPjCKwz
 mRxjkOuUF5JLC4KS8.W6awvw9VZsIUrpDBzhNoKeEsVIpqiku_2BiXXn7v4n
 gT4Z4UwRdsddCgTap9q3S.RALx6lljU2LI493_whqQySwApvbSvm7_H40y73
 vtXyAGGCI_S.v4.09l.UurNMvoATJI0hOhiL0tbxxxxpUevcgvF.8bRwQqxf
 g3qM_YGgUps5W2nRzXl4h7P_dAoo.
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
Subject: [PATCH v7 6/9] bug.h: Prevent double evaulation of in BUILD_BUG_ON
Date: Tue,  1 Jan 2013 15:09:54 -0600
Message-Id: <1357074597-21722-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
References: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
 <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
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

