Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab0G3Sft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:35:49 -0400
Received: from kroah.org ([198.145.64.141]:58005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759807Ab0G3Ryo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:37 2010
Message-Id: <20100730175137.026234500@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [038/205] NFSv4: Ensure that /proc/self/mountinfo displays the minor version number
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 0be8189f2c87fcc747d6a4a657a0b6e2161b2318 upstream.

Currently, we do not display the minor version mount parameter in the
/proc mount info.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -566,6 +566,22 @@ static void nfs_show_mountd_options(stru
 	nfs_show_mountd_netid(m, nfss, showdefaults);
 }
 
+#ifdef CONFIG_NFS_V4
+static void nfs_show_nfsv4_options(struct seq_file *m, struct nfs_server *nfss,
+				    int showdefaults)
+{
+	struct nfs_client *clp = nfss->nfs_client;
+
+	seq_printf(m, ",clientaddr=%s", clp->cl_ipaddr);
+	seq_printf(m, ",minorversion=%u", clp->cl_minorversion);
+}
+#else
+static void nfs_show_nfsv4_options(struct seq_file *m, struct nfs_server *nfss,
+				    int showdefaults)
+{
+}
+#endif
+
 /*
  * Describe the mount options in force on this server representation
  */
@@ -627,11 +643,9 @@ static void nfs_show_mount_options(struc
 
 	if (version != 4)
 		nfs_show_mountd_options(m, nfss, showdefaults);
+	else
+		nfs_show_nfsv4_options(m, nfss, showdefaults);
 
-#ifdef CONFIG_NFS_V4
-	if (clp->rpc_ops->version == 4)
-		seq_printf(m, ",clientaddr=%s", clp->cl_ipaddr);
-#endif
 	if (nfss->options & NFS_OPTION_FSCACHE)
 		seq_printf(m, ",fsc");
 }


