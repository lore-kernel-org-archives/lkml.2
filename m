Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0I2Ik7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:40:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62086 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab0I2Ik5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=s5L+VmlVblTMNfJ5aeGwsNaum6zll/62x4UxbL5ABXLLc2ahmTVS3qU1QweDfpXLz6
         XWCGMkZN/LUDl1wylmOdq735j0/YLl+CgbWo1LhqOnr1LJ9iBu9aNxB8kAhUGPIqEISU
         LHFhW/qmvf1B/6ZMhNllflghvRS/a1Yhq/pS4=
Date: Wed, 29 Sep 2010 10:41:05 +0200
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Cliff Wickman <cpw@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] tlb_uv: use allocated buffer in tunables_read()
Message-ID: <20100929083118.GA6376@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Cliff Wickman <cpw@sgi.com>,
	Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100816105502.GC645@bicker> <20100927161203.732833b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927161203.732833b0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code didn't check that the value returned from snprintf()
was less than the size of the buffer.  Although it didn't cause a
runtime bug in this case, it makes the static checkers complain.

Andrew Morton suggested a dynamically sized buffer would be cleaner.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't have an x86_64 system so I haven't been able to compile this
code.  Sorry for that.

V2:  The first version was yuk.

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
