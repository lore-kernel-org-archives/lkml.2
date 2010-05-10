Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab0EJXpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:45:09 -0400
Received: from kroah.org ([198.145.64.141]:32892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab0EJWvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:43 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:18 2010
Message-Id: <20100510223318.089837401@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [010/117] memcg: fix prepare migration
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 93d5c9be1ddd57d4063ce463c9ac2be1e5ee14f1 upstream.

If a signal is pending (task being killed by sigkill)
__mem_cgroup_try_charge will write NULL into &mem, and css_put will oops
on null pointer dereference.

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
  IP: [<ffffffff810fc6cc>] mem_cgroup_prepare_migration+0x7c/0xc0
  PGD a5d89067 PUD a5d8a067 PMD 0
  Oops: 0000 [#1] SMP
  last sysfs file: /sys/devices/platform/microcode/firmware/microcode/loading
  CPU 0
  Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc acpi_cpufreq pcspkr sg [last unloaded: microcode]

  Pid: 5299, comm: largepages Tainted: G        W  2.6.34-rc3 #3 Penryn1600SLI-110dB/To Be Filled By O.E.M.
  RIP: 0010:[<ffffffff810fc6cc>]  [<ffffffff810fc6cc>] mem_cgroup_prepare_migration+0x7c/0xc0

[nishimura@mxp.nes.nec.co.jp: fix merge issues]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2215,12 +2215,12 @@ int mem_cgroup_prepare_migration(struct
 	}
 	unlock_page_cgroup(pc);
 
+	*ptr = mem;
 	if (mem) {
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false,
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false,
 						page);
 		css_put(&mem->css);
 	}
-	*ptr = mem;
 	return ret;
 }
 


