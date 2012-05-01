Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2EAQew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:34:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54883 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2EAQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:34:50 -0400
Date: Tue, 1 May 2012 17:37:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Killing the tty lock
Message-ID: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first stab at it by making the lock per tty and using tty_mutex
to cover the lookup for now. We ought to move to the lookup handing back
ttys with a ref but thats a further step.

It seems to mostly work but not quite reliably, so coul do with some more
eyes and review for ideas.

Alan

commit 4a86662551c2b3f0b5e5119f7dd2623dd5fc2f7a
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue May 1 17:05:59 2012 +0100

    tty_lock: Localise the lock
    
    In each remaining case the tty_lock is associated with a specific tty. This
    means we can now lock on a per tty basis. We do need tty_lock_pair() for
    the pty case. Uglier but still a step in the right direction.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 24145c3..aa4f433 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1033,7 +1033,7 @@ static int get_serial_info(struct tty_struct *tty, struct serial_state *state,
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof(tmp));
-	tty_lock();
+	tty_lock(tty);
 	tmp.line = tty->index;
 	tmp.port = state->port;
 	tmp.flags = state->tport.flags;
@@ -1042,7 +1042,7 @@ static int get_serial_info(struct tty_struct *tty, struct serial_state *state,
 	tmp.close_delay = state->tport.close_delay;
 	tmp.closing_wait = state->tport.closing_wait;
 	tmp.custom_divisor = state->custom_divisor;
-	tty_unlock();
+	tty_unlock(tty);
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -1059,12 +1059,12 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 	if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
 		return -EFAULT;
 
-	tty_lock();
+	tty_lock(tty);
 	change_spd = ((new_serial.flags ^ port->flags) & ASYNC_SPD_MASK) ||
 		new_serial.custom_divisor != state->custom_divisor;
 	if (new_serial.irq || new_serial.port != state->port ||
 			new_serial.xmit_fifo_size != state->xmit_fifo_size) {
-		tty_unlock();
+		tty_unlock(tty);
 		return -EINVAL;
 	}
   
@@ -1082,7 +1082,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 	}
 
 	if (new_serial.baud_base < 9600) {
-		tty_unlock();
+		tty_unlock(tty);
 		return -EINVAL;
 	}
 
@@ -1114,7 +1114,7 @@ check_and_exit:
 		}
 	} else
 		retval = startup(tty, state);
-	tty_unlock();
+	tty_unlock(tty);
 	return retval;
 }
 
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index e61cabd..6984e1a 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1599,7 +1599,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) || (info->port.flags & ASYNC_CLOSING)) {
-		wait_event_interruptible_tty(info->port.close_wait,
+		wait_event_interruptible_tty(tty, info->port.close_wait,
 				!(info->port.flags & ASYNC_CLOSING));
 		return (info->port.flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index 5c6c314..656ad93 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -1065,7 +1065,8 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 
 	TRACE_L("read()");
 
-	tty_lock();
+	/* FIXME: should use a private lock */
+	tty_lock(tty);
 
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
@@ -1077,7 +1078,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 				goto unlock;
 			}
 			/* block until there is a message: */
-			wait_event_interruptible_tty(pInfo->read_wait,
+			wait_event_interruptible_tty(tty, pInfo->read_wait,
 					(pMsg = remove_msg(pInfo, pClient)));
 		}
 
@@ -1107,7 +1108,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 	}
 	ret = -EPERM;
 unlock:
-	tty_unlock();
+	tty_unlock(tty);
 	return ret;
 }
 
@@ -1156,7 +1157,7 @@ static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
 	pHeader->locks = 0;
 	pHeader->owner = NULL;
 
-	tty_lock();
+	tty_lock(tty);
 
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
@@ -1175,7 +1176,7 @@ static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
 	add_tx_queue(pInfo, pHeader);
 	trigger_transmit(pInfo);
 
-	tty_unlock();
+	tty_unlock(tty);
 
 	return 0;
 }
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5505ffc..c2d938f 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -47,6 +47,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
 	tty->packet = 0;
