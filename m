Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1GKO77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:59:59 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49536 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab1GKO76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:59:58 -0400
Date: Mon, 11 Jul 2011 07:46:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: jkosina@suse.cz
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: rcu: Convert trivial uses of call_rcu() to kfree_rcu()
Message-ID: <20110711144643.GA4076@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jiri!

Does the patch below qualify as trivial?  If so, please feel free to
take it off my hands.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Convert trivial uses of call_rcu() to kfree_rcu()

A number of RCU callbacks just directly call kfree(), so these can use
the new kfree_rcu() interface, thus allowing these trivial RCU callback
functions to be removed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

 arch/ia64/sn/kernel/irq.c     |   14 ++------------
 block/genhd.c                 |   10 +---------
 drivers/scsi/libfc/fc_rport.c |   14 +-------------
 ipc/sem.c                     |   10 ++--------
 ipc/util.c                    |   16 +---------------
 kernel/audit_tree.c           |    8 +-------
 kernel/sysctl.c               |   11 +++--------
 mm/vmalloc.c                  |   18 ++----------------
 net/netfilter/xt_RATEEST.c    |    8 +-------
 security/selinux/netnode.c    |   20 ++------------------
 security/selinux/netport.c    |   20 ++------------------
 11 files changed, 18 insertions(+), 131 deletions(-)

diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 81a1f4e..485c42d 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -112,8 +112,6 @@ static void sn_ack_irq(struct irq_data *data)
 	irq_move_irq(data);
 }
 
-static void sn_irq_info_free(struct rcu_head *head);
-
 struct sn_irq_info *sn_retarget_vector(struct sn_irq_info *sn_irq_info,
 				       nasid_t nasid, int slice)
 {
@@ -177,7 +175,7 @@ struct sn_irq_info *sn_retarget_vector(struct sn_irq_info *sn_irq_info,
 	spin_lock(&sn_irq_info_lock);
 	list_replace_rcu(&sn_irq_info->list, &new_irq_info->list);
 	spin_unlock(&sn_irq_info_lock);
-	call_rcu(&sn_irq_info->rcu, sn_irq_info_free);
+	kfree_rcu(sn_irq_info, rcu);
 
 
 finish_up:
@@ -338,14 +336,6 @@ static void unregister_intr_pda(struct sn_irq_info *sn_irq_info)
 	rcu_read_unlock();
 }
 
-static void sn_irq_info_free(struct rcu_head *head)
-{
-	struct sn_irq_info *sn_irq_info;
-
-	sn_irq_info = container_of(head, struct sn_irq_info, rcu);
-	kfree(sn_irq_info);
-}
-
 void sn_irq_fixup(struct pci_dev *pci_dev, struct sn_irq_info *sn_irq_info)
 {
 	nasid_t nasid = sn_irq_info->irq_nasid;
@@ -399,7 +389,7 @@ void sn_irq_unfixup(struct pci_dev *pci_dev)
 	spin_unlock(&sn_irq_info_lock);
 	if (list_empty(sn_irq_lh[sn_irq_info->irq_irq]))
 		free_irq_vector(sn_irq_info->irq_irq);
-	call_rcu(&sn_irq_info->rcu, sn_irq_info_free);
+	kfree_rcu(sn_irq_info, rcu);
 	pci_dev_put(pci_dev);
 
 }
diff --git a/block/genhd.c b/block/genhd.c
index 3608289..6024b82 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1018,14 +1018,6 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
-{
-	struct disk_part_tbl *ptbl =
-		container_of(head, struct disk_part_tbl, rcu_head);
-
-	kfree(ptbl);
-}
-
 /**
  * disk_replace_part_tbl - replace disk->part_tbl in RCU-safe way
  * @disk: disk to replace part_tbl for
@@ -1046,7 +1038,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
 
 	if (old_ptbl) {
 		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
-		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
+		kfree_rcu(old_ptbl, rcu_head);
 	}
 }
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 49e1ccc..01e13a2 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -153,18 +153,6 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 }
 
 /**
- * fc_rport_free_rcu() - Free a remote port
- * @rcu: The rcu_head structure inside the remote port
- */
-static void fc_rport_free_rcu(struct rcu_head *rcu)
-{
-	struct fc_rport_priv *rdata;
-
-	rdata = container_of(rcu, struct fc_rport_priv, rcu);
-	kfree(rdata);
-}
-
-/**
  * fc_rport_destroy() - Free a remote port after last reference is released
  * @kref: The remote port's kref
  */
@@ -173,7 +161,7 @@ static void fc_rport_destroy(struct kref *kref)
 	struct fc_rport_priv *rdata;
 
 	rdata = container_of(kref, struct fc_rport_priv, kref);
-	call_rcu(&rdata->rcu, fc_rport_free_rcu);
+	kfree_rcu(rdata, rcu);
 }
 
 /**
diff --git a/ipc/sem.c b/ipc/sem.c
index 34193ed..8b929e6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -689,12 +689,6 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 	return semzcnt;
 }
 
-static void free_un(struct rcu_head *head)
-{
-	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
-	kfree(un);
-}
-
 /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
@@ -714,7 +708,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1612,7 +1606,7 @@ void exit_sem(struct task_struct *tsk)
 		sem_unlock(sma);
 		wake_up_sem_queue_do(&tasks);
 
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
diff --git a/ipc/util.c b/ipc/util.c
index 5c0d289..75261a3 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -579,19 +579,6 @@ static void ipc_schedule_free(struct rcu_head *head)
 	schedule_work(&sched->work);
 }
 
-/**
- * ipc_immediate_free - free ipc + rcu space
- * @head: RCU callback structure that contains pointer to be freed
- *
- * Free from the RCU callback context.
- */
-static void ipc_immediate_free(struct rcu_head *head)
-{
-	struct ipc_rcu_grace *free =
-		container_of(head, struct ipc_rcu_grace, rcu);
-	kfree(free);
-}
-
 void ipc_rcu_putref(void *ptr)
 {
 	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
@@ -601,8 +588,7 @@ void ipc_rcu_putref(void *ptr)
 		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
 				ipc_schedule_free);
 	} else {
-		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
-				ipc_immediate_free);
+		kfree_rcu(container_of(ptr, struct ipc_rcu_grace, data), rcu);
 	}
 }
 
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index e99dda0..5bf0790 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -93,16 +93,10 @@ static inline void get_tree(struct audit_tree *tree)
 	atomic_inc(&tree->count);
 }
 
