Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2AXQ7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:59:10 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27907 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab2AXQ7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:59:08 -0500
Subject: [PATCH] Lockd: don't mark freshly created sockets with XPT_CHNGBUF
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Tue, 24 Jan 2012 20:59:01 +0400
Message-ID: <20120124165826.22037.58630.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch.
XPT_CHNGBUF bit is set on UDP socket creation. Calling svc_sock_update_bufs
from lockd after sockets creation looks redundant.
Below is Lockd UDP sockets creating call trace:

lockd_up {

make_socks
create_lockd_family
create_lockd_listener
svc_create_xprt
__svc_xpo_create
svc_udp_create
svc_create_socket
svc_setup_socket
svc_udp_init (raise XPT_CHNGBUF)

....

svc_sock_update_bufs (raise XPT_CHNGBUF again)

....

}

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 fs/lockd/svc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index ff379ff..55fea92 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -292,7 +292,6 @@ int lockd_up(void)
 		goto destroy_and_out;
 	}
 
-	svc_sock_update_bufs(serv);
 	serv->sv_maxconn = nlm_max_connections;
 
 	nlmsvc_task = kthread_run(lockd, nlmsvc_rqst, serv->sv_name);

