Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2DTA10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:27:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab2DTA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:27:25 -0400
Date: Thu, 19 Apr 2012 17:27:15 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-6a1ea279c210e7dc05de86dc29c0d4f577f484fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1334794610-5546-1-git-send-email-hpa@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable: Add early_fixup_exception()
Git-Commit-ID: 6a1ea279c210e7dc05de86dc29c0d4f577f484fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:27:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a1ea279c210e7dc05de86dc29c0d4f577f484fb
Gitweb:     http://git.kernel.org/tip/6a1ea279c210e7dc05de86dc29c0d4f577f484fb
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 19 Apr 2012 15:24:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:31:04 -0700

x86, extable: Add early_fixup_exception()

Add a restricted version of fixup_exception() to be used during early
boot only.  In particular, this doesn't support the try..catch variant
since we may not have a thread_info set up yet.

This relies on the exception table being sorted already at build time.

Link: http://lkml.kernel.org/r/1334794610-5546-1-git-send-email-hpa@zytor.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/extable.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 1fb85db..5555675 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -35,3 +35,20 @@ int fixup_exception(struct pt_regs *regs)
 
 	return 0;
 }
+
+/* Restricted version used during very early boot */
+int __init early_fixup_exception(unsigned long *ip)
+{
+	const struct exception_table_entry *fixup;
+
+	fixup = search_exception_tables(*ip);
+	if (fixup) {
+		if (fixup->fixup < 16)
+			return 0; /* Not supported during early boot */
+
+		*ip = fixup->fixup;
+		return 1;
+	}
+
+	return 0;
+}
