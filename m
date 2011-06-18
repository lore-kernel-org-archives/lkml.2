Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1FRVFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 17:05:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:60439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1FRVFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 17:05:03 -0400
Date: Sat, 18 Jun 2011 21:04:49 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-40b7f3dfcc5ab211a0b8d916751bb22ac2290806@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, ben@decadent.org.uk, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com, ben@decadent.org.uk
In-Reply-To: <1302752223.5282.674.camel@localhost>
References: <1302752223.5282.674.camel@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD: Fix section header size check
Git-Commit-ID: 40b7f3dfcc5ab211a0b8d916751bb22ac2290806
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Jun 2011 21:04:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40b7f3dfcc5ab211a0b8d916751bb22ac2290806
Gitweb:     http://git.kernel.org/tip/40b7f3dfcc5ab211a0b8d916751bb22ac2290806
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 15 Jun 2011 15:34:57 +0200
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 17:23:54 +0200

x86, microcode, AMD: Fix section header size check

The ucode size check has to take the section header size into account
too when sanity checking the section length. Shorten and clarify define
names, while at it.

Caught-by: Ben Hutchings <ben@decadent.org.uk>
Link: http://lkml.kernel.org/r/1302752223.5282.674.camel@localhost
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index d30d67c..591be0e 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -66,8 +66,8 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define UCODE_CONTAINER_SECTION_HDR	8
-#define UCODE_CONTAINER_HEADER_SIZE	12
+#define SECTION_HDR_SIZE	8
+#define CONTAINER_HDR_SZ	12
 
 static struct equiv_cpu_entry *equiv_cpu_table;
 
@@ -177,7 +177,7 @@ static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
 
 	actual_size = *(u32 *)(buf + 4);
 
-	if (actual_size > size || actual_size > max_size) {
+	if (actual_size + SECTION_HDR_SIZE > size || actual_size > max_size) {
 		pr_err("section size mismatch\n");
 		return 0;
 	}
@@ -204,8 +204,8 @@ get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
 	if (!mc)
 		goto out;
 
-	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
-	*mc_size = actual_size + UCODE_CONTAINER_SECTION_HDR;
+	get_ucode_data(mc, buf + SECTION_HDR_SIZE, actual_size);
+	*mc_size = actual_size + SECTION_HDR_SIZE;
 
 out:
 	return mc;
@@ -229,9 +229,10 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return -ENOMEM;
 	}
 
-	get_ucode_data(equiv_cpu_table, buf + UCODE_CONTAINER_HEADER_SIZE, size);
+	get_ucode_data(equiv_cpu_table, buf + CONTAINER_HDR_SZ, size);
 
-	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
+	/* add header length */
+	return size + CONTAINER_HDR_SZ;
 }
 
 static void free_equiv_cpu_table(void)
