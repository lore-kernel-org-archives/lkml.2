Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab2JTBGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2JTBGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:06:44 -0400
Date: Fri, 19 Oct 2012 18:06:16 -0700
From: tip-bot for Gerald Schaefer <gerald.schaefer@de.ibm.com>
Message-ID: <tip-ca6cfbe6d25cdf9ed81cbf26c2146eda17a70472@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, schwidefsky@de.ibm.com,
        gerald.schaefer@de.ibm.com, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, peterz@infradead.org,
        gerald.schaefer@de.ibm.com, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, sfr@canb.auug.org.au, tglx@linutronix.de
In-Reply-To: <20121018182642.2a541275@thinkpad>
References: <20121018182642.2a541275@thinkpad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] s390/thp: implement pmd_pgprot() for s390
Git-Commit-ID: ca6cfbe6d25cdf9ed81cbf26c2146eda17a70472
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:06:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca6cfbe6d25cdf9ed81cbf26c2146eda17a70472
Gitweb:     http://git.kernel.org/tip/ca6cfbe6d25cdf9ed81cbf26c2146eda17a70472
Author:     Gerald Schaefer <gerald.schaefer@de.ibm.com>
AuthorDate: Thu, 18 Oct 2012 18:26:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Oct 2012 23:38:48 +0200

s390/thp: implement pmd_pgprot() for s390

Git commit "mm/thp: Preserve pgprot across huge page split"
introduced a pmd_pgprot() function, which is missing
on s390, resulting in a compile error in linux-next where
THP is enabled on s390 as well.

This patch adds an implementation of pmd_pgprot() for s390.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Link: http://lkml.kernel.org/r/20121018182642.2a541275@thinkpad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/s390/include/asm/pgtable.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index dd647c9..098fc5a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1240,6 +1240,19 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	*pmdp = entry;
 }
 
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	pgprot_t prot = PAGE_RW;
+
+	if (pmd_val(pmd) & _SEGMENT_ENTRY_RO) {
+		if (pmd_val(pmd) & _SEGMENT_ENTRY_INV)
+			prot = PAGE_NONE;
+		else
+			prot = PAGE_RO;
+	}
+	return prot;
+}
+
 static inline unsigned long massage_pgprot_pmd(pgprot_t pgprot)
 {
 	unsigned long pgprot_pmd = 0;