+	/* Review - krefs on tty_link ?? */
 	if (!tty->link)
 		return;
 	tty->link->packet = 0;
@@ -62,9 +63,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		        mutex_unlock(&devpts_mutex);
 		}
 #endif
-		tty_unlock();
 		tty_vhangup(tty->link);
-		tty_lock();
 	}
 }
 
@@ -622,9 +621,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 		return retval;
 
 	/* find a device that is not in use. */
-	tty_lock();
+	mutex_lock(&devpts_mutex);
 	index = devpts_new_index(inode);
-	tty_unlock();
+	mutex_unlock(&devpts_mutex);
 	if (index < 0) {
 		retval = index;
 		goto err_file;
@@ -634,7 +633,8 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	mutex_lock(&devpts_mutex);
 	tty = tty_init_dev(ptm_driver, index);
 	mutex_unlock(&devpts_mutex);
-	tty_lock();
+	/* Must take this under the tty_mutex until lookups keep a kref */
+	tty_lock(tty);
 	mutex_unlock(&tty_mutex);
 
 	if (IS_ERR(tty)) {
@@ -654,15 +654,17 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto err_release;
 
-	tty_unlock();
+	tty_unlock(tty);
 	return 0;
 err_release:
-	tty_unlock();
+	tty_unlock(tty);
 	tty_release(inode, filp);
 	return retval;
 out:
+        mutex_lock(&devpts_mutex);
 	devpts_kill_index(inode, index);
-	tty_unlock();
+        mutex_unlock(&devpts_mutex);
+	tty_unlock(tty);
 err_file:
 	tty_free_file(filp);
 	return retval;
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 593d40a..5ed0daa 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3338,9 +3338,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 			printk("%s(%d):block_til_ready blocking on %s count=%d\n",
 				 __FILE__,__LINE__, tty->driver->name, port->count );
 				 
-		tty_unlock();
+		tty_unlock(tty);
 		schedule();
-		tty_lock();
+		tty_lock(tty);
 	}
 	
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index aa1debf..45b43f1 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3336,9 +3336,9 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		}
 
 		DBGINFO(("%s block_til_ready wait\n", tty->driver->name));
-		tty_unlock();
+		tty_unlock(tty);
 		schedule();
-		tty_lock();
+		tty_lock(tty);
 	}
 
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index a3dddc1..4a1e4f0 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -3357,9 +3357,9 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 			printk("%s(%d):%s block_til_ready() count=%d\n",
 				 __FILE__,__LINE__, tty->driver->name, port->count );
 
-		tty_unlock();
+		tty_unlock(tty);
 		schedule();
-		tty_lock();
+		tty_lock(tty);
 	}
 
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..1ca0629 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -573,7 +573,7 @@ void __tty_hangup(struct tty_struct *tty)
 	}
 	spin_unlock(&redirect_lock);
 
-	tty_lock();
+	tty_lock(tty);
 
 	/* some functions below drop BTM, so we need this bit */
 	set_bit(TTY_HUPPING, &tty->flags);
@@ -666,7 +666,7 @@ void __tty_hangup(struct tty_struct *tty)
 	clear_bit(TTY_HUPPING, &tty->flags);
 	tty_ldisc_enable(tty);
 
-	tty_unlock();
+	tty_unlock(tty);
 
 	if (f)
 		fput(f);
@@ -1103,12 +1103,12 @@ void tty_write_message(struct tty_struct *tty, char *msg)
 {
 	if (tty) {
 		mutex_lock(&tty->atomic_write_lock);
-		tty_lock();
+		tty_lock(tty);
 		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
-			tty_unlock();
+			tty_unlock(tty);
 			tty->ops->write(tty, msg, strlen(msg));
 		} else
-			tty_unlock();
+			tty_unlock(tty);
 		tty_write_unlock(tty);
 	}
 	return;
@@ -1403,6 +1403,7 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 	}
 	initialize_tty_struct(tty, driver, idx);
 
