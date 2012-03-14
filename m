Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab2CNPvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:51:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2CNPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:51:27 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=LfR_rfh0OyYqeNqDDeMA:9 a=4aMu4Sdd4tyVz_uCfWMA:7 a=PUjeQqilurYA:10 a=2x_47zPmX1kiumkL:21 a=fPpaouBYk7YUNv8G:21 a=r5VCLxTwKZWlqsq4VwQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331740278.25686.670.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.23-rt40
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 14 Mar 2012 11:51:18 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-M0oEd2u0zFJZYUwOl8Zd"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M0oEd2u0zFJZYUwOl8Zd
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.23-rt40 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 1a71c9ae0f844238de43681c41563a4203b7e933


Or to build 3.0.23-rt40 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.23.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.23-rt40.=
patch.xz


You can also build from 3.0.23-rt39 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.23-=
rt39-rt40.patch.xz



Enjoy,

-- Steve


Changes from 3.0.23-rt39:

---

Steven Rostedt (2):
      Revert "ACPI: Convert embedded controller lock to raw spinlock"
      Linux 3.0.23-rt40

Thomas Gleixner (5):
      softirq: Check preemption after reenabling interrupts
      rt: Introduce cpu_chill()
      fs: dcache: Use cpu_chill() in trylock loops
      fs: namespace: Use cpu_chill() instead of cpu_relax()
      net: Use cpu_chill() instead of cpu_relax()

----
 block/blk-iopoll.c      |    3 +++
 block/blk-softirq.c     |    3 +++
 drivers/acpi/ec.c       |   22 +++++++++++-----------
 drivers/acpi/internal.h |    2 +-
 fs/autofs4/autofs_i.h   |    1 +
 fs/autofs4/expire.c     |    2 +-
 fs/dcache.c             |    7 ++++---
 fs/namespace.c          |    3 ++-
 include/linux/delay.h   |    6 ++++++
 include/linux/preempt.h |    3 +++
 localversion-rt         |    2 +-
 net/core/dev.c          |    6 ++++++
 net/rds/ib_rdma.c       |    3 ++-
 13 files changed, 44 insertions(+), 19 deletions(-)
---------------------------
diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index 58916af..f7ca9b4 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -38,6 +38,7 @@ void blk_iopoll_sched(struct blk_iopoll *iop)
 	list_add_tail(&iop->list, &__get_cpu_var(blk_cpu_iopoll));
 	__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
 EXPORT_SYMBOL(blk_iopoll_sched);
=20
@@ -135,6 +136,7 @@ static void blk_iopoll_softirq(struct softirq_action *h=
)
 		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
=20
 	local_irq_enable();
+	preempt_check_resched_rt();
 }
=20
 /**
@@ -204,6 +206,7 @@ static int __cpuinit blk_iopoll_cpu_notify(struct notif=
ier_block *self,
 				 &__get_cpu_var(blk_cpu_iopoll));
 		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 		local_irq_enable();
+		preempt_check_resched_rt();
 	}
=20
 	return NOTIFY_OK;
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c216..0206963 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -50,6 +50,7 @@ static void trigger_softirq(void *data)
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
=20
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
=20
 /*
@@ -92,6 +93,7 @@ static int __cpuinit blk_cpu_notify(struct notifier_block=
 *self,
 				 &__get_cpu_var(blk_cpu_done));
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 		local_irq_enable();
+		preempt_check_resched_rt();
 	}
=20
 	return NOTIFY_OK;
@@ -139,6 +141,7 @@ do_local:
 		goto do_local;
=20
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
=20
 /**
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index db0e6c3..b72a603 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -152,10 +152,10 @@ static int ec_transaction_done(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	int ret =3D 0;
-	raw_spin_lock_irqsave(&ec->curr_lock, flags);
+	spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr || ec->curr->done)
 		ret =3D 1;
-	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
+	spin_unlock_irqrestore(&ec->curr_lock, flags);
 	return ret;
 }
=20
@@ -169,7 +169,7 @@ static void start_transaction(struct acpi_ec *ec)
 static void advance_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
-	raw_spin_lock_irqsave(&ec->curr_lock, flags);
+	spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr)
 		goto unlock;
 	if (ec->curr->wlen > ec->curr->wi) {
@@ -194,7 +194,7 @@ err:
 	if (in_interrupt())
 		++ec->curr->irq_count;
 unlock:
-	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
+	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
=20
 static int acpi_ec_sync_query(struct acpi_ec *ec);
@@ -232,9 +232,9 @@ static int ec_poll(struct acpi_ec *ec)
 		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
 			break;
 		pr_debug(PREFIX "controller reset, restart transaction\n");
-		raw_spin_lock_irqsave(&ec->curr_lock, flags);
+		spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);
-		raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
+		spin_unlock_irqrestore(&ec->curr_lock, flags);
 	}
 	return -ETIME;
 }
@@ -247,17 +247,17 @@ static int acpi_ec_transaction_unlocked(struct acpi_e=
c *ec,
 	if (EC_FLAGS_MSI)
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
-	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
+	spin_lock_irqsave(&ec->curr_lock, tmp);
 	/* following two actions should be kept atomic */
 	ec->curr =3D t;
 	start_transaction(ec);
 	if (ec->curr->command =3D=3D ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
-	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	ret =3D ec_poll(ec);
-	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
+	spin_lock_irqsave(&ec->curr_lock, tmp);
 	ec->curr =3D NULL;
-	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	return ret;
 }
