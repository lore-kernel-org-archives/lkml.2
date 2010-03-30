Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0C3U5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:57:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0C3U5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 7/9] ppp: use big tty mutex
Date: Tue, 30 Mar 2010 22:56:18 +0200
Message-Id: <1269982580-9361-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+CtcIcacQ1ofcNBRlk2Gg8VHQvy689sSRToO6
 lotlAoUQkXgFuvH70K136m60AFzQgn+PUCbXc1kSBIUjELlf84
 Om/gJ3boqZAQ7vX3w6LDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppp interacts with the tty layer, so it should
take the BTM instead of the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp_generic.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 6d61602..bc89a1b 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -40,7 +40,7 @@
 #include <linux/if_arp.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/smp_lock.h>
+#include <linux/tty.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
 #include <linux/stddef.h>
@@ -362,7 +362,8 @@ static const int npindex_to_ethertype[NUM_NP] = {
  */
 static int ppp_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
+	tty_lock();
+	tty_unlock();
 	/*
 	 * This could (should?) be enforced by the permissions on /dev/ppp.
 	 */
@@ -584,7 +585,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		 * this fd and reopening /dev/ppp.
 		 */
 		err = -EINVAL;
-		lock_kernel();
+		tty_lock();
 		if (pf->kind == INTERFACE) {
 			ppp = PF_TO_PPP(pf);
 			if (file == ppp->owner)
@@ -596,7 +597,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		} else
 			printk(KERN_DEBUG "PPPIOCDETACH file->f_count=%ld\n",
 			       atomic_long_read(&file->f_count));
-		unlock_kernel();
+		tty_unlock();
 		return err;
 	}
 
@@ -604,7 +605,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		struct channel *pch;
 		struct ppp_channel *chan;
 
-		lock_kernel();
+		tty_lock();
 		pch = PF_TO_CHANNEL(pf);
 
 		switch (cmd) {
@@ -626,7 +627,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				err = chan->ops->ioctl(chan, cmd, arg);
 			up_read(&pch->chan_sem);
 		}
-		unlock_kernel();
+		tty_unlock();
 		return err;
 	}
 
@@ -636,7 +637,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return -EINVAL;
 	}
 
-	lock_kernel();
+	tty_lock();
 	ppp = PF_TO_PPP(pf);
 	switch (cmd) {
 	case PPPIOCSMRU:
@@ -784,7 +785,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		err = -ENOTTY;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return err;
 }
 
@@ -797,7 +798,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 	struct ppp_net *pn;
 	int __user *p = (int __user *)arg;
 
-	lock_kernel();
+	tty_lock();
 	switch (cmd) {
 	case PPPIOCNEWUNIT:
 		/* Create a new ppp unit */
@@ -820,7 +821,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 			break;
 		err = -ENXIO;
 		pn = ppp_pernet(net);
-		mutex_lock(&pn->all_ppp_mutex);
+		mutex_lock_tty_on(&pn->all_ppp_mutex);
 		ppp = ppp_find_unit(pn, unit);
 		if (ppp) {
 			atomic_inc(&ppp->file.refcnt);
@@ -848,7 +849,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 	default:
 		err = -ENOTTY;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return err;
 }
 
@@ -2553,7 +2554,7 @@ ppp_create_interface(struct net *net, int unit, int *retp)
 	dev_net_set(dev, net);
 
 	ret = -EEXIST;
-	mutex_lock(&pn->all_ppp_mutex);
+	mutex_lock_tty_on(&pn->all_ppp_mutex);
 
 	if (unit < 0) {
 		unit = unit_get(&pn->units_idr, ppp);
@@ -2628,7 +2629,7 @@ static void ppp_shutdown_interface(struct ppp *ppp)
 	struct ppp_net *pn;
 
 	pn = ppp_pernet(ppp->ppp_net);
-	mutex_lock(&pn->all_ppp_mutex);
+	mutex_lock_tty(&pn->all_ppp_mutex);
 
 	/* This will call dev_close() for us. */
 	ppp_lock(ppp);
@@ -2737,7 +2738,7 @@ ppp_connect_channel(struct channel *pch, int unit)
 
 	pn = ppp_pernet(pch->chan_net);
 
-	mutex_lock(&pn->all_ppp_mutex);
+	mutex_lock_tty_on(&pn->all_ppp_mutex);
 	ppp = ppp_find_unit(pn, unit);
 	if (!ppp)
 		goto out;
-- 
1.7.0

