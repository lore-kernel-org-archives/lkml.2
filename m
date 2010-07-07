Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0GGOgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:36:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab0GGOgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:36:18 -0400
Date: Wed, 7 Jul 2010 10:29:44 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] IR/lirc_dev: fix locking in lirc_dev_fop_read
Message-ID: <20100707142944.GC29996@redhat.com>
References: <4C3478AA.7070805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3478AA.7070805@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 02:52:58PM +0200, Jiri Slaby wrote:
> Hi,
> 
> stanse found a locking error in lirc_dev_fop_read:
> if (mutex_lock_interruptible(&ir->irctl_lock))
>   return -ERESTARTSYS;
> ...
> while (written < length && ret == 0) {
>   if (mutex_lock_interruptible(&ir->irctl_lock)) {    #1
>     ret = -ERESTARTSYS;
>     break;
>   }
>   ...
> }
> 
> remove_wait_queue(&ir->buf->wait_poll, &wait);
> set_current_state(TASK_RUNNING);
> mutex_unlock(&ir->irctl_lock);                        #2
> 
> If lock at #1 fails, it beaks out of the loop, with the lock unlocked,
> but there is another "unlock" at #2.

This should do the trick. Completely untested beyond compiling, but its
not exactly a complicated fix, and in practice, I'm not aware of anyone
ever actually tripping that locking bug, so there's zero functional change
in typical use here.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/lirc_dev.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 9e141d5..64170fa 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -657,7 +657,9 @@ ssize_t lirc_dev_fop_read(struct file *file,
 
 			if (mutex_lock_interruptible(&ir->irctl_lock)) {
 				ret = -ERESTARTSYS;
-				break;
+				remove_wait_queue(&ir->buf->wait_poll, &wait);
+				set_current_state(TASK_RUNNING);
+				goto out_unlocked;
 			}
 
 			if (!ir->attached) {
@@ -676,6 +678,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	set_current_state(TASK_RUNNING);
 	mutex_unlock(&ir->irctl_lock);
 
+out_unlocked:
 	dev_dbg(ir->d.dev, LOGHEAD "read result = %s (%d)\n",
 		ir->d.name, ir->d.minor, ret ? "-EFAULT" : "OK", ret);
 

-- 
Jarod Wilson
jarod@redhat.com

