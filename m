Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1EABgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:36:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1EABgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pqmcGaqT+XXaipnlvUCc+7oU1g+Xc1ZE6Se84FBa7xqbHeyuAJwHxT5MZs7BBPHMeJ
         uevPgatCpdhL9b5qrCxftAPYXCZiHhT2J3TYp1MtPkXcr+SWgFaOrqQ+mGUWbA/csEQx
         wr1XVLO2MhKz2KXVShjN+Qz+IyiWsO0ZOF508=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 00/69] faster tree-based sysctl implementation
Date: Sun,  1 May 2011 03:35:30 +0200
Message-Id: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Short description: sysctl is slow (bad algorithm); this patch series
makes it faster (without using more memory but with some limitations).


$ time modprobe dummy numdummies=N

Without this patch series :(
- ipv4 only
  -  N=1000  time= 0m 06s
  -  N=2000  time= 0m 30s
  -  N=4000  time= 2m 35s
- ipv4 and ipv6
  -  N=1000  time= 0m 24s
  -  N=2000  time= 2m 14s
  -  N=4000  time=10m 16s
  -  N=5000  time=16m 03s


With this patch series    :)
- ipv4 only
  -  N=1000  time=0.33s
  -  N=2000  time=1.25s
  -  N=4000  time=5.31s
- ipv4 and ipv6
  -  N=1000  time=0.41s
  -  N=2000  time=1.62s
  -  N=4000  time=7.64s
  -  N=5000  time=12.35s
  -  N=8000  time=36.95s


Tests were done with and without ipv6 with the same .config on
2.6.39-rc5 with and without this patch series running:

Note about time stats: adding a netdevice registers
- two sysctl tables for ipv4:
     /proc/sys/net/ipv4/conf/DEVICE
     /proc/sys/net/ipv4/neigh/DEVICE
- two sysctl tables for ipv6:
     /proc/sys/net/ipv6/conf/DEVICE
     /proc/sys/net/ipv6/neigh/DEVICE


Some companies (e.g. IXIACOM which sponsored this work) have use cases
where they need to create 10^3->10^5 (virtual) network devices. They
can't use the current sysctl because of the time it takes to register
so many sysctl tables.



The first patches remove the .child field of ctl_table. This is a
requirement for the new algorithm. These patches are scattered all
over the tree :(

 Some patches make changes in architectures I don't know how to
compile to or drivers for which I don't have devices (there the
patches were at least compiled :).



People interested in the core sysctl changes/networking should read:

   [PATCH 60/69] sysctl: faster tree-based sysctl implementation

which introduces the new algorithm (commit message and comments have
more details), and the next few patches which add some further (simple
and effective) optimisations for networking (and not only).


The last patch tries to replace a rwsem with rcu+spinlock. I'm not
sure about it because I haven't worked with RCU before. If you find
some big ugly monstrosity there, please don't disregard the rest of
the series. :)



Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Octavian Purdila <tavi@cs.pub.ro>
Cc: "David S . Miller" <davem@davemloft.net>


