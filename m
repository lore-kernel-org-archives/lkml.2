Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0GNUJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:09:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41787 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0GNUJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:09:50 -0400
Date: Wed, 14 Jul 2010 13:09:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH RFC tip/core/rcu 0/30] RCU commits queued for 2.6.36/7
Message-ID: <20100714200945.GA10535@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset shows the patches queued for 2.6.36/7.  These are not
yet ready to move upstream due to dependencies on commits moving up other
trees.  The patches are as follows:

1-19.	These are the remaining patches implementing Arnd's sparse-checking
	work.  #1 needs to go up the networking tree, but
	will cause regressions until f5155b33277 ("rcu: add an
	rcu_dereference_index_check()") reaches mainline.  #2 depends
	on #1, and many of the later patches (#3-#30) depend on #2.
	Many of #3-#19 will go up non-tip trees.
20.	Update Documentation/RCU to remove the now-deprecated rcu_head
	initialization macros.
21.	Fix long-standing DocBook example showing long-dead three-argument
	variant of call_rcu().
22.	Make the CPU stall warning timeout configurable at build time
	with new RCU_CPU_STALL_TIMEOUT config parameter.
23.	Remove the now-deprecated rcu_head initialization macros.
	This depends on a couple of patches removing their use that
	are making their way up other maintainer trees.
24.	Document the new debug assists from Arnd, Mathieu, and myself.
25.	Add random preemption to rcutorture testing of preemptible
	RCU, courtesy of Lai Jiangshan.
26.	Remove TREE_RCU's ->rda[] array in favor of the new __percpu
	facility, also courtesy of Lai Jiangshan.
27.	Fixlet to #26 for RCU tracing.
28.	Rename __do_rcu_dereference_check() to rcu_lockdep_assert(),
	given that Tetsuo Handa has found outside-of-RCU use for this
	function.
29.	Add a boot parameter to suppress RCU CPU stall warnings.
30.	Update kerneldoc or rcu_read_lock(), call_rcu(), and
	synchronize_rcu().

For a testing-only git-tree version of this patchset, see:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

By "testing-only" I mean that any of the commits in the rcu/testing branch
might be folded, spindled, or otherwise mutilated at any time.  ;-)

							Thanx, Paul

 Documentation/DocBook/kernel-locking.tmpl   |    6 
 b/Documentation/DocBook/kernel-locking.tmpl |    8 
 b/Documentation/RCU/checklist.txt           |   23 +
 b/arch/x86/include/asm/kvm_host.h           |    2 
 b/drivers/input/evdev.c                     |    2 
 b/drivers/net/bnx2.h                        |    2 
 b/drivers/net/bnx2x.h                       |    2 
 b/drivers/net/cnic.h                        |    2 
 b/drivers/net/macvtap.c                     |    2 
 b/drivers/vhost/net.c                       |   15 -
 b/drivers/vhost/vhost.c                     |   29 +-
 b/drivers/vhost/vhost.h                     |   11 
 b/include/linux/cgroup.h                    |    4 
 b/include/linux/compiler.h                  |    4 
 b/include/linux/cred.h                      |    2 
 b/include/linux/fdtable.h                   |    6 
 b/include/linux/fs.h                        |    2 
 b/include/linux/genhd.h                     |    6 
 b/include/linux/idr.h                       |    4 
 b/include/linux/if_macvlan.h                |    2 
 b/include/linux/igmp.h                      |    4 
 b/include/linux/init_task.h                 |    4 
 b/include/linux/input.h                     |    2 
 b/include/linux/iocontext.h                 |    2 
 b/include/linux/key.h                       |    3 
 b/include/linux/kvm_host.h                  |    2 
 b/include/linux/mm_types.h                  |    2 
 b/include/linux/netdevice.h                 |   12 
 b/include/linux/nfs_fs.h                    |    2 
 b/include/linux/notifier.h                  |   10 
 b/include/linux/perf_event.h                |    6 
 b/include/linux/radix-tree.h                |    4 
 b/include/linux/rculist.h                   |   53 ++--
 b/include/linux/rculist_nulls.h             |   16 -
 b/include/linux/rcupdate.h                  |  352 ++++++++++++++++------------
 b/include/linux/sched.h                     |    2 
 b/include/linux/srcu.h                      |   27 +-
 b/include/linux/sunrpc/auth_gss.h           |    4 
 b/include/net/cls_cgroup.h                  |    3 
 b/include/net/dst.h                         |    2 
 b/include/net/fib_rules.h                   |    2 
 b/include/net/garp.h                        |    2 
 b/include/net/inet_sock.h                   |    2 
 b/include/net/ip6_tunnel.h                  |    2 
 b/include/net/ipip.h                        |    6 
 b/include/net/net_namespace.h               |    2 
 b/include/net/netfilter/nf_conntrack.h      |    2 
 b/include/net/netns/xfrm.h                  |    2 
 b/include/net/sock.h                        |    4 
 b/kernel/cgroup.c                           |    2 
 b/kernel/pid.c                              |    2 
 b/kernel/rcupdate.c                         |    6 
 b/kernel/rcutorture.c                       |    6 
 b/kernel/rcutree.c                          |   42 +--
 b/kernel/rcutree.h                          |    5 
 b/kernel/rcutree_plugin.h                   |    4 
 b/kernel/rcutree_trace.c                    |    2 
 b/kernel/sched.c                            |    2 
 b/lib/Kconfig.debug                         |   13 +
 b/lib/radix-tree.c                          |    2 
 b/net/802/stp.c                             |    4 
 b/net/ipv4/ip_gre.c                         |    2 
 b/net/ipv4/ipip.c                           |   10 
 b/net/ipv4/netfilter/nf_nat_core.c          |    2 
 b/net/ipv4/protocol.c                       |    2 
 b/net/ipv4/route.c                          |    2 
 b/net/ipv4/tcp.c                            |    4 
 b/net/ipv6/ip6_tunnel.c                     |    6 
 b/net/ipv6/protocol.c                       |    2 
 b/net/ipv6/sit.c                            |   10 
 b/net/mac80211/ieee80211_i.h                |   15 -
 b/net/mac80211/sta_info.h                   |    4 
 b/net/netfilter/core.c                      |    2 
 b/net/netfilter/nf_conntrack_ecache.c       |    4 
 b/net/netfilter/nf_conntrack_extend.c       |    2 
 b/net/netfilter/nf_conntrack_proto.c        |    4 
 b/net/netfilter/nf_log.c                    |    2 
 b/net/netfilter/nf_queue.c                  |    2 
 b/net/netlabel/netlabel_domainhash.c        |    4 
 b/net/netlabel/netlabel_unlabeled.c         |    4 
 b/net/netlink/af_netlink.c                  |    2 
 b/net/phonet/af_phonet.c                    |    2 
 b/net/phonet/pn_dev.c                       |    2 
 b/net/socket.c                              |    2 
 include/linux/kvm_host.h                    |    4 
 include/linux/rcupdate.h                    |   36 +-
 include/linux/sched.h                       |    6 
 kernel/rcutree.c                            |   11 
 kernel/rcutree.h                            |    2 
 kernel/rcutree_plugin.h                     |    8 
 lib/Kconfig.debug                           |   11 
 91 files changed, 563 insertions(+), 366 deletions(-)