=20
@@ -678,7 +678,7 @@ static struct acpi_ec *make_acpi_ec(void)
 	mutex_init(&ec->lock);
 	init_swait_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
-	raw_spin_lock_init(&ec->curr_lock);
+	spin_lock_init(&ec->curr_lock);
 	return ec;
 }
=20
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 2519b6e..6f889ba 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -64,7 +64,7 @@ struct acpi_ec {
 	struct swait_head wait;
 	struct list_head list;
 	struct transaction *curr;
-	raw_spinlock_t curr_lock;
+	spinlock_t curr_lock;
 };
=20
 extern struct acpi_ec *first_ec;
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index b620114..83424ab 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -34,6 +34,7 @@
 #include <linux/sched.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/delay.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
=20
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index d8b6184..f4abda3 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -170,7 +170,7 @@ again:
 			parent =3D p->d_parent;
 			if (!seq_spin_trylock(&parent->d_lock)) {
 				seq_spin_unlock(&p->d_lock);
-				cpu_relax();
+				cpu_chill();
 				goto relock;
 			}
 			seq_spin_unlock(&p->d_lock);
diff --git a/fs/dcache.c b/fs/dcache.c
index 10580be..eedf276 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -36,6 +36,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
+#include <linux/delay.h>
 #include "internal.h"
=20
 /*
@@ -360,7 +361,7 @@ static inline struct dentry *dentry_kill(struct dentry =
*dentry, int ref)
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
 		seq_spin_unlock(&dentry->d_lock);
-		cpu_relax();
+		cpu_chill();
 		return dentry; /* try again with same dentry */
 	}
 	if (IS_ROOT(dentry))
@@ -738,7 +739,7 @@ relock:
=20
 		if (!seq_spin_trylock(&dentry->d_lock)) {
 			spin_unlock(&dcache_lru_lock);
-			cpu_relax();
+			cpu_chill();
 			goto relock;
 		}
=20
@@ -2053,7 +2054,7 @@ again:
 	if (dentry->d_count =3D=3D 1) {
 		if (inode && !spin_trylock(&inode->i_lock)) {
 			seq_spin_unlock(&dentry->d_lock);
-			cpu_relax();
+			cpu_chill();
 			goto again;
 		}
 		dentry->d_flags &=3D ~DCACHE_CANT_MOUNT;
diff --git a/fs/namespace.c b/fs/namespace.c
index c563781..3270cde 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
 #include <linux/fsnotify.h>
+#include <linux/delay.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -346,7 +347,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	 */
 	while (mnt->mnt_flags & MNT_WRITE_HOLD) {
 		preempt_enable();
-		cpu_relax();
+		cpu_chill();
 		preempt_disable();
 	}
 	/*
diff --git a/include/linux/delay.h b/include/linux/delay.h
index a6ecb34..e23a7c0 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -52,4 +52,10 @@ static inline void ssleep(unsigned int seconds)
 	msleep(seconds * 1000);
 }
=20
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define cpu_chill()	msleep(1)
+#else
+# define cpu_chill()	cpu_relax()
+#endif
+
 #endif /* defined(_LINUX_DELAY_H) */
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 7a2bbbb..11412d7 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -41,8 +41,10 @@ do { \
=20
 #ifndef CONFIG_PREEMPT_RT_BASE
 # define preempt_enable_no_resched()	__preempt_enable_no_resched()
+# define preempt_check_resched_rt()	do { } while (0)
 #else
 # define preempt_enable_no_resched()	preempt_enable()
+# define preempt_check_resched_rt()	preempt_check_resched()
 #endif
=20
 #define preempt_check_resched() \
@@ -93,6 +95,7 @@ do { \
 #define preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable()		do { } while (0)
 #define preempt_check_resched()		do { } while (0)
+#define preempt_check_resched_rt()	do { } while (0)
=20
 #define preempt_disable_notrace()		do { } while (0)
 #define preempt_enable_no_resched_notrace()	do { } while (0)
diff --git a/localversion-rt b/localversion-rt
index 5498386..2af6c89 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt39
+-rt40
diff --git a/net/core/dev.c b/net/core/dev.c
index 7606d18..b250c1d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1705,6 +1705,7 @@ static inline void __netif_reschedule(struct Qdisc *q=
)
 	sd->output_queue_tailp =3D &q->next_sched;
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
=20
 void __netif_schedule(struct Qdisc *q)
@@ -1726,6 +1727,7 @@ void dev_kfree_skb_irq(struct sk_buff *skb)
 		sd->completion_queue =3D skb;
 		raise_softirq_irqoff(NET_TX_SOFTIRQ);
 		local_irq_restore(flags);
+		preempt_check_resched_rt();
 	}
 }
 EXPORT_SYMBOL(dev_kfree_skb_irq);
@@ -2837,6 +2839,7 @@ enqueue:
 	rps_unlock(sd);
=20
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
=20
 	atomic_long_inc(&skb->dev->rx_dropped);
 	kfree_skb(skb);
@@ -3659,6 +3662,7 @@ static void net_rps_action_and_irq_enable(struct soft=
net_data *sd)
 	} else
 #endif
 		local_irq_enable();
