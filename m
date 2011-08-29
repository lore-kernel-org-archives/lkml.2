Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1H2Lmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:42:33 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:58590 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1H2LmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:42:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] [PATCH 068/118] drbd: conn_printk() a dev_printk() alike for drbd's connections
Date: Mon, 29 Aug 2011 13:42:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: drbd-dev@lists.linbit.com
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com> <1314284934-17999-69-git-send-email-philipp.reisner@linbit.com> <1314296185.15882.75.camel@Joe-Laptop>
In-Reply-To: <1314296185.15882.75.camel@Joe-Laptop>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201108291342.08926.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 25. August 2011, 20:16:25 schrieb Joe Perches:
> On Thu, 2011-08-25 at 17:08 +0200, Philipp Reisner wrote:
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > ---
> > 
> >  drivers/block/drbd/drbd_int.h  |    9 +++++++++
> >  drivers/block/drbd/drbd_main.c |   16 +++++++++++++++-
> >  2 files changed, 24 insertions(+), 1 deletions(-)
> 
> Couple of issues with this patch.
> 
> > diff --git a/drivers/block/drbd/drbd_int.h
> > b/drivers/block/drbd/drbd_int.h
> 
> []
> 
> > @@ -102,6 +102,15 @@ struct drbd_tconn;
> 
> []
> 
> > +extern void conn_printk(const char *level, struct drbd_tconn *tconn,
> > const char *fmt, ...);
> 
> This should be
> 
> extern __attribute__((format (printf, 3, 4)))
> void conn_printk(const char *level, struct drbd_tconn *tconn, const char 
> *fmt, ...);
> 
> to have gcc validate the printf format and arguments.
> 
> > diff --git a/drivers/block/drbd/drbd_main.c
> > b/drivers/block/drbd/drbd_main.c
> 
> []
> 
> > @@ -170,6 +170,18 @@ int _get_ldev_if_state(struct drbd_conf *mdev, enum
> > drbd_disk_state mins)
> > 
> >  #endif
> > 
> > +/* printk functions for connections
> > + */
> > +void conn_printk(const char *level, struct drbd_tconn *tconn, const char
> > *fmt, ...) +{
> > +	va_list args;
> > +
> > +	printk("%sd-con %s: ", level, tconn->name);
> > +	va_start(args, fmt);
> > +	vprintk(fmt, args);
> > +	va_end(args);
> 
> And using printk then vprintk is susceptible
> to another thread interleaving a different
> message between the printk and the vprintk.
> 
> Using struct va_format and %pV is better
> because no message interleaving is possible.
> 
[...]

Actually we came across the interleaving issue as
well and solved it at a later point in time by
converting it into a macro. I folded that into this
patch, which gives us:


>From 3fd752956c255f85429f29603fd080e41ca2d90c Mon Sep 17 00:00:00 2001
From: Philipp Reisner <philipp.reisner@linbit.com>
Date: Mon, 7 Feb 2011 14:01:51 +0100
Subject: [PATCH 068/118] drbd: conn_printk() a dev_printk() alike for drbd's connections

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |   10 ++++++++++
 drivers/block/drbd/drbd_main.c |    4 +++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 927bf77..4d3320d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -102,6 +102,16 @@ struct drbd_tconn;
 /* to shorten dev_warn(DEV, "msg"); and relatives statements */
 #define DEV (disk_to_dev(mdev->vdisk))
 
+#define conn_printk(LEVEL, TCONN, FMT, ARGS...) \
+       printk(LEVEL "d-con %s: " FMT, TCONN->name , ## ARGS)
+#define conn_alert(TCONN, FMT, ARGS...)  conn_printk(KERN_ALERT, TCONN, FMT, ## ARGS)
+#define conn_crit(TCONN, FMT, ARGS...)   conn_printk(KERN_CRIT, TCONN, FMT, ## ARGS)
+#define conn_err(TCONN, FMT, ARGS...)    conn_printk(KERN_ERR, TCONN, FMT, ## ARGS)
+#define conn_warn(TCONN, FMT, ARGS...)   conn_printk(KERN_WARNING, TCONN, FMT, ## ARGS)
+#define conn_notice(TCONN, FMT, ARGS...) conn_printk(KERN_NOTICE, TCONN, FMT, ## ARGS)
+#define conn_info(TCONN, FMT, ARGS...)   conn_printk(KERN_INFO, TCONN, FMT, ## ARGS)
+#define conn_dbg(TCONN, FMT, ARGS...)    conn_printk(KERN_DEBUG, TCONN, FMT, ## ARGS)
+
 #define D_ASSERT(exp)  if (!(exp)) \
         dev_err(DEV, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index dbd6d72..59a3166 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2217,12 +2217,14 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
        struct drbd_conf *mdev;
        struct gendisk *disk;
        struct request_queue *q;
+       char conn_name[9]; /* drbd1234N */
 
        /* GFP_KERNEL, we are outside of all write-out paths */
        mdev = kzalloc(sizeof(struct drbd_conf), GFP_KERNEL);
        if (!mdev)
                return NULL;
-       mdev->tconn = drbd_new_tconn("dummy");
+       sprintf(conn_name, "drbd%d", minor);
+       mdev->tconn = drbd_new_tconn(conn_name);
        if (!mdev->tconn)
                goto out_no_tconn;
 
-- 
1.7.4.1

-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
