Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab0JWPDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:03:18 -0400
Received: from www.tglx.de ([62.245.132.106]:49064 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483Ab0JWPDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:03:17 -0400
Date: Sat, 23 Oct 2010 17:03:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 uv for 2.6.37
Message-ID: <alpine.LFD.2.00.1010231634420.2516@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-uv-for-linus

Thanks,

	tglx

------------------>
Dan Carpenter (1):
      x86, UV: Use allocated buffer in tlb_uv.c:tunables_read()


 arch/x86/kernel/tlb_uv.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 312ef02..33e77e4 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1001,10 +1001,10 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
 static ssize_t tunables_read(struct file *file, char __user *userbuf,
 						size_t count, loff_t *ppos)
 {
-	char buf[300];
+	char *buf;
 	int ret;
 
-	ret = snprintf(buf, 300, "%s %s %s\n%d %d %d %d %d %d %d %d %d\n",
+	buf = kasprintf(GFP_KERNEL, "%s %s %s\n%d %d %d %d %d %d %d %d %d\n",
 		"max_bau_concurrent plugged_delay plugsb4reset",
 		"timeoutsb4reset ipi_reset_limit complete_threshold",
 		"congested_response_us congested_reps congested_period",
@@ -1012,7 +1012,12 @@ static ssize_t tunables_read(struct file *file, char __user *userbuf,
 		timeoutsb4reset, ipi_reset_limit, complete_threshold,
 		congested_response_us, congested_reps, congested_period);
 
-	return simple_read_from_buffer(userbuf, count, ppos, buf, ret);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
+	kfree(buf);
+	return ret;
 }
 
 /*
