Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2EHWTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:19:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34475 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2EHWTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:19:22 -0400
Date: Tue, 8 May 2012 15:19:09 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-f156ffc439951b63cfa9f4d999a8d54267f13282@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-8-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-8-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Set permission for real mode pages
Git-Commit-ID: f156ffc439951b63cfa9f4d999a8d54267f13282
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:19:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f156ffc439951b63cfa9f4d999a8d54267f13282
Gitweb:     http://git.kernel.org/tip/f156ffc439951b63cfa9f4d999a8d54267f13282
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:30 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:47:08 -0700

x86, realmode: Set permission for real mode pages

Set proper permissions for rodata, text and data, removing the
realmode trampoline area as a remaining RWX memory mapping in the
kernel.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-8-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/realmode.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index a465775..d85ac20 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -86,7 +86,21 @@ static int __init set_real_mode_permissions(void)
 		PAGE_ALIGN(real_mode_header.end) -
 		__pa(real_mode_base);
 
-	set_memory_x((unsigned long) real_mode_base, all_size >> PAGE_SHIFT);
+	size_t ro_size =
+		PAGE_ALIGN(real_mode_header.ro_end) -
+		__pa(real_mode_base);
+
+	size_t text_size =
+		PAGE_ALIGN(real_mode_header.ro_end) -
+		real_mode_header.text_start;
+
+	unsigned long text_start =
+		(unsigned long) __va(real_mode_header.text_start);
+
+	set_memory_nx((unsigned long) real_mode_base, all_size >> PAGE_SHIFT);
+	set_memory_ro((unsigned long) real_mode_base, ro_size >> PAGE_SHIFT);
+	set_memory_x((unsigned long) text_start, text_size >> PAGE_SHIFT);
+
 	return 0;
 }
 
