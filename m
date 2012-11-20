Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2KTVF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:05:26 -0500
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:28500
	"EHLO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab2KTVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:05:21 -0500
X-Yahoo-Newman-Id: 243390.4524.bm@smtp108.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UWyr_xQVM1lK1T1TRR43bupvc8b0I8ZjEMyDeN7_Vx_dWY1
 cGsmh9ElF5D9VCRPUrxBDTiwpFcdW2x69.XxXR37SVSzUDMdbGuCHifx6dzQ
 rGycaIM1gjBnkpg8lmUsFlLbFMagTmq9wWIKTlLjgqUAlxDFwMYes3id8ldl
 OG_RDRxigUjM2XExtgD99IcVWiK7g8mFxdDGRnEW2.I4U2eoeQCGmRlhWNYJ
 mtOueZZYlRimXStpenJqMliXyPKvmD9Iknkc44yplNEP7VWoxutWEbPeHC4U
 HYRM2AiJpYkcQWWoRt89PVKp_npzKvjki_qyGWtC1B7ifRtg.i4Z8nT9Fh.z
 vUHsb1jyxx2vYwRC5e61CJ5U348HkLPIAk7xK1Jcuh_NJi2_QeTdECsUWMGh
 5Lu4q8YcpBe3ruiqhHW5hLwEKgq207W2cfakJWc39MzxZC2juTVCq
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
Subject: [PATCH v6 6/9] bug.h: Prevent double evaulation of in BUILD_BUG_ON
Date: Tue, 20 Nov 2012 15:05:04 -0600
Message-Id: <1353445507-7233-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
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
index 1b2465d..98bdbb3d 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -58,8 +58,9 @@ struct pt_regs;
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
1.7.3.4