Lucian Adrian Grijincu (69):
  sysctl: remove .child from dev/parport/default
  sysctl: parport: reorder .child assignments to simplify review
  sysctl: remove .child from dev/parport/PORT/devices/DEVICE
  sysctl: remove .child from dev/parport/PORT/
  sysctl: remove .child from dev/parport/PORT/devices/
  sysctl: remove .child from kernel/vsyscall64 (x86)
  sysctl: remove .child from abi/vsyscall32 (x86)
  sysctl: remove .child from crypto/fips_enabled
  sysctl: remove .child from dev/cdrom/
  sysctl: remove .child from dev/hpet/
  sysctl: remove .child from dev/ipmi/
  sysctl: remove .child from dev/rtc/
  sysctl: remove .child from dev/mac_hid/
  sysctl: remove .child from dev/raid/
  sysctl: remove .child from xpc/
  sysctl: remove .child from xpc/hb
  sysctl: remove .child from kernel/sclp (s390)
  sysctl: remove .child from dev/scsi
  sysctl: remove .child from kernel/pty
  sysctl: remove .child from coda/
  sysctl: remove .child from fscache/
  sysctl: remove .child from fs/nfs/ nlm_table table
  sysctl: remove .child from fs/nfs/ nfs_cb_table
  sysctl: remove .child from fs/ntfs-debug
  sysctl: remove .child from fs/ocfs2/nm/
  sysctl: remove .child from fs/quota/
  sysctl: remove .child from fs/xfs/
  sysctl: remove .child from kernel/ (ipc)
  sysctl: remove .child from fs/mqueue
  sysctl: sched: add sd_table_template
  sysctl: remove .child from kernel/sched_domain/cpuX/domainY/
  sysctl: remove .child from kernel/ (utsname)
  sysctl: remove .child from sunrpc/
  sysctl: remove .child from sunrpc/svc_rdma
  sysctl: remove .child from sunrpc/ (xprtrdma)
  sysctl: remove .child from sunrpc/ (xprtsock)
  sysctl: remove .child from bus/isa/ (arm)
  sysctl: remove .child from reboot/warm (arm)
  sysctl: remove .child from lasat/ (mips)
  sysctl: remove .child from appldata/ (s390)
  sysctl: remove .child from s390dbf/
  sysctl: remove .child from vm/ (s390)
  sysctl: remove .child from kernel/perfmon/ (ia64)
  sysctl: remove .child from kernel/ (ia64/kdump)
  sysctl: remove .child from kernel/powersave-nap (powerpc)
  sysctl: remove .child from pm/ (frv)
  sysctl: remove .child from frv/
  sysctl: remove .child from sh64/unaligned_fixup/
  sysctl: delete unused register_sysctl_table function
  sysctl: remove .child from ax25 table
  sysctl: remove .child from net/ipv4/route and net/ipv4/neigh tables
  sysctl: remove .child from net/ipv4/neigh table
  sysctl: remove .child from net/ipv6/route, net/ipv6/icmp, net/ipv6 tables
  sysctl: remove .child from net/llc tables
  sysctl: no-child: manually register kernel/random
  sysctl: no-child: manually register kernel/keys
  sysctl: no-child: manually register fs/inotify
  sysctl: no-child: manually register fs/epoll
  sysctl: no-child: manually register root tables
  sysctl: faster tree-based sysctl implementation
  sysctl: single subheader path: optimisation for paths used only once
  sysctl: single subheader path: net/ipv4/conf/DEVICE-NAME/
  sysctl: single subheader path: net/{ipv4|ipv6}/neigh/DEV/
  sysctl: single subheader path: net/ipv6/conf/DEVICE-NAME/
  sysctl: single subheader path: dev/parport/PORT/devices/DEVICE/
  sysctl: single subheader path: net/ax25/DEVICE
  sysctl: single subheader path: kernel/sched_domain/CPU/DOMAIN/
  sysctl: single subheader path: net/decnet/conf/DEVNAME
  RFC: sysctl: convert read-write lock to RCU

 arch/arm/kernel/isa.c              |   31 +-
 arch/arm/mach-bcmring/arch.c       |   25 +-
 arch/frv/kernel/pm.c               |   10 +-
 arch/frv/kernel/sysctl.c           |   12 +-
 arch/ia64/kernel/crash.c           |   13 +-
 arch/ia64/kernel/perfmon.c         |   23 +-
 arch/mips/lasat/sysctl.c           |   13 +-
 arch/powerpc/kernel/idle.c         |   13 +-
 arch/s390/appldata/appldata_base.c |   42 +-
 arch/s390/kernel/debug.c           |   13 +-
 arch/s390/mm/cmm.c                 |   11 +-
 arch/sh/kernel/traps_64.c          |   21 +-
 arch/x86/kernel/vsyscall_64.c      |   25 +-
 arch/x86/vdso/vdso32-setup.c       |   14 +-
 crypto/proc.c                      |   12 +-
 drivers/cdrom/cdrom.c              |   22 +-
 drivers/char/hpet.c                |   38 +--
 drivers/char/ipmi/ipmi_poweroff.c  |   16 +-
 drivers/char/random.c              |   27 ++-
 drivers/char/rtc.c                 |   24 +-
 drivers/macintosh/mac_hid.c        |   26 +-
 drivers/md/md.c                    |   22 +-
 drivers/misc/sgi-xp/xpc_main.c     |   81 ++--
 drivers/parport/procfs.c           |  231 +++++-------
 drivers/s390/char/sclp_async.c     |   13 +-
 drivers/scsi/scsi_sysctl.c         |   28 +-
 drivers/tty/pty.c                  |   23 +-
 fs/coda/sysctl.c                   |   12 +-
 fs/eventpoll.c                     |   22 +-
 fs/fscache/main.c                  |   15 +-
 fs/lockd/svc.c                     |   22 +-
 fs/nfs/sysctl.c                    |   22 +-
 fs/notify/inotify/inotify_user.c   |   22 +-
 fs/ntfs/sysctl.c                   |   15 +-
 fs/ocfs2/stackglue.c               |   36 +--
 fs/proc/inode.c                    |    2 +-
 fs/proc/proc_sysctl.c              |  201 ++++++----
 fs/quota/dquot.c                   |   21 +-
 fs/xfs/linux-2.6/xfs_sysctl.c      |   22 +-
 include/linux/inotify.h            |    2 -
 include/linux/key.h                |    4 +-
 include/linux/poll.h               |    2 -
 include/linux/sysctl.h             |  189 ++++++----
 include/net/ax25.h                 |   10 +-
 include/net/net_namespace.h        |    2 +-
 include/net/netns/ipv6.h           |    4 +-
 init/main.c                        |    2 +
 ipc/ipc_sysctl.c                   |   12 +-
 ipc/mq_sysctl.c                    |   24 +-
 kernel/sched.c                     |  398 +++++++++++++------
 kernel/sysctl.c                    |  798 +++++++++++++++++++++---------------
 kernel/sysctl_check.c              |  253 ++++++------
 kernel/utsname_sysctl.c            |   14 +-
 net/ax25/af_ax25.c                 |   23 +-
 net/ax25/ax25_dev.c                |   10 +-
 net/ax25/sysctl_net_ax25.c         |   82 ++---
 net/core/neighbour.c               |    8 +-
 net/decnet/dn_dev.c                |    8 +-
 net/ipv4/devinet.c                 |    8 +-
 net/ipv4/route.c                   |   15 +-
 net/ipv6/addrconf.c                |    8 +-
 net/ipv6/sysctl_net_ipv6.c         |  119 +++---
 net/llc/sysctl_net_llc.c           |   55 ++--
 net/sunrpc/sysctl.c                |   19 +-
 net/sunrpc/xprtrdma/svc_rdma.c     |   26 +-
 net/sunrpc/xprtrdma/transport.c    |   14 +-
 net/sunrpc/xprtsock.c              |   16 +-
 net/sysctl_net.c                   |   63 ++--
 security/keys/key.c                |    1 +
 security/keys/sysctl.c             |   18 +-
 70 files changed, 1778 insertions(+), 1670 deletions(-)

-- 
1.7.5.134.g1c08b

