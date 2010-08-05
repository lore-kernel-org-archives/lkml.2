Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab0HEWgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:36:42 -0400
Received: from kroah.org ([198.145.64.141]:37694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760797Ab0HEWY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/67] tty: release BTM while sleeping in block_til_ready
Date: Thu,  5 Aug 2010 15:23:11 -0700
Message-Id: <1281047014-23429-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Most tty drivers may block while opening a device.
Since this possibly depends on another thread
closing it first and both threads may need the BTM,
we need to release it here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/amiserial.c     |    2 ++
 drivers/char/ip2/ip2main.c   |    4 ++++
 drivers/char/serial167.c     |    4 +++-
 drivers/char/specialix.c     |    2 ++
 drivers/char/synclink.c      |    2 ++
 drivers/char/synclink_gt.c   |    2 ++
 drivers/char/synclinkmp.c    |    2 ++
 drivers/char/tty_port.c      |    2 ++
 drivers/serial/68328serial.c |    2 ++
 drivers/serial/68360serial.c |    2 ++
 drivers/serial/crisv10.c     |    2 ++
 11 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 8228e61..a11c8c9 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1710,7 +1710,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		printk("block_til_ready blocking: ttys%d, count = %d\n",
 		       info->line, state->count);
 #endif
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 911e1da..07f3ea3 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -1486,7 +1486,9 @@ ip2_open( PTTY tty, struct file *pFile )
 
 	if ( tty_hung_up_p(pFile) || ( pCh->flags & ASYNC_CLOSING )) {
 		if ( pCh->flags & ASYNC_CLOSING ) {
+			tty_unlock();
 			schedule();
+			tty_lock();
 		}
 		if ( tty_hung_up_p(pFile) ) {
 			set_current_state( TASK_RUNNING );
@@ -1548,7 +1550,9 @@ ip2_open( PTTY tty, struct file *pFile )
 			rc = (( pCh->flags & ASYNC_HUP_NOTIFY ) ? -EAGAIN : -ERESTARTSYS);
 			break;
 		}
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 	set_current_state( TASK_RUNNING );
 	remove_wait_queue(&pCh->open_wait, &wait);
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 90b3ec0..f646725 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1786,7 +1786,9 @@ block_til_ready(struct tty_struct *tty, struct file *filp,
 		       tty->name, info->count);
 		/**/
 #endif
-		    schedule();
+		tty_unlock();
+		schedule();
+		tty_lock();
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 7be456f..9f8495b 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1365,7 +1365,9 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 			retval = -ERESTARTSYS;
 			break;
 		}
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 2b03d4d..a2a5800 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -3349,7 +3349,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 			printk("%s(%d):block_til_ready blocking on %s count=%d\n",
 				 __FILE__,__LINE__, tty->driver->name, port->count );
 				 
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 	
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 5a602eb..fef80cf 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -3244,7 +3244,9 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		}
 
 		DBGINFO(("%s block_til_ready wait\n", tty->driver->name));
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index ac447c7..e56caf7 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -3365,7 +3365,9 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 			printk("%s(%d):%s block_til_ready() count=%d\n",
 				 __FILE__,__LINE__, tty->driver->name, port->count );
 
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 35eb304..33d37d2 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -294,7 +294,9 @@ int tty_port_block_til_ready(struct tty_port *port,
 			retval = -ERESTARTSYS;
 			break;
 		}
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 	finish_wait(&port->open_wait, &wait);
 
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 9330edb..d8204f4 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -1235,7 +1235,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 			retval = -ERESTARTSYS;
 			break;
 		}
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&info->open_wait, &wait);
diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index edcf1cc..0dff3bb 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -1860,7 +1860,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		printk("block_til_ready blocking: ttys%d, count = %d\n",
 		       info->line, state->count);
 #endif
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&info->open_wait, &wait);
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 0825d4a..ca47072 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -4055,7 +4055,9 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 		printk("block_til_ready blocking: ttyS%d, count = %d\n",
 		       info->line, info->count);
 #endif
+		tty_unlock();
 		schedule();
+		tty_lock();
 	}
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
-- 
1.7.2

