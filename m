Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936176Ab2KAXHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:07:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36064 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762441Ab2KAXHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:07:02 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, mingo@kernel.org,
        hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        peter.senna@gmail.com, Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC] hlist: drop the node parameter from iterators
Date: Thu,  1 Nov 2012 19:06:07 -0400
Message-Id: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.7.12.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure why, but the hlist for each entry iterators were conceived
differently from the list ones. While the list ones are nice and elegant:

	list_for_each_entry(pos, head, member)

The hlist ones were greedy and wanted an extra parameter:

	hlist_for_each_entry(tpos, pos, head, member)

Why did they need an extra pos parameter? I'm not quite sure. Not only
they don't really need it, it also prevents the iterator from looking
exactly like the list iterator, which is unfortunate.

This is a RFC patch which fixes thisi annoyance and makes the hlist iterator
nice and pretty. This patch also violates rule 1 of kernel fight club: it
will break the build horribly...

I've avoided sending the other part of this patch which actually fixes
all callsites all over the kernel to prevent unneeded spam (will obviously
send it when everybody are happy with the code here). The good news
are that with a lot of help from Peter Senna Tschudin, we can make the
transform automagically using Coccinelle and a rather short semantic patch.

The semantic patch is here:

@r1@
iterator name hlist_for_each_entry;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry(a, b, c, d) S
  ...+>

@r2@
expression a,c,d;
identifier b;
statement S;
@@
hlist_for_each_entry(a,
- b,
c, d) S

@r3@
iterator name hlist_for_each_entry_safe;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry_safe(a, b, c, d) S
  ...+>

@r4@
expression a,c,d;
identifier b;
statement S;
@@
hlist_for_each_entry_safe(a,
- b,
c, d) S

@r5@
iterator name hlist_for_each_entry_continue;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry_continue(a, b, c) S
  ...+>

@r6@
expression a,c;
identifier b;
statement S;
@@
hlist_for_each_entry_continue(a,
- b,
c) S

@r7@
iterator name hlist_for_each_entry_from;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry_from(a, b, c) S
  ...+>

@r8@
expression a,c;
identifier b;
statement S;
@@
hlist_for_each_entry_from(a,
- b,
c) S

@r9@
iterator name hlist_for_each_entry_rcu;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry_rcu(a, b, c, d) S
  ...+>

@r10@
expression a,c,d;
identifier b;
statement S;
@@
hlist_for_each_entry_rcu(a,
- b,
c, d) S

@r11@
iterator name hlist_for_each_entry_rcu_bh;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry_rcu_bh(a, b, c, d) S
  ...+>

@r12@
expression a,c,d;
identifier b;
statement S;
@@
hlist_for_each_entry_rcu_bh(a,
- b,
c, d) S

@r13@
iterator name hlist_for_each_entry_continue_rcu;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry_continue_rcu(a, b, c) S
  ...+>

@r14@
expression a,c;
identifier b;
statement S;
@@
hlist_for_each_entry_continue_rcu(a,
- b,
c) S

@r15@
iterator name hlist_for_each_entry_continue_rcu_bh;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
hlist_for_each_entry_continue_rcu_bh(a, b, c) S
  ...+>

@r16@
expression a,c;
identifier b;
statement S;
@@
hlist_for_each_entry_continue_rcu_bh(a,
- b,
c) S

@r17@
iterator name for_each_busy_worker;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
for_each_busy_worker(a, c, b, d) S
  ...+>

@r18@
expression a,c,d;
identifier b;
statement S;
@@
for_each_busy_worker(a, c,
- b,
d) S

@r19@
iterator name ax25_uid_for_each;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
ax25_uid_for_each(a, b, c) S
  ...+>

@r20@
expression a,c;
identifier b;
statement S;
@@
ax25_uid_for_each(a,
- b,
c) S

@r21@
iterator name ax25_for_each;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
ax25_for_each(a, b, c) S
  ...+>

@r22@
expression a,c;
identifier b;
statement S;
@@
ax25_for_each(a,
- b,
c) S

@r23@
iterator name inet_bind_bucket_for_each;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
inet_bind_bucket_for_each(a, b, c) S
  ...+>

@r24@
expression a,c;
identifier b;
statement S;
@@
inet_bind_bucket_for_each(a,
- b,
c) S

@r25@
iterator name nr_neigh_for_each;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
nr_neigh_for_each(a, b, c) S
  ...+>

