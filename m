Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771Ab2GBWBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:01:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:17209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab2GBWBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:01:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163286653"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Kay Sievers <kay@vrfy.org>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: RE: [PATCH] printk: replacing the raw_spin_lock/unlock with
 raw_spin_lock_irqsave/irqrestore
Thread-Topic: [PATCH] printk: replacing the raw_spin_lock/unlock with
 raw_spin_lock_irqsave/irqrestore
Thread-Index: AQHNWJXLxQUlAZ9SPEq/eraLzjltBJcWiirA
Date: Mon, 2 Jul 2012 22:01:19 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A10AFDE@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A109B17@SHSMSX101.ccr.corp.intel.com>
 <CAPXgP10pQWHYmi1egdArnbnmq=ATDbVo3GBG-=vHskrgkCH1xA@mail.gmail.com>
In-Reply-To: <CAPXgP10pQWHYmi1egdArnbnmq=ATDbVo3GBG-=vHskrgkCH1xA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q62M1VkC011782

Thanks your pointing out. New patch as below:

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] printk: replacing the raw_spin_lock/unlock with raw_spin_lock/unlock_irq

In function devkmsg_read/writev/llseek/poll/open()..., the function
raw_spin_lock/unlock is used, there is potential deadlock case happening.
CPU1: thread1 doing the cat /dev/kmsg:
        raw_spin_lock(&logbuf_lock);
        while (user->seq == log_next_seq) {
when thread1 run here, at this time one interrupt is coming on CPU1 and running
based on this thread,if the interrupt handle called the printk which need the
logbuf_lock spin also, it will cause deadlock.

So we should use raw_spin_lock/unlock_irq here.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/printk.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index dba1821..12886cd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -430,20 +430,20 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
        ret = mutex_lock_interruptible(&user->lock);
        if (ret)
                return ret;
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irq(&logbuf_lock);
        while (user->seq == log_next_seq) {
                if (file->f_flags & O_NONBLOCK) {
                        ret = -EAGAIN;
-                       raw_spin_unlock(&logbuf_lock);
+                       raw_spin_unlock_irq(&logbuf_lock);
                        goto out;
                }
 
-               raw_spin_unlock(&logbuf_lock);
+               raw_spin_unlock_irq(&logbuf_lock);
                ret = wait_event_interruptible(log_wait,
                                               user->seq != log_next_seq);
                if (ret)
                        goto out;
-               raw_spin_lock(&logbuf_lock);
+               raw_spin_lock_irq(&logbuf_lock);
        }
 
        if (user->seq < log_first_seq) {
@@ -451,7 +451,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
                user->idx = log_first_idx;
                user->seq = log_first_seq;
                ret = -EPIPE;
-               raw_spin_unlock(&logbuf_lock);
+               raw_spin_unlock_irq(&logbuf_lock);
                goto out;
        }
 
@@ -501,7 +501,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
        user->idx = log_next(user->idx);
        user->seq++;
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irq(&logbuf_lock);
 
        if (len > count) {
                ret = -EINVAL;
@@ -528,7 +528,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
        if (offset)
                return -ESPIPE;
 
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irq(&logbuf_lock);
        switch (whence) {
        case SEEK_SET:
                /* the first record */
@@ -552,7 +552,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
        default:
                ret = -EINVAL;
        }
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irq(&logbuf_lock);
        return ret;
 }
 
@@ -566,14 +566,14 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 
        poll_wait(file, &log_wait, wait);
 
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irq(&logbuf_lock);
        if (user->seq < log_next_seq) {
                /* return error when data has vanished underneath us */
                if (user->seq < log_first_seq)
                        ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
                ret = POLLIN|POLLRDNORM;
        }
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irq(&logbuf_lock);
 
        return ret;
 }
@@ -597,10 +597,10 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 
        mutex_init(&user->lock);
 
-       raw_spin_lock(&logbuf_lock);
+       raw_spin_lock_irq(&logbuf_lock);
        user->idx = log_first_idx;
        user->seq = log_first_seq;
-       raw_spin_unlock(&logbuf_lock);
+       raw_spin_unlock_irq(&logbuf_lock);
 
        file->private_data = user;
        return 0;
-- 
1.7.0.4


> -----Original Message-----
> From: Kay Sievers [mailto:kay@vrfy.org]
> Sent: Tuesday, July 03, 2012 5:01 AM
> To: Liu, Chuansheng
> Cc: 'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org);
> a.p.zijlstra@chello.nl; gregkh@linuxfoundation.org; mingo@elte.hu
> Subject: Re: [PATCH] printk: replacing the raw_spin_lock/unlock with
> raw_spin_lock_irqsave/irqrestore
> 
> On Mon, Jul 2, 2012 at 12:36 PM, Liu, Chuansheng <chuansheng.liu@intel.com>
> wrote:
> > From: liu chuansheng <chuansheng.liu@intel.com>
> > Subject: [PATCH] printk: replacing the raw_spin_lock/unlock with
> > raw_spin_lock_irqsave/irqrestore
> >
> > In function devkmsg_read/writev/llseek/poll/open()..., the function
> > raw_spin_lock/unlock is used, there is potential deadlock case happening.
> > CPU1: thread1 doing the cat /dev/kmsg:
> >         raw_spin_lock(&logbuf_lock);
> >         while (user->seq == log_next_seq) { when thread1 run here, at
> > this time one interrupt is coming on CPU1 and running based on this
> > thread,if the interrupt handle called the printk which need the
> > logbuf_lock spin also, it will cause deadlock.
> >
> > So we should use raw_spin_lock_irq_save/irqrestore here.
> 
> They are all handling a system call, isn't raw_spin_lock_irq() without the flag
> restoration good enough then?
> 
> Thanks,
> Kay
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
