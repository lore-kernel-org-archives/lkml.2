Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab2HXSyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:54:40 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:54883
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759842Ab2HXSyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:54:05 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M99WI0-01-8QN-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>, <stable@vger.kernel.org>,
        <#@erda.amd.com>, <3.3+@erda.amd.com>
Subject: [PATCH 1/2] oprofile, s390: Fix uninitialized memory access when writing to oprofilefs
Date: Fri, 24 Aug 2012 20:53:30 +0200
Message-ID: <1345834411-24940-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345834411-24940-1-git-send-email-robert.richter@amd.com>
References: <1345834411-24940-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If oprofilefs_ulong_from_user() is called with count equals zero, *val
remains unchanged. Depending on the implementation it might be
uninitialized. Fixing users of oprofilefs_ulong_ from_user().

We missed these s390 changes with:

 913050b oprofile: Fix uninitialized memory access when writing to writing to oprofilefs

Cc: stable@vger.kernel.org  # 3.3+
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/s390/oprofile/init.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index a1e9d69..584b936 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -169,7 +169,7 @@ static ssize_t hw_interval_write(struct file *file, char const __user *buf,
 	if (*offset)
 		return -EINVAL;
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 	if (val < oprofile_min_interval)
 		oprofile_hw_interval = oprofile_min_interval;
@@ -212,7 +212,7 @@ static ssize_t hwsampler_zero_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 	if (val != 0)
 		return -EINVAL;
@@ -243,7 +243,7 @@ static ssize_t hwsampler_kernel_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
@@ -278,7 +278,7 @@ static ssize_t hwsampler_user_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
@@ -317,7 +317,7 @@ static ssize_t timer_enabled_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
-- 
1.7.8.6


