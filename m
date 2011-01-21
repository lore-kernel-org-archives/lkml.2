Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1AURnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:43:18 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:41495 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab1AURnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:43:15 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Tobias Lorenz <tobias.lorenz@gmx.net>,
        Edouard Lafargue <edouard@lafargue.name>
Subject: BUG: double mutex lock in  drivers/media/radio/si470x/radio-si470x-common.c
Date: Fri, 21 Jan 2011 21:00:25 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101212100.25827.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        KERNEL_VERSION: 2.6.37
        SUBJECT: double mutex lock in drivers/media/radio/si470x/radio-si470x-
common.c in function ssize_t si470x_fops_read.

1. First mutex_lock on &radio->lock in line 441
2. Second in line 462

I think that mutex in line 462 is not needed.

 433static ssize_t si470x_fops_read(struct file *file, char __user *buf,
 434                size_t count, loff_t *ppos)
 435{
....
 441        mutex_lock(&radio->lock);
 442        if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 443                si470x_rds_on(radio);
 444
 445        /* block if no new data available */
 446        while (radio->wr_index == radio->rd_index) {
 447                if (file->f_flags & O_NONBLOCK) {
 448                        retval = -EWOULDBLOCK;
 449                        goto done;
 450                }
 451                if (wait_event_interruptible(radio->read_queue,
 452                        radio->wr_index != radio->rd_index) < 0) {
 453                        retval = -EINTR;
 454                        goto done;
 455                }
 456        }
 457
 458        /* calculate block count from byte count */
 459        count /= 3;
 460
 461        /* copy RDS block out of internal buffer and to user buffer */
 462        mutex_lock(&radio->lock);

Found by Linux Device Drivers Verification Project

Remove second mutex.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
___
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
b/drivers/media/radio/si470x/radio-si470x-common.c
index ac76dfe..e50452b 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -459,7 +459,6 @@ static ssize_t si470x_fops_read(struct file *file, char 
__user *buf,
 	count /= 3;
 
 	/* copy RDS block out of internal buffer and to user buffer */
-	mutex_lock(&radio->lock);
 	while (block_count < count) {
 		if (radio->rd_index == radio->wr_index)
 			break;
