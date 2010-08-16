Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0HPKzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:55:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48641 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab0HPKzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=iI5MHqHTdnJD4AHScXnK600c3ZruuN/inLHe3KyaXtjOj9p+D5MGsPA5LXRA8oZ0nf
         xudrvQU6z9Ay40yFHUnaEpU8b+F/g8kXnG/rYt9SqKYhs4TF1Za5433fQwKPyVFM1lLb
         hAKDdoZG/sx9OS9QbTmslGEiEgFY4+K/sUVL0=
Date: Mon, 16 Aug 2010 12:55:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Cliff Wickman <cpw@sgi.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] tlb_uv: handle large snprintf() returns
Message-ID: <20100816105502.GC645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Cliff Wickman <cpw@sgi.com>,
	Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snprintf() returns the number of bytes that *would* have been copied if
the buffer was large enough, so it can be larger than the size of the
buffer.  In this case it's ok, but let's put a cap on it anyway so it's
easier to audit.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 312ef02..5e88b3a 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1012,6 +1012,9 @@ static ssize_t tunables_read(struct file *file, char __user *userbuf,
 		timeoutsb4reset, ipi_reset_limit, complete_threshold,
 		congested_response_us, congested_reps, congested_period);
 
+	if (ret > 300)
+		ret = 300;
+
 	return simple_read_from_buffer(userbuf, count, ppos, buf, ret);
 }
 