+	tty_lock(tty);
 	retval = tty_driver_install_tty(driver, tty);
 	if (retval < 0)
 		goto err_deinit_tty;
@@ -1418,6 +1419,7 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 	return tty;
 
 err_deinit_tty:
+	tty_unlock(tty);
 	deinitialize_tty_struct(tty);
 	free_tty_struct(tty);
 err_module_put:
@@ -1426,6 +1428,7 @@ err_module_put:
 
 	/* call the tty release_tty routine to clean out this slot */
 err_release_tty:
+	tty_unlock(tty);
 	printk_ratelimited(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
 	release_tty(tty, idx);
@@ -1628,7 +1631,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (tty_paranoia_check(tty, inode, __func__))
 		return 0;
 
-	tty_lock();
+	tty_lock(tty);
 	check_tty_count(tty, __func__);
 
 	__tty_fasync(-1, filp, 0);
@@ -1637,10 +1640,11 @@ int tty_release(struct inode *inode, struct file *filp)
 	pty_master = (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 		      tty->driver->subtype == PTY_TYPE_MASTER);
 	devpts = (tty->driver->flags & TTY_DRIVER_DEVPTS_MEM) != 0;
+	/* Review: parallel close */
 	o_tty = tty->link;
 
 	if (tty_release_checks(tty, o_tty, idx)) {
-		tty_unlock();
+		tty_unlock(tty);
 		return 0;
 	}
 
@@ -1652,7 +1656,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (tty->ops->close)
 		tty->ops->close(tty, filp);
 
-	tty_unlock();
+	tty_unlock(tty);
 	/*
 	 * Sanity check: if tty->count is going to zero, there shouldn't be
 	 * any waiters on tty->read_wait or tty->write_wait.  We test the
@@ -1675,7 +1679,7 @@ int tty_release(struct inode *inode, struct file *filp)
 		   opens on /dev/tty */
 
 		mutex_lock(&tty_mutex);
-		tty_lock();
+		tty_lock_pair(tty, o_tty);
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
 			(o_tty->count <= (pty_master ? 1 : 0));
@@ -1706,7 +1710,7 @@ int tty_release(struct inode *inode, struct file *filp)
 
 		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
 				__func__, tty_name(tty, buf));
-		tty_unlock();
+		tty_unlock_pair(tty, o_tty);
 		mutex_unlock(&tty_mutex);
 		schedule();
 	}
@@ -1769,7 +1773,7 @@ int tty_release(struct inode *inode, struct file *filp)
 
 	/* check whether both sides are closing ... */
 	if (!tty_closing || (o_tty && !o_tty_closing)) {
-		tty_unlock();
+		tty_unlock_pair(tty, o_tty);
 		return 0;
 	}
 
@@ -1789,7 +1793,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	/* Make this pty number available for reallocation */
 	if (devpts)
 		devpts_kill_index(inode, idx);
-	tty_unlock();
+	tty_unlock_pair(tty, o_tty);
 	return 0;
 }
 
@@ -1893,6 +1897,9 @@ static struct tty_driver *tty_lookup_driver(dev_t device, struct file *filp,
  *	Locking: tty_mutex protects tty, tty_lookup_driver and tty_init_dev.
  *		 tty->count should protect the rest.
  *		 ->siglock protects ->signal/->sighand
+ *
+ *	Note: the tty_unlock/lock cases without a ref are only safe due to
+ *	tty_mutex
  */
 
 static int tty_open(struct inode *inode, struct file *filp)
@@ -1916,8 +1923,7 @@ retry_open:
 	retval = 0;
 
 	mutex_lock(&tty_mutex);
-	tty_lock();
-
+	/* This is protected by the tty_mutex */
 	tty = tty_open_current_tty(device, filp);
 	if (IS_ERR(tty)) {
 		retval = PTR_ERR(tty);
@@ -1938,17 +1944,19 @@ retry_open:
 	}
 
 	if (tty) {
+		tty_lock(tty);
 		retval = tty_reopen(tty);
-		if (retval)
+		if (retval < 0) {
+			tty_unlock(tty);
 			tty = ERR_PTR(retval);
-	} else
+		}
+	} else	/* Returns with the tty_lock held for now */
 		tty = tty_init_dev(driver, index);
 
 	mutex_unlock(&tty_mutex);
 	if (driver)
 		tty_driver_kref_put(driver);
 	if (IS_ERR(tty)) {
-		tty_unlock();
 		retval = PTR_ERR(tty);
 		goto err_file;
 	}