-static void __put_tree(struct rcu_head *rcu)
-{
-	struct audit_tree *tree = container_of(rcu, struct audit_tree, head);
-	kfree(tree);
-}
-
 static inline void put_tree(struct audit_tree *tree)
 {
 	if (atomic_dec_and_test(&tree->count))
-		call_rcu(&tree->head, __put_tree);
+		kfree_rcu(tree, head);
 }
 
 /* to avoid bringing the entire thing in audit.h */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f175d98..11d65b5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1590,16 +1590,11 @@ void sysctl_head_get(struct ctl_table_header *head)
 	spin_unlock(&sysctl_lock);
 }
 
-static void free_head(struct rcu_head *rcu)
-{
-	kfree(container_of(rcu, struct ctl_table_header, rcu));
-}
-
 void sysctl_head_put(struct ctl_table_header *head)
 {
 	spin_lock(&sysctl_lock);
 	if (!--head->count)
-		call_rcu(&head->rcu, free_head);
+		kfree_rcu(head, rcu);
 	spin_unlock(&sysctl_lock);
 }
 
@@ -1971,10 +1966,10 @@ void unregister_sysctl_table(struct ctl_table_header * header)
 	start_unregistering(header);
 	if (!--header->parent->count) {
 		WARN_ON(1);
-		call_rcu(&header->parent->rcu, free_head);
+		kfree_rcu(header->parent, rcu);
 	}
 	if (!--header->count)
-		call_rcu(&header->rcu, free_head);
+		kfree_rcu(header, rcu);
 	spin_unlock(&sysctl_lock);
 }
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1d34d75..ab8494c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -452,13 +452,6 @@ overflow:
 	return ERR_PTR(-EBUSY);
 }
 
