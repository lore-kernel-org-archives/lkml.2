Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2DTAVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:21:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2DTAVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:21:38 -0400
Date: Thu, 19 Apr 2012 17:21:25 -0700
From: tip-bot for David Daney <david.daney@cavium.com>
Message-ID: <tip-d219e2e86a407035303b987e4184ca0b1de53257@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1334872799-14589-3-git-send-email-ddaney.cavm@gmail.com>
References: <1334872799-14589-3-git-send-email-ddaney.cavm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] extable: Skip sorting if sorted at build time.
Git-Commit-ID: d219e2e86a407035303b987e4184ca0b1de53257
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:21:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d219e2e86a407035303b987e4184ca0b1de53257
Gitweb:     http://git.kernel.org/tip/d219e2e86a407035303b987e4184ca0b1de53257
Author:     David Daney <david.daney@cavium.com>
AuthorDate: Thu, 19 Apr 2012 14:59:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:06:55 -0700

extable: Skip sorting if sorted at build time.

If the build program sortextable has already sorted the exception
table, don't sort it again.

Signed-off-by: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/1334872799-14589-3-git-send-email-ddaney.cavm@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/extable.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 5339705..fe35a63 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -35,10 +35,16 @@ DEFINE_MUTEX(text_mutex);
 extern struct exception_table_entry __start___ex_table[];
 extern struct exception_table_entry __stop___ex_table[];
 
+/* Cleared by build time tools if the table is already sorted. */
+u32 __initdata main_extable_sort_needed = 1;
+
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
 {
-	sort_extable(__start___ex_table, __stop___ex_table);
+	if (main_extable_sort_needed)
+		sort_extable(__start___ex_table, __stop___ex_table);
+	else
+		pr_notice("__ex_table already sorted, skipping sort\n");
 }
 
 /* Given an address, look for it in the exception tables. */
