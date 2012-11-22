Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2KVU7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:59:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2KVS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:26 -0500
Date: Wed, 21 Nov 2012 18:25:30 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-9710f581bb4c35589ac046b0cfc0deb7f369fc85@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-47-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-47-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Let "memmap=" take more entries one time
Git-Commit-ID: 9710f581bb4c35589ac046b0cfc0deb7f369fc85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:25:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9710f581bb4c35589ac046b0cfc0deb7f369fc85
Gitweb:     http://git.kernel.org/tip/9710f581bb4c35589ac046b0cfc0deb7f369fc85
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:23 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:51 -0800

x86, mm: Let "memmap=" take more entries one time

Current "memmap=" only can take one entry every time.
when we have more entries, we have to use memmap= for each of them.

For pxe booting, we have command line length limitation, those extra
"memmap=" would waste too much space.

This patch make memmap= could take several entries one time,
and those entries will be split with ','

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-47-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/e820.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index df06ade..d32abea 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -835,7 +835,7 @@ static int __init parse_memopt(char *p)
 }
 early_param("mem", parse_memopt);
 
-static int __init parse_memmap_opt(char *p)
+static int __init parse_memmap_one(char *p)
 {
 	char *oldp;
 	u64 start_at, mem_size;
@@ -877,6 +877,20 @@ static int __init parse_memmap_opt(char *p)
 
 	return *p == '\0' ? 0 : -EINVAL;
 }
+static int __init parse_memmap_opt(char *str)
+{
+	while (str) {
+		char *k = strchr(str, ',');
+
+		if (k)
+			*k++ = 0;
+
+		parse_memmap_one(str);
+		str = k;
+	}
+
+	return 0;
+}
 early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