-static void rcu_free_va(struct rcu_head *head)
-{
-	struct vmap_area *va = container_of(head, struct vmap_area, rcu_head);
-
-	kfree(va);
-}
-
 static void __free_vmap_area(struct vmap_area *va)
 {
 	BUG_ON(RB_EMPTY_NODE(&va->rb_node));
@@ -491,7 +484,7 @@ static void __free_vmap_area(struct vmap_area *va)
 	if (va->va_end > VMALLOC_START && va->va_end <= VMALLOC_END)
 		vmap_area_pcpu_hole = max(vmap_area_pcpu_hole, va->va_end);
 
-	call_rcu(&va->rcu_head, rcu_free_va);
+	kfree_rcu(va, rcu_head);
 }
 
 /*
@@ -837,13 +830,6 @@ static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
 	return vb;
 }
 
-static void rcu_free_vb(struct rcu_head *head)
-{
-	struct vmap_block *vb = container_of(head, struct vmap_block, rcu_head);
-
-	kfree(vb);
-}
-
 static void free_vmap_block(struct vmap_block *vb)
 {
 	struct vmap_block *tmp;
@@ -856,7 +842,7 @@ static void free_vmap_block(struct vmap_block *vb)
 	BUG_ON(tmp != vb);
 
 	free_vmap_area_noflush(vb->va);
-	call_rcu(&vb->rcu_head, rcu_free_vb);
+	kfree_rcu(vb, rcu_head);
 }
 
 static void purge_fragmented_blocks(int cpu)
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index de079abd..f264032 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -60,11 +60,6 @@ struct xt_rateest *xt_rateest_lookup(const char *name)
 }
 EXPORT_SYMBOL_GPL(xt_rateest_lookup);
 
-static void xt_rateest_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct xt_rateest, rcu));
-}
-
 void xt_rateest_put(struct xt_rateest *est)
 {
 	mutex_lock(&xt_rateest_mutex);
@@ -75,7 +70,7 @@ void xt_rateest_put(struct xt_rateest *est)
 		 * gen_estimator est_timer() might access est->lock or bstats,
 		 * wait a RCU grace period before freeing 'est'
 		 */
-		call_rcu(&est->rcu, xt_rateest_free_rcu);
+		kfree_rcu(est, rcu);
 	}
 	mutex_unlock(&xt_rateest_mutex);
 }
@@ -188,7 +183,6 @@ static int __init xt_rateest_tg_init(void)
 static void __exit xt_rateest_tg_fini(void)
 {
 	xt_unregister_target(&xt_rateest_tg_reg);
-	rcu_barrier(); /* Wait for completion of call_rcu()'s (xt_rateest_free_rcu) */
 }
 
 
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 3618251..8b691a8 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -69,22 +69,6 @@ static DEFINE_SPINLOCK(sel_netnode_lock);
 static struct sel_netnode_bkt sel_netnode_hash[SEL_NETNODE_HASH_SIZE];
 
 /**
- * sel_netnode_free - Frees a node entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table node entry can be
- * released safely.
- *
- */
-static void sel_netnode_free(struct rcu_head *p)
-{
-	struct sel_netnode *node = container_of(p, struct sel_netnode, rcu);
-	kfree(node);
-}
-
-/**
  * sel_netnode_hashfn_ipv4 - IPv4 hashing function for the node table
  * @addr: IPv4 address
  *
@@ -193,7 +177,7 @@ static void sel_netnode_insert(struct sel_netnode *node)
 			rcu_dereference(sel_netnode_hash[idx].list.prev),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netnode_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netnode_hash[idx].size++;
 }
@@ -306,7 +290,7 @@ static void sel_netnode_flush(void)
 		list_for_each_entry_safe(node, node_tmp,
 					 &sel_netnode_hash[idx].list, list) {
 				list_del_rcu(&node->list);
-				call_rcu(&node->rcu, sel_netnode_free);
+				kfree_rcu(node, rcu);
 		}
 		sel_netnode_hash[idx].size = 0;
 	}
diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index cfe2d72..ae76e29 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -68,22 +68,6 @@ static DEFINE_SPINLOCK(sel_netport_lock);
 static struct sel_netport_bkt sel_netport_hash[SEL_NETPORT_HASH_SIZE];
 
 /**
- * sel_netport_free - Frees a port entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table port entry can be
- * released safely.
- *
- */
-static void sel_netport_free(struct rcu_head *p)
-{
-	struct sel_netport *port = container_of(p, struct sel_netport, rcu);
-	kfree(port);
-}
-
-/**
  * sel_netport_hashfn - Hashing function for the port table
  * @pnum: port number
  *
@@ -142,7 +126,7 @@ static void sel_netport_insert(struct sel_netport *port)
 			rcu_dereference(sel_netport_hash[idx].list.prev),
 			struct sel_netport, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netport_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netport_hash[idx].size++;
 }
@@ -241,7 +225,7 @@ static void sel_netport_flush(void)
 		list_for_each_entry_safe(port, port_tmp,
 					 &sel_netport_hash[idx].list, list) {
 			list_del_rcu(&port->list);
-			call_rcu(&port->rcu, sel_netport_free);
+			kfree_rcu(port, rcu);
 		}
 		sel_netport_hash[idx].size = 0;
 	}