@r26@
expression a,c;
identifier b;
statement S;
@@
nr_neigh_for_each(a,
- b,
c) S

@r27@
iterator name nr_neigh_for_each_safe;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
nr_neigh_for_each_safe(a, b, c, d) S
  ...+>

@r28@
expression a,c,d;
identifier b;
statement S;
@@
nr_neigh_for_each_safe(a,
- b,
c, d) S

@r29@
iterator name nr_node_for_each;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
nr_node_for_each(a, b, c) S
  ...+>

@r30@
expression a,c;
identifier b;
statement S;
@@
nr_node_for_each(a,
- b,
c) S

@r31@
iterator name nr_node_for_each_safe;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
nr_node_for_each_safe(a, b, c, d) S
  ...+>

@r32@
expression a,c,d;
identifier b;
statement S;
@@
nr_node_for_each_safe(a,
- b,
c, d) S

@r33@
iterator name sctp_for_each_hentry;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
sctp_for_each_hentry(a, b, c) S
  ...+>

@r34@
expression a,c;
identifier b;
statement S;
@@
sctp_for_each_hentry(a,
- b,
c) S

@r35@
iterator name sk_for_each;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
sk_for_each(a, b, c) S
  ...+>

@r36@
expression a,c;
identifier b;
statement S;
@@
sk_for_each(a,
- b,
c) S

@r37@
iterator name sk_for_each_rcu;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
sk_for_each_rcu(a, b, c) S
  ...+>

@r38@
expression a,c;
identifier b;
statement S;
@@
sk_for_each_rcu(a,
- b,
c) S

@r39@
iterator name sk_for_each_from;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
sk_for_each_from(a, b) S
  ...+>

@r40@
expression a;
identifier b;
statement S;
@@
- sk_for_each_from(a, b) S
+ sk_for_each_from(a) S

@r41@
iterator name sk_for_each_safe;
type T;
expression a,c,d;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
sk_for_each_safe(a, b, c, d) S
  ...+>

@r42@
expression a,c,d;
identifier b;
statement S;
@@
sk_for_each_safe(a,
- b,
c, d) S

@r43@
iterator name sk_for_each_bound;
type T;
expression a,c;
identifier b,e;
statement S;
@@
-T b;
  <+... when != b
sk_for_each_bound(a, b, c) S
  ...+>

@r44@
expression a,c;
identifier b;
statement S;
@@
sk_for_each_bound(a,
- b,
c) S