+	preempt_check_resched_rt();
 }
=20
 static int process_backlog(struct napi_struct *napi, int quota)
@@ -3731,6 +3735,7 @@ void __napi_schedule(struct napi_struct *n)
 	local_irq_save(flags);
 	____napi_schedule(&__get_cpu_var(softnet_data), n);
 	local_irq_restore(flags);
+	preempt_check_resched_rt();
 }
 EXPORT_SYMBOL(__napi_schedule);
=20
@@ -6233,6 +6238,7 @@ static int dev_cpu_callback(struct notifier_block *nf=
b,
=20
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_enable();
+	preempt_check_resched_rt();
=20
 	/* Process offline CPU's input_pkt_queue */
 	while ((skb =3D __skb_dequeue(&oldsd->process_queue))) {
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 819c35a..256ad87 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -33,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/rculist.h>
+#include <linux/delay.h>
=20
 #include "rds.h"
 #include "ib.h"
@@ -294,7 +295,7 @@ static inline void wait_clean_list_grace(void)
 	for_each_online_cpu(cpu) {
 		flag =3D &per_cpu(clean_list_grace, cpu);
 		while (test_bit(CLEAN_LIST_BUSY_BIT, flag))
-			cpu_relax();
+			cpu_chill();
 	}
 }
=20


--=-M0oEd2u0zFJZYUwOl8Zd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYL52AAoJEIy3vGnGbaoAwUYP/2wrP5I5gOE+0UEI3Nd8RXb2
r9H+IMXFnnVucGIlBnUb6/3+O4sosaTiCJsmEf3m2fZfn4lmjxPSnOnkQkVs1m/3
o8duh9IUoZBX+x6Gduh0U3/xW8OJH3Emm8R2+VpkHHYvYa53xtssUW72DfknQeJe
HYc26TxR+bouFH0e5dopnCm3u5jOFcuKZ0uLf7XKf+xc0QNrU5X244mZQ2vlhYJK
+a1kZpPpOx6e9Q+6eo8Xuy4z/Xye4YDMK8Oz+bu4oMq81NcbK4NmMLRuDjZnSd8/
/Esz49UB0yJVGfjDuBJu37suiymMOk0uOa64jv5PSrJHm5sSWy7o9AKz8C2mPwa7
KKhFC3k7wlN2ekbDinkCOoQ4HZ7+MD8Cb0YL7f29zRqKRhUbGxiN+LegnbjyPXoF
c5bv5bp4ekDs5BNIL+uS+ucPB4PlHbzdLju73aI0s1V0UzntQbeTCt9v0HfwwsJ0
thSSpqEizXQHbjFhu+4yGChH3Qi8BRyGvy6/L0KDTJBRDdFP8iyFJ0D3ZqosWf1U
GYVoig67ASDNpy80KRtIlG1MmMfxv0g8A77+M2+QVB1ZhGIz18K1Ob/QZWIdMGhj
v3oZUliloFPlWDolGbbyRaqU2bRmQaAlO+wnoqA6MCqohCRdeIQf/TGR36N25LOZ
9V4cpqpBuBlwlR5wX7KQ
=uMJk
-----END PGP SIGNATURE-----

--=-M0oEd2u0zFJZYUwOl8Zd--

