Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2AXCnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:43:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2AXCnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.231904974@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [026/129] nfs: fix regression in handling of context= option in NFSv4
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 4147
Lines: 140

From: Jeff Layton <jlayton@redhat.com>

commit 8a0d551a59ac92d8ff048d6cb29d3a02073e81e8 upstream.

Setting the security context of a NFSv4 mount via the context= mount
option is currently broken. The NFSv4 codepath allocates a parsed
options struct, and then parses the mount options to fill it. It
eventually calls nfs4_remote_mount which calls security_init_mnt_opts.
That clobbers the lsm_opts struct that was populated earlier. This bug
also looks like it causes a small memory leak on each v4 mount where
context= is used.

Fix this by moving the initialization of the lsm_opts into
nfs_alloc_parsed_mount_data. Also, add a destructor for
nfs_parsed_mount_data to make it easier to free all of the allocations
hanging off of it, and to ensure that the security_free_mnt_opts is
called whenever security_init_mnt_opts is.

I believe this regression was introduced quite some time ago, probably
by commit c02d7adf.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |   43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -909,10 +909,24 @@ static struct nfs_parsed_mount_data *nfs
 		data->auth_flavor_len	= 1;
 		data->version		= version;
 		data->minorversion	= 0;
+		security_init_mnt_opts(&data->lsm_opts);
 	}
 	return data;
 }
 
+static void nfs_free_parsed_mount_data(struct nfs_parsed_mount_data *data)
+{
+	if (data) {
+		kfree(data->client_address);
+		kfree(data->mount_server.hostname);
+		kfree(data->nfs_server.export_path);
+		kfree(data->nfs_server.hostname);
+		kfree(data->fscache_uniq);
+		security_free_mnt_opts(&data->lsm_opts);
+		kfree(data);
+	}
+}
+
 /*
  * Sanity-check a server address provided by the mount command.
  *
@@ -2220,9 +2234,7 @@ static struct dentry *nfs_fs_mount(struc
 	data = nfs_alloc_parsed_mount_data(NFS_DEFAULT_VERSION);
 	mntfh = nfs_alloc_fhandle();
 	if (data == NULL || mntfh == NULL)
-		goto out_free_fh;
-
-	security_init_mnt_opts(&data->lsm_opts);
+		goto out;
 
 	/* Validate the mount data */
 	error = nfs_validate_mount_data(raw_data, data, mntfh, dev_name);
@@ -2234,8 +2246,6 @@ static struct dentry *nfs_fs_mount(struc
 #ifdef CONFIG_NFS_V4
 	if (data->version == 4) {
 		mntroot = nfs4_try_mount(flags, dev_name, data);
-		kfree(data->client_address);
-		kfree(data->nfs_server.export_path);
 		goto out;
 	}
 #endif	/* CONFIG_NFS_V4 */
@@ -2290,13 +2300,8 @@ static struct dentry *nfs_fs_mount(struc
 	s->s_flags |= MS_ACTIVE;
 
 out:
-	kfree(data->nfs_server.hostname);
-	kfree(data->mount_server.hostname);
-	kfree(data->fscache_uniq);
-	security_free_mnt_opts(&data->lsm_opts);
-out_free_fh:
+	nfs_free_parsed_mount_data(data);
 	nfs_free_fhandle(mntfh);
-	kfree(data);
 	return mntroot;
 
 out_err_nosb:
@@ -2623,9 +2628,7 @@ nfs4_remote_mount(struct file_system_typ
 
 	mntfh = nfs_alloc_fhandle();
 	if (data == NULL || mntfh == NULL)
-		goto out_free_fh;
-
-	security_init_mnt_opts(&data->lsm_opts);
+		goto out;
 
 	/* Get a volume representation */
 	server = nfs4_create_server(data, mntfh);
@@ -2677,13 +2680,10 @@ nfs4_remote_mount(struct file_system_typ
 
 	s->s_flags |= MS_ACTIVE;
 
-	security_free_mnt_opts(&data->lsm_opts);
 	nfs_free_fhandle(mntfh);
 	return mntroot;
 
 out:
-	security_free_mnt_opts(&data->lsm_opts);
-out_free_fh:
 	nfs_free_fhandle(mntfh);
 	return ERR_PTR(error);
 
@@ -2838,7 +2838,7 @@ static struct dentry *nfs4_mount(struct
 
 	data = nfs_alloc_parsed_mount_data(4);
 	if (data == NULL)
-		goto out_free_data;
+		goto out;
 
 	/* Validate the mount data */
 	error = nfs4_validate_mount_data(raw_data, data, dev_name);
@@ -2852,12 +2852,7 @@ static struct dentry *nfs4_mount(struct
 		error = PTR_ERR(res);
 
 out:
-	kfree(data->client_address);
-	kfree(data->nfs_server.export_path);
-	kfree(data->nfs_server.hostname);
-	kfree(data->fscache_uniq);
-out_free_data:
-	kfree(data);
+	nfs_free_parsed_mount_data(data);
 	dprintk("<-- nfs4_mount() = %d%s\n", error,
 			error != 0 ? " [error]" : "");
 	return res;