And the result is that it touches almost every subsystem in the kernel:

 arch/powerpc/kvm/book3s_mmu_hpte.c                  |   18 ++++++------------
 arch/sparc/kernel/ldc.c                             |    3 +--
 block/blk-cgroup.c                                  |    6 ++----
 block/blk-ioc.c                                     |    3 +--
 block/bsg.c                                         |    3 +--
 block/cfq-iosched.c                                 |    3 +--
 crypto/algapi.c                                     |    2 +-
 drivers/atm/atmtcp.c                                |    6 ++----
 drivers/atm/eni.c                                   |    3 +--
 drivers/atm/he.c                                    |    3 +--
 drivers/atm/solos-pci.c                             |    8 +++-----
 drivers/block/drbd/drbd_receiver.c                  |    6 ++----
 drivers/block/drbd/drbd_req.c                       |    5 ++---
 drivers/clk/clk.c                                   |   39 ++++++++++++++-------------------------
 drivers/infiniband/core/cma.c                       |    3 +--
 drivers/infiniband/core/fmr_pool.c                  |    3 +--
 drivers/isdn/mISDN/socket.c                         |    3 +--
 drivers/isdn/mISDN/stack.c                          |    3 +--
 drivers/md/dm-bio-prison.c                          |    3 +--
 drivers/md/dm-bufio.c                               |    3 +--
 drivers/md/dm-snap.c                                |    3 +--
 drivers/md/persistent-data/dm-transaction-manager.c |    3 +--
 drivers/md/raid5.c                                  |    3 +--
 drivers/misc/sgi-gru/grutlbpurge.c                  |    3 +--
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c      |    3 +--
 drivers/net/ethernet/sun/sunvnet.c                  |    3 +--
 drivers/net/macvlan.c                               |    6 ++----
 drivers/net/vxlan.c                                 |   11 ++++-------
 drivers/net/wireless/zd1201.c                       |    3 +--
 drivers/pci/pci.c                                   |    8 +++-----
 drivers/staging/android/binder.c                    |   19 +++++++------------
 drivers/target/tcm_fc/tfc_sess.c                    |   12 ++++--------
 fs/affs/amigaffs.c                                  |    3 +--
 fs/aio.c                                            |    3 +--
 fs/cifs/inode.c                                     |    3 +--
 fs/dcache.c                                         |    9 +++------
 fs/dlm/lowcomms.c                                   |    6 ++----
 fs/ecryptfs/messaging.c                             |    6 ++----
 fs/exportfs/expfs.c                                 |    3 +--
 fs/fat/inode.c                                      |    3 +--
 fs/fat/nfs.c                                        |    3 +--
 fs/fscache/cookie.c                                 |   11 ++++-------
 fs/inode.c                                          |   13 +++++--------
 fs/lockd/host.c                                     |    6 ++----
 fs/lockd/svcsubs.c                                  |    3 +--
 fs/nfs/pnfs_dev.c                                   |    9 +++------
 fs/nfsd/nfscache.c                                  |    3 +--
 fs/notify/fsnotify.c                                |    3 +--
 fs/notify/inode_mark.c                              |    8 +++-----
 fs/notify/vfsmount_mark.c                           |    8 +++-----
 fs/ocfs2/dcache.c                                   |    3 +--
 fs/ocfs2/dlm/dlmrecovery.c                          |    6 ++----
 fs/super.c                                          |    6 ++----
 fs/sysfs/bin.c                                      |    3 +--
 fs/xfs/xfs_log_recover.c                            |    3 +--
 kernel/cgroup.c                                     |    5 ++---
 kernel/events/core.c                                |    6 ++----
 kernel/kprobes.c                                    |   21 +++++++--------------
 kernel/pid.c                                        |    3 +--
 kernel/sched/core.c                                 |    6 ++----
 kernel/trace/ftrace.c                               |   12 ++++--------
 kernel/trace/trace_output.c                         |    3 +--
 kernel/tracepoint.c                                 |    6 ++----
 kernel/user.c                                       |    4 ++--
 kernel/workqueue.c                                  |   11 ++++-------
 lib/debugobjects.c                                  |    5 ++---
 lib/lru_cache.c                                     |    3 +--
 mm/huge_memory.c                                    |    3 +--
 mm/kmemleak.c                                       |    3 +--
 mm/ksm.c                                            |   15 +++++----------
 mm/mmu_notifier.c                                   |   21 +++++++--------------
 net/9p/error.c                                      |    2 +-
 net/appletalk/ddp.c                                 |    8 +++-----
 net/atm/common.c                                    |    5 ++---
 net/atm/lec.c                                       |   28 +++++++++++-----------------
 net/atm/signaling.c                                 |    3 +--
 net/ax25/af_ax25.c                                  |   15 +++++----------
 net/ax25/ax25_ds_subr.c                             |    3 +--
 net/ax25/ax25_ds_timer.c                            |    3 +--
 net/ax25/ax25_iface.c                               |    3 +--
 net/ax25/ax25_uid.c                                 |   11 ++++-------
 net/batman-adv/bat_iv_ogm.c                         |   12 ++++--------
 net/batman-adv/bridge_loop_avoidance.c              |   27 +++++++++------------------
 net/batman-adv/gateway_client.c                     |    9 +++------
 net/batman-adv/main.c                               |    6 ++----
 net/batman-adv/routing.c                            |    6 ++----
 net/batman-adv/translation-table.c                  |   36 ++++++++++++------------------------
 net/batman-adv/vis.c                                |   25 +++++++++----------------
 net/bluetooth/hci_sock.c                            |   15 +++++----------
 net/bluetooth/rfcomm/sock.c                         |    7 +++----
 net/bluetooth/sco.c                                 |   11 ++++-------
 net/bridge/br_fdb.c                                 |   14 +++++---------
 net/bridge/br_multicast.c                           |   13 +++++--------
 net/can/af_can.c                                    |   15 +++++++--------
 net/can/gw.c                                        |    3 +--
 net/can/proc.c                                      |    3 +--
 net/core/dev.c                                      |   15 +++++----------
 net/core/flow.c                                     |    3 +--
 net/core/rtnetlink.c                                |    3 +--
 net/decnet/af_decnet.c                              |    9 +++------
 net/decnet/dn_table.c                               |    9 +++------
 net/ieee802154/dgram.c                              |    3 +--
 net/ieee802154/raw.c                                |    3 +--
 net/ipv4/devinet.c                                  |    6 ++----
 net/ipv4/fib_frontend.c                             |    9 +++------
 net/ipv4/fib_semantics.c                            |   15 +++++----------
 net/ipv4/fib_trie.c                                 |   24 +++++++++---------------
 net/ipv4/inet_connection_sock.c                     |    7 +++----
 net/ipv4/inet_fragment.c                            |    6 ++----
 net/ipv4/inet_hashtables.c                          |    5 ++---
 net/ipv4/raw.c                                      |   19 +++++++------------
 net/ipv4/tcp_ipv4.c                                 |    3 +--
 net/ipv6/addrconf.c                                 |   29 +++++++++++------------------
 net/ipv6/addrlabel.c                                |    6 ++----
 net/ipv6/inet6_connection_sock.c                    |    2 +-
 net/ipv6/ip6_fib.c                                  |   12 ++++--------
 net/ipv6/raw.c                                      |   15 ++++-----------
 net/ipv6/xfrm6_tunnel.c                             |    6 ++----
 net/ipx/ipx_proc.c                                  |    2 +-
 net/iucv/af_iucv.c                                  |   21 +++++++--------------
 net/key/af_key.c                                    |    3 +--
 net/l2tp/l2tp_core.c                                |   12 ++++--------
 net/l2tp/l2tp_ip.c                                  |    3 +--
 net/l2tp/l2tp_ip6.c                                 |    3 +--
 net/llc/llc_sap.c                                   |    3 +--
 net/mac80211/mesh_pathtbl.c                         |   20 +++++++-------------
 net/netfilter/ipvs/ip_vs_conn.c                     |   18 +++++++-----------
 net/netfilter/nf_conntrack_expect.c                 |    9 +++------
 net/netfilter/nf_conntrack_helper.c                 |    9 +++------
 net/netfilter/nf_conntrack_netlink.c                |    3 +--
 net/netfilter/nf_nat_core.c                         |    3 +--
 net/netfilter/nfnetlink_cthelper.c                  |    9 +++------
 net/netfilter/nfnetlink_log.c                       |    3 +--
 net/netfilter/nfnetlink_queue_core.c                |    5 ++---
 net/netfilter/xt_RATEEST.c                          |    3 +--
 net/netfilter/xt_hashlimit.c                        |    9 +++------
 net/netlink/af_netlink.c                            |   25 +++++++++----------------
 net/netrom/af_netrom.c                              |   12 ++++--------
 net/openvswitch/datapath.c                          |    5 ++---
 net/openvswitch/flow.c                              |    8 +++-----
 net/openvswitch/vport.c                             |    3 +--
 net/packet/af_packet.c                              |    3 +--
 net/packet/diag.c                                   |    3 +--
 net/phonet/pep.c                                    |    3 +--
 net/phonet/socket.c                                 |    8 +++-----
 net/rds/bind.c                                      |    3 +--
 net/rds/connection.c                                |    9 +++------
 net/rose/af_rose.c                                  |   14 +++++---------
 net/sched/sch_cbq.c                                 |   13 +++++--------
 net/sched/sch_drr.c                                 |    6 ++----
 net/sched/sch_hfsc.c                                |   11 ++++-------
 net/sched/sch_htb.c                                 |    8 +++-----
 net/sched/sch_qfq.c                                 |    7 +++----
 net/sctp/endpointola.c                              |    3 +--
 net/sctp/input.c                                    |    6 ++----
 net/sctp/proc.c                                     |    9 +++------
 net/sctp/socket.c                                   |    7 +++----
 net/sunrpc/auth.c                                   |    5 ++---
 net/sunrpc/svcauth.c                                |    3 +--
 net/tipc/name_table.c                               |    8 +++-----
 net/tipc/node.c                                     |    3 +--
 net/unix/af_unix.c                                  |    6 ++----
 net/unix/diag.c                                     |    4 ++--
 net/x25/af_x25.c                                    |   12 ++++--------
 net/xfrm/xfrm_state.c                               |   31 ++++++++++++-------------------
 security/integrity/ima/ima_queue.c                  |    3 +--
 security/selinux/avc.c                              |   17 ++++++-----------
 tools/perf/util/evlist.c                            |    3 +--
 virt/kvm/eventfd.c                                  |    3 +--
 virt/kvm/irq_comm.c                                 |   12 ++++--------
 170 files changed, 481 insertions(+), 879 deletions(-)

