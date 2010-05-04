Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab0EDUTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:19:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35051 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab0EDUTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:19:39 -0400
Date: Tue, 4 May 2010 13:19:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/48] v4 patches queued for 2.6.35
Message-ID: <20100504201934.GA19234@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

RFC preview of RCU patches queued for 2.6.35, take 4.
Take 3 is at http://lkml.org/lkml/2010/4/20/321.
New patches flagged with "New".

 1.	New: optionally leave lockdep enabled after RCU lockdep splat
	This patch, based on one from Lai Jiangshan, allows multiple
	RCU-lockdep splats per boot.  This was proposed for 2.6.34,
	but it does not qualify as a regression, so it is now at the
	head of the 2.6.35 queue.

 2.	substitute set_need_resched for sending resched IPIs
 	This reduces OS jitter.

 3.	make dead code really dead.
 4.	move some code from macro to function
 	Cleanups from Lai Jiangshan.

 5.	ignore offline CPUs in last non dyntick idle CPU check
 	Fix to my CONFIG_RCU_FAST_NO_HZ code to handle offline and
	non-existent CPUs, also from Lai Jiangshan.

 6.	fix bogus CONFIG_PROVE_LOCKING in comments to reality
 7.	fix now bogus rcu_scheduler_active comments
 	Comment fixups.

 8.	shrink rcutiny by making synchronize_rcu_bh be inline
 	Shrink TINY_RCU some more.

 9.	rename rcutiny rcu_ctrlblk to rcu_sched_ctrlblk
 	First step towards TINY_PREEMPTIBLE_RCU.

10.	refactor RCU's context switch handling
 	Reduce the number of needless softirqs.

11.	slim down rcutiny by removing rcu_scheduler_active and friends
	More shrinkage for TINY_RCU

12.	enable CPU_STALL_VERBOSE by default.  It will have been in one
	release, so time to enable it.

13.	disable CPU stall warnings upon panic

14.	print boot-time console messages if RCU configs out of ordinary

15.	improve RCU CPU stall-warning messages

16.	permit discontiguous cpu_possible_mask CPU numbering

17.	v2: reduce the number of spurious RCU_SOFTIRQ invocations
	[Original from Lai Jiangshan]

18.	improve the RCU CPU-stall-warning documentation

19.	debugobjects transition check
20.	introduce rcu_head_init_on_stack
21.	remove all non-on-stack rcu_head initializations
22.	remove rcu_head initializers
23.	Add debug RCU head objects
	Debug-objects-based rcu_head checking from Mathieu Desnoyers

24.	make SRCU usable in modules
	[From Lai Jiangshan]

25.	New: fix debugobjects rcu head init on stack in rcutree_plugin.h
	Fix from Mathieu for the earlier debugobjects series

26.	New: RCU_FAST_NO_HZ must check RCU dyntick state
	Fix for the classic Classic RCU bug introduced via the
	RCU_FAST_NO_HZ patch.  :-/

