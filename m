Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1JRGH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:07:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53402 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1JRGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:07:55 -0400
Date: Tue, 18 Oct 2011 14:07:48 +0800
From: wzt <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, xemul@openvz.org, ebiederm@xmission.com
Subject: [PATCH] kernel/nsproxy.c: Fix memory leak of create_new_namespaces().
Message-ID: <20111018060747.GA462@program>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_pid_ns() has allocted some memory via create_pid_namespace(), if copy_net_ns()
failed via create_new_namespaces(), it will cause memory leak. The copy_utsname()
have the same problem.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 kernel/nsproxy.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 9aeab4b..fdcec31 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -99,14 +99,18 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	return new_nsp;
 
 out_net:
-	if (new_nsp->pid_ns)
+	if (new_nsp->pid_ns) {
 		put_pid_ns(new_nsp->pid_ns);
+		free_pid_ns(&new_nsp->pid_ns->kref);
+	}
 out_pid:
 	if (new_nsp->ipc_ns)
 		put_ipc_ns(new_nsp->ipc_ns);
 out_ipc:
-	if (new_nsp->uts_ns)
+	if (new_nsp->uts_ns) {
 		put_uts_ns(new_nsp->uts_ns);
+		free_uts_ns(&new_nsp->pid_ns->kref);
+	}
 out_uts:
 	if (new_nsp->mnt_ns)
 		put_mnt_ns(new_nsp->mnt_ns);
-- 
1.7.4.1

