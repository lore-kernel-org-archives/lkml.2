Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1DFNE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:04:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50900 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1DFNE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NXjwJWOEWmuhELAf4v41QekC0QZrxOiUYLH9iXbSpyukNKly/2AsXt40MK9Epr1nQy
         tRlEgFbTp7Wc5Uc59r8oOAKjmxolRHjmTp0C14VcaFbdPFQLDlS6l/3s81eKpdf+6SAe
         cmg+bQhbB1f2fP4q7hJRP0HxedvGTvYcF7+6A=
Date: Wed, 6 Apr 2011 06:04:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110406130423.GE4142@mtj.dyndns.org>
References: <20110404211604.GB6133@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404211604.GB6133@sucs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think disk_block_events was a bit too agressive with optimization.
Can you please test the following patch and see whether the problem
goes away?

Thanks.

diff --git a/block/genhd.c b/block/genhd.c
index c91a2da..ae4079a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1418,18 +1418,15 @@ static void __disk_block_events(struct gendisk *disk, bool sync)
 {
 	struct disk_events *ev = disk->ev;
 	unsigned long flags;
-	bool cancel;
 
 	spin_lock_irqsave(&ev->lock, flags);
-	cancel = !ev->block++;
+	ev->block++;
 	spin_unlock_irqrestore(&ev->lock, flags);
 
-	if (cancel) {
-		if (sync)
-			cancel_delayed_work_sync(&disk->ev->dwork);
-		else
-			cancel_delayed_work(&disk->ev->dwork);
-	}
+	if (sync)
+		cancel_delayed_work_sync(&disk->ev->dwork);
+	else
+		cancel_delayed_work(&disk->ev->dwork);
 }
 
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