27.	New: add fs.h to define struct file
28.	New: Make accesses to ->br_port safe for sparse RCU
29.	New: add an rcu_dereference_index_check()
30.	New: mce: convert to rcu_dereference_index_check()
31.	New: define __rcu address space modifier for sparse
32.	New: rculist: avoid __rcu annotations
33.	New: cgroups: __rcu annotations
34.	New: credentials: rcu annotation
35.	New: keys: __rcu annotations
36.	New: nfs: __rcu annotations
37.	New: net: __rcu annotations for drivers
38.	New: perf_event: __rcu annotations
39.	New: notifiers: __rcu annotations
40.	New: radix-tree: __rcu annotations
41.	New: idr: __rcu annotations
42.	New: input: __rcu annotations
43.	New: vhost: add __rcu annotations
44.	New: net/netfilter: __rcu annotations
45.	New: kvm: add __rcu annotations
46.	New: kernel: __rcu annotations
47.	New: net: __rcu annotations
48.	New: kvm: more __rcu annotations
	Sparse-based RCU checking from Arnd Bergmann.  These changes
	allow sparse to generate complaints if RCU-protected pointers
	are accessed directly rather than via the appropriate RCU
	primitive.  This is a debugging tool rather than a code-quality
	enforcement mechanism, although Arnd does have some additional
	patches should someone wish to use this as a code-quality
	enforcement mechanism for their code.

							Thanx, Paul

 b/Documentation/RCU/stallwarn.txt             |   94 +++--
 b/Documentation/RCU/trace.txt                 |   35 +
 b/arch/powerpc/mm/pgtable.c                   |    1 
 b/arch/x86/include/asm/kvm_host.h             |    2 
 b/arch/x86/kernel/cpu/mcheck/mce.c            |    2 
 b/block/cfq-iosched.c                         |    1 
 b/block/genhd.c                               |    1 
 b/drivers/input/evdev.c                       |    2 
 b/drivers/net/bnx2.h                          |    2 
 b/drivers/net/bnx2x.h                         |    2 
 b/drivers/net/cnic.h                          |    2 
 b/drivers/net/macvtap.c                       |    2 
 b/drivers/staging/batman-adv/hard-interface.c |    1 
 b/drivers/vhost/net.c                         |    6 
 b/drivers/vhost/vhost.c                       |   12 
 b/drivers/vhost/vhost.h                       |    4 
 b/fs/file.c                                   |    3 
 b/fs/fs-writeback.c                           |   31 +
 b/fs/nfs/delegation.h                         |    2 
 b/fs/partitions/check.c                       |    1 
 b/include/linux/cgroup.h                      |    4 
 b/include/linux/compiler.h                    |    6 
 b/include/linux/cred.h                        |    2 
 b/include/linux/debugobjects.h                |   11 
 b/include/linux/fdtable.h                     |    1 
 b/include/linux/fs.h                          |    2 
 b/include/linux/genhd.h                       |    6 
 b/include/linux/idr.h                         |    4 
 b/include/linux/if_bridge.h                   |    1 
 b/include/linux/if_macvlan.h                  |    2 
 b/include/linux/igmp.h                        |    4 
 b/include/linux/init_task.h                   |    1 
 b/include/linux/input.h                       |    2 
 b/include/linux/iocontext.h                   |    2 
 b/include/linux/key.h                         |    3 
 b/include/linux/kvm_host.h                    |    2 
 b/include/linux/mm_types.h                    |    2 
 b/include/linux/netdevice.h                   |   12 
 b/include/linux/nfs_fs.h                      |    2 
 b/include/linux/notifier.h                    |   10 
 b/include/linux/perf_event.h                  |    6 
 b/include/linux/radix-tree.h                  |    4 
 b/include/linux/rculist.h                     |   52 +-
 b/include/linux/rculist_nulls.h               |   16 
 b/include/linux/rcupdate.h                    |    6 
 b/include/linux/rcutiny.h                     |   12 
 b/include/linux/rcutree.h                     |    2 
 b/include/linux/sched.h                       |    2 
 b/include/linux/srcu.h                        |    4 
 b/include/linux/sunrpc/auth_gss.h             |    4 
 b/include/net/dst.h                           |    2 
 b/include/net/fib_rules.h                     |    2 
 b/include/net/garp.h                          |    2 
 b/include/net/inet_sock.h                     |    2 
 b/include/net/ip6_tunnel.h                    |    2 
 b/include/net/ipip.h                          |    6 
 b/include/net/net_namespace.h                 |    2 
 b/include/net/netfilter/nf_conntrack.h        |    2 
 b/include/net/netns/xfrm.h                    |    2 
 b/include/net/sock.h                          |    4 
 b/kernel/cgroup.c                             |    2 
 b/kernel/lockdep.c                            |    2 
 b/kernel/pid.c                                |    2 
 b/kernel/rcupdate.c                           |   19 -
 b/kernel/rcutiny.c                            |    9 
 b/kernel/rcutiny_plugin.h                     |   39 ++
 b/kernel/rcutorture.c                         |    2 
 b/kernel/rcutree.c                            |   10 
 b/kernel/rcutree.h                            |    1 
 b/kernel/rcutree_plugin.h                     |    2 
 b/kernel/rcutree_trace.c                      |    4 
 b/kernel/sched.c                              |    2 
 b/kernel/softirq.c                            |    2 
 b/lib/Kconfig.debug                           |   12 
 b/lib/debugobjects.c                          |   59 +++
 b/lib/radix-tree.c                            |    2 
 b/mm/backing-dev.c                            |    1 
 b/mm/slob.c                                   |    1 
 b/net/802/stp.c                               |    4 
 b/net/bridge/br_fdb.c                         |    2 
 b/net/bridge/br_private.h                     |    8 
 b/net/bridge/netfilter/ebt_redirect.c         |    2 
 b/net/bridge/netfilter/ebt_ulog.c             |    4 
 b/net/bridge/netfilter/ebtables.c             |    4 
 b/net/ipv4/ip_gre.c                           |    2 
 b/net/ipv4/ipip.c                             |   10 
 b/net/ipv4/netfilter/nf_nat_core.c            |    2 
 b/net/ipv4/protocol.c                         |    2 
 b/net/ipv4/route.c                            |    2 
 b/net/ipv4/tcp.c                              |    4 
 b/net/ipv6/ip6_tunnel.c                       |    6 
 b/net/ipv6/protocol.c                         |    2 
 b/net/ipv6/sit.c                              |   10 
 b/net/mac80211/ieee80211_i.h                  |   15 
 b/net/mac80211/sta_info.h                     |    4 
 b/net/netfilter/core.c                        |    2 
 b/net/netfilter/nf_conntrack_ecache.c         |    4 
 b/net/netfilter/nf_conntrack_expect.c         |   12 
 b/net/netfilter/nf_conntrack_extend.c         |    2 
 b/net/netfilter/nf_conntrack_proto.c          |    4 
 b/net/netfilter/nf_log.c                      |    2 
 b/net/netfilter/nf_queue.c                    |    2 
 b/net/netfilter/nfnetlink_log.c               |    4 
 b/net/netfilter/nfnetlink_queue.c             |    4 
 b/net/netlabel/netlabel_domainhash.c          |    4 
 b/net/netlabel/netlabel_unlabeled.c           |    4 
 b/net/netlink/af_netlink.c                    |    2 
 b/net/phonet/af_phonet.c                      |    2 
 b/net/phonet/pn_dev.c                         |    2 
 b/net/socket.c                                |    2 
 b/security/selinux/avc.c                      |    1 
 b/security/selinux/netnode.c                  |    2 
 include/linux/fdtable.h                       |    6 
 include/linux/init_task.h                     |    4 
 include/linux/kvm_host.h                      |    4 
 include/linux/rcupdate.h                      |  477 +++++++++++++++++---------
 include/linux/rcutiny.h                       |   17 
 include/linux/rcutree.h                       |    4 
 include/linux/sched.h                         |    6 
 include/linux/srcu.h                          |   29 +
 kernel/rcupdate.c                             |  155 ++++++++
 kernel/rcutiny.c                              |   28 +
 kernel/rcutree.c                              |  127 ++++--
 kernel/rcutree.h                              |    1 
 kernel/rcutree_plugin.h                       |   69 +++
 kernel/sched.c                                |    2 
 lib/Kconfig.debug                             |   21 +
 127 files changed, 1193 insertions(+), 485 deletions(-)
