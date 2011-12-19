Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1LSPjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:39:22 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:17200 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1LSPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:39:20 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz179dN1432N98dK4015Lzz1202hzz8275bh8275dhz2dh668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWGJHC-01-8IP-02
X-M-MSG: 
Date: Mon, 19 Dec 2011 16:38:30 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH v2] oprofile: Fix uninitialized memory access when writing to
Message-ID: <20111219153830.GH16765@erda.amd.com>
References: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
 <20111219140049.GA9097@elte.hu>
 <20111219141703.GG16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111219141703.GG16765@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.11 15:17:03, Robert Richter wrote:
> On 19.12.11 15:00:49, Ingo Molnar wrote:
> 
> > +	if (!count)
> > +		return 0;
> > +
> >  	retval = oprofilefs_ulong_from_user(&value, buf, count);
> >  	if (retval)
> >  		return retval;
> > 
> > See the ugly and fragile pattern?
> > 
> > This should *really* be solved via the 
> > oprofilefs_ulong_from_user() helper function, not by sprinkling 
> > the !count checks in half a dozen places ...
> 
> Hmm, I thought there was no way to leave the code path with count == 0
> and retval. But thinking about it it would be possible with returning
> count or errors < 0. Will improve the patch.

Ingo, see my updated version below. I am fine with appling it directly
on tip/perf/urgent.

Thanks,

-Robert

--


>From f07214bc05560f63da8404d31aa83034a16c6229 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 16 Dec 2011 15:45:31 +0100
Subject: [PATCH] oprofile: Fix uninitialized memory access when writing to
 oprofilefs

If oprofilefs_ulong_from_user() is called with count equals zero, *val
remains unchanged. Depending on the implementation it might be
uninitialized.

Change oprofilefs_ulong_from_user()'s interface to return count on
success. Thus, we are able to return early if count equals zero which
avoids using *val uninitialized. Fixing all users of oprofilefs_ulong_
from_user().

This follows write syscall implementation when count is zero: "If
count is zero ... [and if] no errors are detected, 0 will be returned
without causing any other effect." (man 2 write)

Reported-By: Mike Waychison <mikew@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/s390/oprofile/init.c         |    2 +-
 drivers/oprofile/oprofile_files.c |    7 ++++---
 drivers/oprofile/oprofilefs.c     |   11 +++++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 6efc18b..bd58b72 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -88,7 +88,7 @@ static ssize_t hwsampler_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (oprofile_started)
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 89f6345..84a208d 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -45,7 +45,7 @@ static ssize_t timeout_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	retval = oprofile_set_timeout(val);
@@ -84,7 +84,7 @@ static ssize_t depth_write(struct file *file, char const __user *buf, size_t cou
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	retval = oprofile_set_ulong(&oprofile_backtrace_depth, val);
@@ -141,9 +141,10 @@ static ssize_t enable_write(struct file *file, char const __user *buf, size_t co
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
+	retval = 0;
 	if (val)
 		retval = oprofile_start();
 	else
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index d0de6cc..2f0aa0f 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -60,6 +60,13 @@ ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user *buf, size_t cou
 }
 
 
+/*
+ * Note: If oprofilefs_ulong_from_user() returns 0, then *val remains
+ * unchanged and might be uninitialized. This follows write syscall
+ * implementation when count is zero: "If count is zero ... [and if]
+ * no errors are detected, 0 will be returned without causing any
+ * other effect." (man 2 write)
+ */
 int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_t count)
 {
 	char tmpbuf[TMPBUFSIZE];
@@ -79,7 +86,7 @@ int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_
 	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	*val = simple_strtoul(tmpbuf, NULL, 0);
 	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
-	return 0;
+	return count;
 }
 
 
@@ -99,7 +106,7 @@ static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&value, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	retval = oprofile_set_ulong(file->private_data, value);
-- 
1.7.7




-- 
Advanced Micro Devices, Inc.
Operating System Research Center