@@ -1977,7 +1985,7 @@ retry_open:
 		printk(KERN_DEBUG "%s: error %d in opening %s...\n", __func__,
 				retval, tty->name);
 #endif
-		tty_unlock(); /* need to call tty_release without BTM */
+		tty_unlock(tty); /* need to call tty_release without BTM */
 		tty_release(inode, filp);
 		if (retval != -ERESTARTSYS)
 			return retval;
@@ -1989,17 +1997,17 @@ retry_open:
 		/*
 		 * Need to reset f_op in case a hangup happened.
 		 */
-		tty_lock();
+		tty_lock(tty);
 		if (filp->f_op == &hung_up_tty_fops)
 			filp->f_op = &tty_fops;
-		tty_unlock();
+		tty_unlock(tty);
 		goto retry_open;
 	}
-	tty_unlock();
+	tty_unlock(tty);
 
 
 	mutex_lock(&tty_mutex);
-	tty_lock();
+	tty_lock(tty);
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
@@ -2007,11 +2015,10 @@ retry_open:
 	    tty->session == NULL)
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
-	tty_unlock();
+	tty_unlock(tty);
 	mutex_unlock(&tty_mutex);
 	return 0;
 err_unlock:
-	tty_unlock();
 	mutex_unlock(&tty_mutex);
 	/* after locks to avoid deadlock */
 	if (!IS_ERR_OR_NULL(driver))
@@ -2094,10 +2101,13 @@ out:
 
 static int tty_fasync(int fd, struct file *filp, int on)
 {
+	struct tty_struct *tty = file_tty(filp);
 	int retval;
-	tty_lock();
+
+	tty_lock(tty);
 	retval = __tty_fasync(fd, filp, on);
-	tty_unlock();
+	tty_unlock(tty);
+
 	return retval;
 }
 
@@ -2934,6 +2944,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->pgrp = NULL;
 	tty->overrun_time = jiffies;
 	tty_buffer_init(tty);
+	mutex_init(&tty->legacy_mutex);
 	mutex_init(&tty->termios_mutex);
 	mutex_init(&tty->ldisc_mutex);
 	init_waitqueue_head(&tty->write_wait);
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 24b95db..fa65cde 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -567,7 +567,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (IS_ERR(new_ldisc))
 		return PTR_ERR(new_ldisc);
 
-	tty_lock();
+	tty_lock(tty);
 	/*
 	 *	We need to look at the tty locking here for pty/tty pairs
 	 *	when both sides try to change in parallel.
@@ -581,12 +581,12 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 */
 
 	if (tty->ldisc->ops->num == ldisc) {
-		tty_unlock();
+		tty_unlock(tty);
 		tty_ldisc_put(new_ldisc);
 		return 0;
 	}
 
-	tty_unlock();
+	tty_unlock(tty);
 	/*
 	 *	Problem: What do we do if this blocks ?
 	 *	We could deadlock here
@@ -594,7 +594,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
-	tty_lock();
+	tty_lock(tty);
 	mutex_lock(&tty->ldisc_mutex);
 
 	/*
@@ -604,10 +604,10 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	while (test_bit(TTY_LDISC_CHANGING, &tty->flags)) {
 		mutex_unlock(&tty->ldisc_mutex);
-		tty_unlock();
+		tty_unlock(tty);
 		wait_event(tty_ldisc_wait,
 			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
-		tty_lock();
+		tty_lock(tty);
 		mutex_lock(&tty->ldisc_mutex);
 	}
 
@@ -622,7 +622,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	o_ldisc = tty->ldisc;
 
-	tty_unlock();
+	tty_unlock(tty);
 	/*
 	 *	Make sure we don't change while someone holds a
 	 *	reference to the line discipline. The TTY_LDISC bit
@@ -649,7 +649,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	retval = tty_ldisc_wait_idle(tty, 5 * HZ);
 
-	tty_lock();
+	tty_lock(tty);
 	mutex_lock(&tty->ldisc_mutex);
 
 	/* handle wait idle failure locked */
