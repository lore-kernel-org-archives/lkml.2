Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0JDUZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:25:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:39681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab0JDUZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:25:13 -0400
Date: Mon, 4 Oct 2010 20:24:16 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        holt@sgi.com, cpw@sgi.com, error27@gmail.com,
        akpm@linux-foundation.org, steiner@sgi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        holt@sgi.com, cpw@sgi.com, error27@gmail.com,
        akpm@linux-foundation.org, steiner@sgi.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100929083118.GA6376@bicker>
References: <20100929083118.GA6376@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Use allocated buffer in tlb_uv.c:tunables_read()
Message-ID: <tip-b365a85c68161ea5db5476eb8845a91ceb1777ea@git.kernel.org>
Git-Commit-ID: b365a85c68161ea5db5476eb8845a91ceb1777ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:24:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b365a85c68161ea5db5476eb8845a91ceb1777ea
Gitweb:     http://git.kernel.org/tip/b365a85c68161ea5db5476eb8845a91ceb1777ea
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Wed, 29 Sep 2010 10:41:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Sep 2010 09:11:27 +0200

x86, UV: Use allocated buffer in tlb_uv.c:tunables_read()

The original code didn't check that the value returned from
snprintf() was less than the size of the buffer.  Although it
didn't cause a runtime bug in this case, it makes the static
checkers complain.

Andrew Morton suggested a dynamically sized buffer would be
cleaner.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
LKML-Reference: <20100929083118.GA6376@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
