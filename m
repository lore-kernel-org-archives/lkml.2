Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab2DSWA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:00:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33009 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab2DSWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:00:11 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 2/5] extable: Skip sorting if sorted at build time.
Date: Thu, 19 Apr 2012 14:59:56 -0700
Message-Id: <1334872799-14589-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com>
References: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

If the build program sortextable has already sorted the exception
table, don't sort it again.

Signed-off-by: David Daney <david.daney@cavium.com>
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
-- 
1.7.2.3

