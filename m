Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2HNC7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:59:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:50329 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab2HNC7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,763,1336374000"; 
   d="scan'208";a="207917316"
From: John Fastabend <john.r.fastabend@intel.com>
Subject: [net PATCH v2 1/2] net: netprio: fix files lock and remove useless
	d_path bits
To: viro@ZenIV.linux.org.uk, nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        joe@perches.com
Date: Mon, 13 Aug 2012 19:43:21 -0700
Message-ID: <20120814024320.6983.92222.stgit@jf-dev1-dcblab>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lock to prevent a race with a file closing and also remove
useless and ugly sscanf code. The extra code was never needed
and the case it supposedly protected against is in fact handled
correctly by sock_from_file as pointed out by Al Viro.

CC: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
---

 net/core/netprio_cgroup.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index ed0c043..f65dba3 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -277,12 +277,6 @@ out_free_devname:
 void net_prio_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
 	struct task_struct *p;
-	char *tmp = kzalloc(sizeof(char) * PATH_MAX, GFP_KERNEL);
-
-	if (!tmp) {
-		pr_warn("Unable to attach cgrp due to alloc failure!\n");
-		return;
-	}
 
 	cgroup_taskset_for_each(p, cgrp, tset) {
 		unsigned int fd;
@@ -296,32 +290,24 @@ void net_prio_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 			continue;
 		}
 
-		rcu_read_lock();
+		spin_lock(&files->file_lock);
 		fdt = files_fdtable(files);
 		for (fd = 0; fd < fdt->max_fds; fd++) {
-			char *path;
 			struct file *file;
 			struct socket *sock;
-			unsigned long s;
-			int rv, err = 0;
+			int err;
 
 			file = fcheck_files(files, fd);
 			if (!file)
 				continue;
 
-			path = d_path(&file->f_path, tmp, PAGE_SIZE);
-			rv = sscanf(path, "socket:[%lu]", &s);
-			if (rv <= 0)
-				continue;
-
 			sock = sock_from_file(file, &err);
-			if (!err)
+			if (sock)
 				sock_update_netprioidx(sock->sk, p);
 		}
-		rcu_read_unlock();
+		spin_unlock(&files->file_lock);
 		task_unlock(p);
 	}
-	kfree(tmp);
 }
 
 static struct cftype ss_files[] = {

