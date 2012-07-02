Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2GBKhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:37:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:55899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab2GBKhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:37:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118056032"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: [PATCH] printk: replacing the raw_spin_lock/unlock with
 raw_spin_lock_irqsave/irqrestore
Thread-Topic: [PATCH] printk: replacing the raw_spin_lock/unlock with
 raw_spin_lock_irqsave/irqrestore
Thread-Index: Ac1YPpFnVlhI8U2JTmG3DFbysGKwvg==
Date: Mon, 2 Jul 2012 10:36:45 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A109B17@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] printk: replacing the raw_spin_lock/unlock with raw_spin_lock_irqsave/irqrestore

In function devkmsg_read/writev/llseek/poll/open()..., the function
raw_spin_lock/unlock is used, there is potential deadlock case happening.
CPU1: thread1 doing the cat /dev/kmsg:
        raw_spin_lock(&logbuf_lock);
        while (user->seq == log_next_seq) {
when thread1 run here, at this time one interrupt is coming on CPU1 and running
based on this thread,if the interrupt handle called the printk which need the
logbuf_lock spin also, it will cause deadlock.

So we should use raw_spin_lock_irq_save/irqrestore here.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/printk.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index dba1821..f57dc7b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -423,6 +423,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
        size_t i;
        size_t len;
        ssize_t ret;
+       unsigned long flags;
 
        if (!user)
                return -EBADF;
@@ -430,20 +431,20 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
        ret = mutex_lock_interruptible(&user->lock);
        if (ret)
                return ret;
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irqsave(&logbuf_lock, flags);
        while (user->seq == log_next_seq) {
                if (file->f_flags & O_NONBLOCK) {
                        ret = -EAGAIN;
-                       raw_spin_unlock(&logbuf_lock);
+                       raw_spin_unlock_irqrestore(&logbuf_lock, flags);
                        goto out;
                }
 
-               raw_spin_unlock(&logbuf_lock);
+               raw_spin_unlock_irqrestore(&logbuf_lock, flags);
                ret = wait_event_interruptible(log_wait,
                                               user->seq != log_next_seq);
                if (ret)
                        goto out;
-               raw_spin_lock(&logbuf_lock);
+               raw_spin_lock_irqsave(&logbuf_lock, flags);
        }
 
        if (user->seq < log_first_seq) {
@@ -451,7 +452,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
                user->idx = log_first_idx;
                user->seq = log_first_seq;
                ret = -EPIPE;
-               raw_spin_unlock(&logbuf_lock);
+               raw_spin_unlock_irqrestore(&logbuf_lock, flags);
                goto out;
        }
 
@@ -501,7 +502,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
        user->idx = log_next(user->idx);
        user->seq++;
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
        if (len > count) {
                ret = -EINVAL;
@@ -522,13 +523,14 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 {
        struct devkmsg_user *user = file->private_data;
        loff_t ret = 0;
+       unsigned long flags;
 
        if (!user)
                return -EBADF;
        if (offset)
                return -ESPIPE;
 
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irqsave(&logbuf_lock, flags);
        switch (whence) {
        case SEEK_SET:
                /* the first record */
@@ -552,7 +554,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
        default:
                ret = -EINVAL;
        }
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irqrestore(&logbuf_lock, flags);
        return ret;
 }
 
@@ -560,20 +562,21 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 {
        struct devkmsg_user *user = file->private_data;
        int ret = 0;
+       unsigned long flags;
 
        if (!user)
                return POLLERR|POLLNVAL;
 
        poll_wait(file, &log_wait, wait);
 
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irqsave(&logbuf_lock, flags);
        if (user->seq < log_next_seq) {
                /* return error when data has vanished underneath us */
                if (user->seq < log_first_seq)
                        ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
                ret = POLLIN|POLLRDNORM;
        }
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
        return ret;
 }
@@ -582,6 +585,7 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 {
        struct devkmsg_user *user;
        int err;
+       unsigned long flags;
 
        /* write-only does not need any file context */
        if ((file->f_flags & O_ACCMODE) == O_WRONLY)
@@ -597,10 +601,10 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 
        mutex_init(&user->lock);
 
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irqsave(&logbuf_lock, flags);
        user->idx = log_first_idx;
        user->seq = log_first_seq;
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
        file->private_data = user;
        return 0;
-- 
1.7.0.4
