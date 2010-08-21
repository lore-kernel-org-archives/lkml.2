Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0HUXrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 19:47:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37982 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab0HUXrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 19:47:39 -0400
Date: Sat, 21 Aug 2010 16:47:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        mst@redhat.com, arnd@arndb.de
Subject: [PATCH tip/core/rcu] vhost: add __rcu annotations
Message-ID: <20100821234733.GA19817@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reverted this patch due to conflicts, but leaving it off entirely
results in build errors in Ingo's tree.  So here is a forward port.
It compiles, but I don't have the means to test it.

Michael, thoughts?

							Thanx, Paul

------------------------------------------------------------------------

Also add rcu_dereference_protected() for code paths where locks are held.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 29e850a..1318ee0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -127,7 +127,10 @@ static void handle_tx(struct vhost_net *net)
 	size_t len, total_len = 0;
 	int err, wmem;
 	size_t hdr_size;
-	struct socket *sock = rcu_dereference(vq->private_data);
+	struct socket *sock;
+
+	sock = rcu_dereference_check(vq->private_data,
+				     lockdep_is_held(&vq->mutex));
 	if (!sock)
 		return;
 
@@ -582,7 +585,10 @@ static void vhost_net_disable_vq(struct vhost_net *n,
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
@@ -598,7 +604,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	struct socket *sock;
 
 	mutex_lock(&vq->mutex);
-	sock = vq->private_data;
+	sock = rcu_dereference_protected(vq->private_data,
+					 lockdep_is_held(&vq->mutex));
 	vhost_net_disable_vq(n, vq);
 	rcu_assign_pointer(vq->private_data, NULL);
 	mutex_unlock(&vq->mutex);
@@ -736,7 +743,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	}
 
 	/* start polling new socket */
-	oldsock = vq->private_data;
+	oldsock = rcu_dereference_protected(vq->private_data,
+					    lockdep_is_held(&vq->mutex));
 	if (sock != oldsock) {
                 vhost_net_disable_vq(n, vq);
                 rcu_assign_pointer(vq->private_data, sock);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e05557d..b5c4947 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -284,7 +284,7 @@ long vhost_dev_reset_owner(struct vhost_dev *dev)
 	vhost_dev_cleanup(dev);
 
 	memory->nregions = 0;
-	dev->memory = memory;
+	RCU_INIT_POINTER(dev->memory, memory);
 	return 0;
 }
 
@@ -316,8 +316,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
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
@@ -401,14 +402,22 @@ static int vq_access_ok(unsigned int num,
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
@@ -448,7 +457,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
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
index afd7729..af3c11d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -106,7 +106,7 @@ struct vhost_virtqueue {
 	 * vhost_work execution acts instead of rcu_read_lock() and the end of
 	 * vhost_work execution acts instead of rcu_read_lock().
 	 * Writers use virtqueue mutex. */
-	void *private_data;
+	void __rcu *private_data;
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log log[VHOST_NET_MAX_SG];
@@ -116,7 +116,7 @@ struct vhost_dev {
 	/* Readers use RCU to access memory table pointer
 	 * log base pointer and features.
 	 * Writers use mutex below.*/
-	struct vhost_memory *memory;
+	struct vhost_memory __rcu *memory;
 	struct mm_struct *mm;
 	struct mutex mutex;
 	unsigned acked_features;
@@ -173,7 +173,11 @@ enum {
 
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
 
