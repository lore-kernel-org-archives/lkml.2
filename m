Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0JOLgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:36:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:50605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0JOLgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:36:40 -0400
Message-ID: <4CB83CC3.7090106@kernel.org>
Date: Fri, 15 Oct 2010 13:36:35 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Ed L. Cashin" <ecashin@coraid.com>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2.6.36-rc7] aoe: don't use flush_scheduled_work()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 11:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is deprecated and scheduled to be removed.
Directly cancel aoedev->work on free instead of depending on
flush_scheduled_works().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/aoe/aoedev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: work/drivers/block/aoe/aoedev.c
===================================================================
--- work.orig/drivers/block/aoe/aoedev.c
+++ work/drivers/block/aoe/aoedev.c
@@ -102,6 +102,7 @@ aoedev_freedev(struct aoedev *d)
 {
 	struct aoetgt **t, **e;

+	cancel_work_sync(&d->work);
 	if (d->gd) {
 		aoedisk_rm_sysfs(d);
 		del_gendisk(d->gd);
@@ -135,7 +136,6 @@ aoedev_flush(const char __user *str, siz
 		all = !strncmp(buf, "all", 3);
 	}

-	flush_scheduled_work();
 	spin_lock_irqsave(&devlist_lock, flags);
 	dd = &devlist;
 	while ((d = *dd)) {
@@ -257,8 +257,6 @@ aoedev_exit(void)
 	struct aoedev *d;
 	ulong flags;

-	flush_scheduled_work();
-
 	while ((d = devlist)) {
 		devlist = d->next;