@@ -664,7 +664,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 		mutex_unlock(&tty->ldisc_mutex);
 		tty_ldisc_put(new_ldisc);
-		tty_unlock();
+		tty_unlock(tty);
 		return -EIO;
 	}
 
@@ -707,7 +707,7 @@ enable:
 	if (o_work)
 		schedule_work(&o_tty->buf.work);
 	mutex_unlock(&tty->ldisc_mutex);
-	tty_unlock();
+	tty_unlock(tty);
 	return retval;
 }
 
@@ -815,11 +815,11 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 * need to wait for another function taking the BTM
 	 */
 	clear_bit(TTY_LDISC, &tty->flags);
-	tty_unlock();
+	tty_unlock(tty);
 	cancel_work_sync(&tty->buf.work);
 	mutex_unlock(&tty->ldisc_mutex);
 retry:
-	tty_lock();
+	tty_lock(tty);
 	mutex_lock(&tty->ldisc_mutex);
 
 	/* At this point we have a closed ldisc and we want to
@@ -830,7 +830,7 @@ retry:
 		if (atomic_read(&tty->ldisc->users) != 1) {
 			char cur_n[TASK_COMM_LEN], tty_n[64];
 			long timeout = 3 * HZ;
-			tty_unlock();
+			tty_unlock(tty);
 
 			while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
 				timeout = MAX_SCHEDULE_TIMEOUT;
@@ -911,10 +911,10 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * race with the set_ldisc code path.
 	 */
 
-	tty_unlock();
+	tty_unlock(tty);
 	tty_ldisc_halt(tty);
 	tty_ldisc_flush_works(tty);
-	tty_lock();
+	tty_lock(tty);
 
 	mutex_lock(&tty->ldisc_mutex);
 	/*
diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 9ff986c..7664b10 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -4,29 +4,56 @@
 #include <linux/semaphore.h>
 #include <linux/sched.h>
 
-/*
- * The 'big tty mutex'
- *
- * This mutex is taken and released by tty_lock() and tty_unlock(),
- * replacing the older big kernel lock.
- * It can no longer be taken recursively, and does not get
- * released implicitly while sleeping.
- *
- * Don't use in new code.
- */
-static DEFINE_MUTEX(big_tty_mutex);
+/* Legacy tty mutex glue */
 
 /*
  * Getting the big tty mutex.
  */
-void __lockfunc tty_lock(void)
+
+void __lockfunc tty_lock(struct tty_struct *tty)
 {
-	mutex_lock(&big_tty_mutex);
+	if (mutex_is_locked(&tty->legacy_mutex)) {
+		WARN_ON(1);
+		return;
+	}
+	mutex_lock(&tty->legacy_mutex);
 }
 EXPORT_SYMBOL(tty_lock);
 
-void __lockfunc tty_unlock(void)
+void __lockfunc tty_unlock(struct tty_struct *tty)
 {
-	mutex_unlock(&big_tty_mutex);
+	if (!mutex_is_locked(&tty->legacy_mutex)) {
+		WARN_ON(1);
+		return;
+	}
+	mutex_unlock(&tty->legacy_mutex);
 }
 EXPORT_SYMBOL(tty_unlock);
