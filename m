Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2EFR6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:58:08 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37163 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2EFR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:58:06 -0400
Message-ID: <1336327084.2897.15.camel@lorien2>
Subject: [PATCH RESEND] x86: kernel/dumpstack.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Cc: shuahkhan@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 06 May 2012 11:58:04 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kstack_setup() and code_bytes_setup() in kernel/dumpstack.c
to call kstrtoul() instead of calling obsoleted simple_strtoul().


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 arch/x86/kernel/dumpstack.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1b81839..b154f6d 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -311,16 +311,33 @@ void die(const char *str, struct pt_regs *regs, long err)
 
 static int __init kstack_setup(char *s)
 {
+	ssize_t ret;
+	unsigned long val;
+
 	if (!s)
 		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+
+	ret = kstrtoul(s, 0, &val);
+	if (ret)
+		return ret;
+	kstack_depth_to_print = val;
 	return 0;
 }
 early_param("kstack", kstack_setup);
 
 static int __init code_bytes_setup(char *s)
 {
-	code_bytes = simple_strtoul(s, NULL, 0);
+	ssize_t ret;
+	unsigned long val;
+
+	if (!s)
+		return -EINVAL;
+
+	ret = kstrtoul(s, 0, &val);
+	if (ret)
+		return ret;
+
+	code_bytes = val;
 	if (code_bytes > 8192)
 		code_bytes = 8192;
 
-- 
1.7.5.4



