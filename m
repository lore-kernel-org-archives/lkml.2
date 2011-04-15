Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1DOSUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:20:14 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:55728 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1DOSUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PaGQDxoyVhS3FhwDD7KONZYbDCx3m3eJwTglJseDMululWArVa+/VfIW+r24V4/n+e
         YEn+27hN/T3o/d491JSDenUkmFZs+iLeivhoiA+obROMd8K6QPXfWC3x0CvANxk3pIh0
         2ZH+pM0tAizFDzDXx7gKH2ZRf6QR3b0/oDkQM=
Date: Sat, 16 Apr 2011 03:20:06 +0900
From: Tejun Heo <tj@kernel.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110415182006.GA15916@mtj.dyndns.org>
References: <20110404211604.GB6133@sucs.org>
 <20110406130423.GE4142@mtj.dyndns.org>
 <20110406212611.GA5131@sucs.org>
 <20110406213718.GA14139@mtj.dyndns.org>
 <20110409093449.GA10016@sucs.org>
 <20110410145920.GA3408@sucs.org>
 <20110413200000.GG3987@mtj.dyndns.org>
 <20110415090118.GA3315@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415090118.GA3315@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please try the following patch instead.  Thanks.

diff --git a/block/genhd.c b/block/genhd.c
index b364bd0..6ed0c17 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1377,6 +1377,8 @@ struct disk_events {
 
 	long			poll_msecs;	/* interval, -1 for default */
 	struct delayed_work	dwork;
+	struct mutex		mutex;
+	atomic_t		cnt;
 };
 
 static const char *disk_events_strs[] = {
@@ -1540,6 +1542,9 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 		return 0;
 	}
 
+	WARN_ON_ONCE(atomic_add_return(1, &ev->cnt) != 1);
+	mutex_lock(&ev->mutex);
+
 	/* tell the workfn about the events being cleared */
 	spin_lock_irq(&ev->lock);
 	ev->clearing |= mask;
@@ -1558,6 +1563,9 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 	ev->pending &= ~mask;
 	spin_unlock_irq(&ev->lock);
 
+	WARN_ON_ONCE(atomic_add_return(-1, &ev->cnt) != 0);
+	mutex_unlock(&ev->mutex);
+
 	return pending;
 }
 
@@ -1749,6 +1757,8 @@ static void disk_add_events(struct gendisk *disk)
 	ev->block = 1;
 	ev->poll_msecs = -1;
 	INIT_DELAYED_WORK(&ev->dwork, disk_events_workfn);
+	mutex_init(&ev->mutex);
+	atomic_set(&ev->cnt, 0);
 
 	mutex_lock(&disk_events_mutex);
 	list_add_tail(&ev->node, &disk_events);
