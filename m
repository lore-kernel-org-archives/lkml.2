Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab1FHTaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:30:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54892 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab1FHTaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:02 -0400
Date: Wed, 8 Jun 2011 12:29:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        viro@zeniv.linux.org.uk, eparis@redhat.com, axboe@kernel.dk,
        Trond.Myklebust@netapp.com, jmorris@namei.org, robert.w.love@intel.com,
        James.Bottomley@suse.de, jes@sgi.com, tony.luck@intel.com,
        fenghua.yu@intel.com, jack@suse.cz, neilb@suse.de, sds@tycho.nsa.gov,
        manfred@colorfullife.com, namhyung@gmail.com, rientjes@google.com,
        kaber@trash.net, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/28] patches queued for 3.1, first installment
Message-ID: <20110608192943.GA13211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset contains some simplifications, bug fixes, documentation
updates, and a bunch of leftover conversions to kfree_rcu().  Almost
all of the latter need either an Acked-by or to be taken into the
appropriate maintainer tree.  The patches are as follows:

1.	Simplify RCU kthread creation.
2.	Convert from kthread_create() to kthread_create_on_node()
	(courtesy of Eric Dumazet).
3.	Improve rcu_read_lock() code generation.
4.	Restore checks for blocking within RCU read-side critical
	sections under CONFIG_PROVE_RCU.
5.	Move struct rcu_head into types.h as a first step towards
	untangling header files.
6.	Update rcutorture documentation to account for boosting,
	memory-barrier testing, and (not so) new flavors of RCU.
7.	Fix type mismatch (courtesy of Andi Kleen).
8.	Combine common grace-period-wait code.
9.	Eliminate rcutorture workarounds for previously missing
	RCU API members, and add testing of synchronize_rcu_bh_expedited().
10.	Update RCU's NMI documentation.
11-27.	Conversions to kfree_rcu() (courtesy of Lai Jiangshan,
	in need of either Acked-by or adoption).
28.	Convert call_rcu(sk_filter_release_rcu) to kfree_rcu
	(courtesy of Lai Jiangshan, already acked).

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/NMI-RCU.txt |    2 
 b/Documentation/RCU/torture.txt |  134 ++++++++++++++++++++++++++++----------
 b/arch/ia64/sn/kernel/irq.c     |   14 ----
 b/block/cfq-iosched.c           |    7 --
 b/block/genhd.c                 |   10 --
 b/drivers/md/linear.c           |    8 --
 b/drivers/scsi/libfc/fc_rport.c |   14 ----
 b/fs/jbd2/journal.c             |    7 --
 b/fs/nfs/delegation.c           |   14 ----
 b/include/linux/lockdep.h       |    2 
 b/include/linux/rcupdate.h      |   28 ++++++--
 b/include/linux/rcutiny.h       |   16 ++++
 b/include/linux/rcutree.h       |    2 
 b/include/linux/types.h         |   10 ++
 b/include/net/sock.h            |    4 -
 b/ipc/sem.c                     |   10 --
 b/ipc/util.c                    |   16 ----
 b/kernel/audit_tree.c           |    8 --
 b/kernel/lockdep.c              |   84 +++++++++++++-----------
 b/kernel/pid.c                  |    4 -
 b/kernel/rcupdate.c             |   21 +++++-
 b/kernel/rcutiny.c              |   28 --------
 b/kernel/rcutiny_plugin.h       |   14 ----
 b/kernel/rcutorture.c           |    3 
 b/kernel/rcutree.c              |   65 ++++++------------
 b/kernel/rcutree_plugin.h       |   11 ---
 b/kernel/rcutree_trace.c        |    2 
 b/kernel/sched.c                |    2 
 b/kernel/sysctl.c               |   11 ---
 b/mm/vmalloc.c                  |    9 --
 b/net/core/filter.c             |   12 ---
 b/net/netfilter/xt_RATEEST.c    |    8 --
 b/security/device_cgroup.c      |   10 --
 b/security/selinux/netnode.c    |   20 -----
 b/security/selinux/netport.c    |   20 -----
 include/linux/rcupdate.h        |  140 +++++++++++++++++++++-------------------
 kernel/rcutorture.c             |   55 ++++++---------
 kernel/rcutree.c                |   27 +------
 kernel/rcutree_plugin.h         |   23 ++----
 mm/vmalloc.c                    |    9 --
 40 files changed, 379 insertions(+), 505 deletions(-)