+
+/*
+ * Getting the big tty mutex for a pair of ttys with lock ordering
+ * On a non pty/tty pair tty2 can be NULL which is just fine.
+ */
+void __lockfunc tty_lock_pair(struct tty_struct *tty,
+					struct tty_struct *tty2)
+{
+	if (tty < tty2) {
+		tty_lock(tty);
+		tty_lock(tty2);
+	} else {
+		if (tty2 && tty2 != tty)
+			tty_lock(tty2);
+		tty_lock(tty);
+	}
+}
+EXPORT_SYMBOL(tty_lock_pair);
+
+void __lockfunc tty_unlock_pair(struct tty_struct *tty,
+						struct tty_struct *tty2)
+{
+	tty_unlock(tty);
+	if (tty2 && tty2 != tty)
+		tty_unlock(tty2);
+}
+EXPORT_SYMBOL(tty_unlock_pair);
+
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index bf6e238..d9cca95 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -230,7 +230,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* block if port is in the process of being closed */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
-		wait_event_interruptible_tty(port->close_wait,
+		wait_event_interruptible_tty(tty, port->close_wait,
 				!(port->flags & ASYNC_CLOSING));
 		if (port->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
@@ -296,9 +296,9 @@ int tty_port_block_til_ready(struct tty_port *port,
 			retval = -ERESTARTSYS;
 			break;
 		}
-		tty_unlock();
+		tty_unlock(tty);
 		schedule();
-		tty_lock();
+		tty_lock(tty);
 	}
 	finish_wait(&port->open_wait, &wait);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f47ab5..4990ef2 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -268,6 +268,7 @@ struct tty_struct {
 	struct mutex ldisc_mutex;
 	struct tty_ldisc *ldisc;
 
+	struct mutex legacy_mutex;
 	struct mutex termios_mutex;
 	spinlock_t ctrl_lock;
 	/* Termios values are protected by the termios mutex */
@@ -605,8 +606,12 @@ extern long vt_compat_ioctl(struct tty_struct *tty,
 
 /* tty_mutex.c */
 /* functions for preparation of BKL removal */
-extern void __lockfunc tty_lock(void) __acquires(tty_lock);
-extern void __lockfunc tty_unlock(void) __releases(tty_lock);
+extern void __lockfunc tty_lock(struct tty_struct *tty);
+extern void __lockfunc tty_unlock(struct tty_struct *tty);
+extern void __lockfunc tty_lock_pair(struct tty_struct *tty,
+				struct tty_struct *tty2);
+extern void __lockfunc tty_unlock_pair(struct tty_struct *tty,
+				struct tty_struct *tty2);
 
 /*
  * this shall be called only from where BTM is held (like close)
@@ -621,9 +626,9 @@ extern void __lockfunc tty_unlock(void) __releases(tty_lock);
 static inline void tty_wait_until_sent_from_close(struct tty_struct *tty,
 		long timeout)
 {
-	tty_unlock(); /* tty->ops->close holds the BTM, drop it while waiting */
+	tty_unlock(tty); /* tty->ops->close holds the BTM, drop it while waiting */
 	tty_wait_until_sent(tty, timeout);
-	tty_lock();
+	tty_lock(tty);
 }
 
 /*
@@ -638,16 +643,16 @@ static inline void tty_wait_until_sent_from_close(struct tty_struct *tty,
  *
  * Do not use in new code.
  */
-#define wait_event_interruptible_tty(wq, condition)			\
+#define wait_event_interruptible_tty(tty, wq, condition)		\
 ({									\
 	int __ret = 0;							\
 	if (!(condition)) {						\
-		__wait_event_interruptible_tty(wq, condition, __ret);	\
+		__wait_event_interruptible_tty(tty, wq, condition, __ret);	\
 	}								\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_tty(wq, condition, ret)		\
+#define __wait_event_interruptible_tty(tty, wq, condition, ret)		\
 do {									\
 	DEFINE_WAIT(__wait);						\
 									\
@@ -656,9 +661,9 @@ do {									\
 		if (condition)						\
 			break;						\
 		if (!signal_pending(current)) {				\
-			tty_unlock();					\
+			tty_unlock(tty);					\
 			schedule();					\
-			tty_lock();					\
+			tty_lock(tty);					\
 			continue;					\
 		}							\
 		ret = -ERESTARTSYS;					\
