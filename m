Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1DOJB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:01:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47994 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1DOJBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TmcZgnb/pxYyxAKdgih3hA/bPfo1nEtATY21UnM+u+whP7/mpbb51/WgnuOzi9fxZI
         8iWFxUsL3f0eX3L3VuAEd2zOHyQvYaRFSQ5u5bvS/CoG9eYBanoyvIECz2lEjLz5pJwB
         5K11jxwJA963J3oHeRgITJgwKNiqJihS4cHns=
Date: Fri, 15 Apr 2011 18:01:18 +0900
From: Tejun Heo <tj@kernel.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110415090118.GA3315@mtj.dyndns.org>
References: <20110404211604.GB6133@sucs.org>
 <20110406130423.GE4142@mtj.dyndns.org>
 <20110406212611.GA5131@sucs.org>
 <20110406213718.GA14139@mtj.dyndns.org>
 <20110409093449.GA10016@sucs.org>
 <20110410145920.GA3408@sucs.org>
 <20110413200000.GG3987@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413200000.GG3987@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 05:00:00AM +0900, Tejun Heo wrote:
> Thanks a lot for finding out the test case.  I'll see whether I can
> reproduce the problem in qemu.

Hmm... can't reproduce the problem with qemu.  Can you please apply
the following patch and see which warning messages trigger?

Thanks.

diff --git a/block/genhd.c b/block/genhd.c
index b364bd0..f061975 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1377,6 +1377,8 @@ struct disk_events {
 
 	long			poll_msecs;	/* interval, -1 for default */
 	struct delayed_work	dwork;
+	struct mutex		mutex;
+	atomic_t		cnt;
 };
 
 static const char *disk_events_strs[] = {
@@ -1572,6 +1574,9 @@ static void disk_events_workfn(struct work_struct *work)
 	unsigned long intv;
 	int nr_events = 0, i;
 
+	WARN_ON_ONCE(atomic_add_return(1, &ev->cnt) != 1);
+	mutex_lock(&ev->mutex);
+
 	/* check events */
 	events = disk->fops->check_events(disk, clearing);
 
@@ -1595,6 +1600,9 @@ static void disk_events_workfn(struct work_struct *work)
 
 	if (nr_events)
 		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
+
+	mutex_unlock(&ev->mutex);
+	WARN_ON_ONCE(atomic_add_return(-1, &ev->cnt) != 0);
 }
 
 /*
@@ -1749,6 +1757,8 @@ static void disk_add_events(struct gendisk *disk)
 	ev->block = 1;
 	ev->poll_msecs = -1;
 	INIT_DELAYED_WORK(&ev->dwork, disk_events_workfn);
+	mutex_init(&ev->mutex);
+	atomic_set(&ev->cnt, 0);
 
 	mutex_lock(&disk_events_mutex);
 	list_add_tail(&ev->node, &disk_events);
