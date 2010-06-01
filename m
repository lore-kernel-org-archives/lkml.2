Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab0FAUyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:54:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab0FAUx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 30/31] tty: release BTM while sleeping in block_til_ready
Date: Tue,  1 Jun 2010 22:53:10 +0200
Message-Id: <1275425591-8803-31-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+iN3Ptc923ruG+bBFZTYevcxqwlxLx89NvIWl
 t7LG0ZymgSraXFlmkedLy8NI1EQkpJchZ2sJbDry7/O4iANxcb
 hIUVtV2Iu8x/OKeheMZHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most tty drivers may block while opening a device.
Since this possibly depends on another thread
closing it first and both threads may need the BTM,
we need to release it here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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
index 4de1246..c1a004f 100644
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
index c56b70a..99fae38 100644
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
index cfa581e..eb58d5f 100644
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
index 3046386..0e91896 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -1243,7 +1243,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
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
index 5b7b801..8b8e4c3 100644
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
1.7.0.4

