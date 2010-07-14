Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab0GNUMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:12:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52341 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab0GNUKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC tip/core/rcu 19/30] vhost: add __rcu annotations
Date: Wed, 14 Jul 2010 13:09:53 -0700
Message-Id: <1279138204-12849-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

Also add rcu_dreference_protected() for code paths where locks are held.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
---
 drivers/vhost/net.c   |   15 +++++++++++----
 drivers/vhost/vhost.c |   29 +++++++++++++++++++++++------
 drivers/vhost/vhost.h |   11 ++++++++---
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df5b6b9..e044dd0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -110,7 +110,9 @@ static void handle_tx(struct vhost_net *net)
 	size_t len, total_len = 0;
 	int err, wmem;
 	size_t hdr_size;
-	struct socket *sock = rcu_dereference(vq->private_data);
+	struct socket *sock;
+
+	sock = rcu_dereference_check(vq->private_data, in_vhost_workqueue());
 	if (!sock)
 		return;
 
@@ -364,7 +366,10 @@ static void vhost_net_disable_vq(struct vhost_net *n,
 static void vhost_net_enable_vq(struct vhost_net *n,
 				struct vhost_virtqueue *vq)
 {
-	struct socket *sock = vq->private_data;
+	struct socket *sock;
+
+	sock = rcu_dereference_protected(vq->private_data,
+					 lockdep_is_held(&vq->mutex));
 	if (!sock)
 		return;
 	if (vq == n->vqs + VHOST_NET_VQ_TX) {
@@ -380,7 +385,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	struct socket *sock;
 
 	mutex_lock(&vq->mutex);
-	sock = vq->private_data;
+	sock = rcu_dereference_protected(vq->private_data,
+					 lockdep_is_held(&vq->mutex));
 	vhost_net_disable_vq(n, vq);
 	rcu_assign_pointer(vq->private_data, NULL);
 	mutex_unlock(&vq->mutex);
@@ -518,7 +524,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	}
 
 	/* start polling new socket */
-	oldsock = vq->private_data;
+	oldsock = rcu_dereference_protected(vq->private_data,
+					    lockdep_is_held(&vq->mutex));
 	if (sock == oldsock)
 		goto done;
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3b83382..aa7603a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -39,6 +39,13 @@ enum {
 
 static struct workqueue_struct *vhost_workqueue;
 
+#ifdef CONFIG_PROVE_RCU
+int in_vhost_workqueue(void)
+{
+	return in_workqueue_context(vhost_workqueue);
+}
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
 static void vhost_poll_func(struct file *file, wait_queue_head_t *wqh,
 			    poll_table *pt)
 {
@@ -180,7 +187,7 @@ long vhost_dev_reset_owner(struct vhost_dev *dev)
 	vhost_dev_cleanup(dev);
 
 	memory->nregions = 0;
-	dev->memory = memory;
+	RCU_INIT_POINTER(dev->memory, memory);
 	return 0;
 }
 
@@ -212,8 +219,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 		fput(dev->log_file);
 	dev->log_file = NULL;
 	/* No one will access memory at this point */
-	kfree(dev->memory);
-	dev->memory = NULL;
+	kfree(rcu_dereference_protected(dev->memory,
+					lockdep_is_held(&dev->mutex)));
+	RCU_INIT_POINTER(dev->memory, NULL);
 	if (dev->mm)
 		mmput(dev->mm);
 	dev->mm = NULL;
@@ -294,14 +302,22 @@ static int vq_access_ok(unsigned int num,
 /* Caller should have device mutex but not vq mutex */
 int vhost_log_access_ok(struct vhost_dev *dev)
 {
-	return memory_access_ok(dev, dev->memory, 1);
+	struct vhost_memory *mp;
+
+	mp = rcu_dereference_protected(dev->memory,
+				       lockdep_is_held(&dev->mutex));
+	return memory_access_ok(dev, mp, 1);
 }
 
 /* Verify access for write logging. */
 /* Caller should have vq mutex and device mutex */
 static int vq_log_access_ok(struct vhost_virtqueue *vq, void __user *log_base)
 {
-	return vq_memory_access_ok(log_base, vq->dev->memory,
+	struct vhost_memory *mp;
+
+	mp = rcu_dereference_protected(vq->dev->memory,
+				       lockdep_is_held(&vq->mutex));
+	return vq_memory_access_ok(log_base, mp,
 			    vhost_has_feature(vq->dev, VHOST_F_LOG_ALL)) &&
 		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
 					sizeof *vq->used +
@@ -341,7 +357,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		kfree(newmem);
 		return -EFAULT;
 	}
-	oldmem = d->memory;
+	oldmem = rcu_dereference_protected(d->memory,
+					   lockdep_is_held(&d->mutex));
 	rcu_assign_pointer(d->memory, newmem);
 	synchronize_rcu();
 	kfree(oldmem);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 44591ba..48fb0ff 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -92,7 +92,7 @@ struct vhost_virtqueue {
 	 * work item execution acts instead of rcu_read_lock() and the end of
 	 * work item execution acts instead of rcu_read_lock().
 	 * Writers use virtqueue mutex. */
-	void *private_data;
+	void __rcu *private_data;
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log log[VHOST_NET_MAX_SG];
@@ -102,7 +102,7 @@ struct vhost_dev {
 	/* Readers use RCU to access memory table pointer
 	 * log base pointer and features.
 	 * Writers use mutex below.*/
-	struct vhost_memory *memory;
+	struct vhost_memory __rcu *memory;
 	struct mm_struct *mm;
 	struct mutex mutex;
 	unsigned acked_features;
@@ -112,6 +112,7 @@ struct vhost_dev {
 	struct eventfd_ctx *log_ctx;
 };
 
+int in_vhost_workqueue(void);
 long vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue *vqs, int nvqs);
 long vhost_dev_check_owner(struct vhost_dev *);
 long vhost_dev_reset_owner(struct vhost_dev *);
@@ -154,7 +155,11 @@ enum {
 
 static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
 {
-	unsigned acked_features = rcu_dereference(dev->acked_features);
+	unsigned acked_features;
+
+	acked_features =
+		rcu_dereference_index_check(dev->acked_features,
+					    lockdep_is_held(&dev->mutex));
 	return acked_features & (1 << bit);
 }
 
-- 
1.7.0.6