Yes, beyond making hlist prettier, we also drop 400 lines. win-win?

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/list.h    | 46 +++++++++++++++++-----------------------
 include/linux/rculist.h | 56 ++++++++++++++++++++++++-------------------------
 2 files changed, 47 insertions(+), 55 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index cc6d2aa..223e1dd 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -668,52 +668,44 @@ static inline void hlist_move_list(struct hlist_head *old,
 
 /**
  * hlist_for_each_entry	- iterate over list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry(tpos, pos, head, member)			 \
-	for (pos = (head)->first;					 \
-	     pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+#define hlist_for_each_entry(pos, head, member)					\
+	for (pos = hlist_entry((head)->first, typeof(*(pos)), member);		\
+	     &((pos)->member);							\
+	     pos = hlist_entry((pos)->member.next, typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_continue - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue(tpos, pos, member)		 \
-	for (pos = (pos)->next;						 \
-	     pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+#define hlist_for_each_entry_continue(tpos, pos, member)			\
+	for (pos = hlist_entry((pos)->member.next, typeof(*(pos)), member);	\
+	     &((pos)->member);							\
+	     pos = hlist_entry((pos)->member.next, typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_from - iterate over a hlist continuing from current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+#define hlist_for_each_entry_from(tpos, pos, member)				\
+	for (; &((pos)->member);						\
+	     pos = hlist_entry((pos)->member.next, typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @n:		another &struct hlist_node to use as temporary storage
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
-	for (pos = (head)->first;					 \
-	     pos && ({ n = pos->next; 1; }) && 				 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = n)
+#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 			\
+	for (pos = hlist_entry((head)->first, typeof(*pos), member);		\
+	     &((pos)->member && ({ n = pos->member.next; 1; });			\
+	     pos = hlist_entry(n, typeof(*pos), member))
 
 #endif
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index c92dd28..9c39f99 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -445,8 +445,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 
 /**
  * hlist_for_each_entry_rcu - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  *
@@ -454,16 +453,16 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		\
-	for (pos = rcu_dereference_raw(hlist_first_rcu(head));		\
-		pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(hlist_next_rcu(pos)))
+#define hlist_for_each_entry_rcu(pos, head, member)				\
+	for (pos = hlist_entry(rcu_dereference_raw(hlist_first_rcu(head)),	\
+			typeof(*(pos)), member);				\
+		&((pos)->member);						\
+		pos = hlist_entry(rcu_dereference_raw(hlist_next_rcu(		\
+			&(pos)->member)), typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_rcu_bh - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  *
@@ -471,35 +470,36 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu_bh(tpos, pos, head, member)		 \
-	for (pos = rcu_dereference_bh((head)->first);			 \
-		pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_bh(pos->next))
+#define hlist_for_each_entry_rcu_bh(pos, head, member)				\
+	for (pos = hlist_entry(rcu_dereference_bh(hlist_first_rcu(head)),	\
+			typeof(*(pos)), member);				\
+		&((pos)->member);						\
+		pos = hlist_entry(rcu_dereference_bh(hlist_next_rcu(		\
+			&(pos)->member)), typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_continue_rcu - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
-	for (pos = rcu_dereference((pos)->next);			\
-	     pos &&							\
-	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
-	     pos = rcu_dereference(pos->next))
+#define hlist_for_each_entry_continue_rcu(pos, member)				\
+	for (pos = hlist_entry(rcu_dereference((pos)->member.next),		\
+			typeof(*(pos)), member);				\
+	     &((pos)->member);							\
+	     pos = hlist_entry(rcu_dereference((pos)->member.next),		\
+	     		typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_continue_rcu_bh - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue_rcu_bh(tpos, pos, member)		\
-	for (pos = rcu_dereference_bh((pos)->next);			\
-	     pos &&							\
-	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
-	     pos = rcu_dereference_bh(pos->next))
+#define hlist_for_each_entry_continue_rcu_bh(pos, member)			\
+	for (pos = hlist_entry(rcu_dereference_bh((pos)->member.next),		\
+			typeof(*(pos)), member);				\
+	     &((pos)->member);							\
+	     pos = hlist_entry(rcu_dereference_bh((pos)->member.next),		\
+	     		typeof(*(pos)), member))
 
 
 #endif	/* __KERNEL__ */
-- 
1.7.12.4

