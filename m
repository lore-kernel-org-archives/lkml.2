Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1I1WmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab1I1Wl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.883219958@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        WANG Cong <amwang@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [063/244] sched: Fix a memory leak in __sdt_free()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: WANG Cong <amwang@redhat.com>

commit feff8fa0075bdfd43c841e9d689ed81adda988d6 upstream.

This patch fixes the following memory leak:

unreferenced object 0xffff880107266800 (size 512):
  comm "sched-powersave", pid 3718, jiffies 4323097853 (age 27495.450s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81133940>] create_object+0x187/0x28b
    [<ffffffff814ac103>] kmemleak_alloc+0x73/0x98
    [<ffffffff811232ba>] __kmalloc_node+0x104/0x159
    [<ffffffff81044b98>] kzalloc_node.clone.97+0x15/0x17
    [<ffffffff8104cb90>] build_sched_domains+0xb7/0x7f3
    [<ffffffff8104d4df>] partition_sched_domains+0x1db/0x24a
    [<ffffffff8109ee4a>] do_rebuild_sched_domains+0x3b/0x47
    [<ffffffff810a00c7>] rebuild_sched_domains+0x10/0x12
    [<ffffffff8104d5ba>] sched_power_savings_store+0x6c/0x7b
    [<ffffffff8104d5df>] sched_mc_power_savings_store+0x16/0x18
    [<ffffffff8131322c>] sysdev_class_store+0x20/0x22
    [<ffffffff81193876>] sysfs_write_file+0x108/0x144
    [<ffffffff81135b10>] vfs_write+0xaf/0x102
    [<ffffffff81135d23>] sys_write+0x4d/0x74
    [<ffffffff814c8a42>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1313671017-4112-1-git-send-email-amwang@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7423,6 +7423,7 @@ static void __sdt_free(const struct cpum
 			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
 			if (sd && (sd->flags & SD_OVERLAP))
 				free_sched_groups(sd->groups, 0);
+			kfree(*per_cpu_ptr(sdd->sd, j));
 			kfree(*per_cpu_ptr(sdd->sg, j));
 			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}


