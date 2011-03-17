Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1CQLnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:43:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1CQLnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=jgL7G+W46qyuRbmk3btjtk0XA0pxyFGjFivwlTJ7EfJXIYvQBZ0SbyazLHqUFl/Q+0
         ef9HB9rrZiAXxOVrrRVavPlETf4SVSflqfdXmF3lnirNqTfA+W+pRs4PlAdTshDJqjxk
         chyLqrG7UezBZKFwu/GnbKR8K7TLyg8V4+JxE=
Date: Thu, 17 Mar 2011 14:43:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] genirq: incorrect unlock in __setup_irq()
Message-ID: <20110317114307.GJ2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

goto out_thread is called before we take the lock.  It causes a gcc
warning: "kernel/irq/manage.c:858: warning: ‘flags’ may be used
uninitialized in this function"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index acd599a..cdcdf13 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1065,9 +1065,9 @@ mismatch:
 
 out_mask:
 	free_cpumask_var(mask);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 out_thread:
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	if (new->thread) {
 		struct task_struct *t = new->thread;
 
