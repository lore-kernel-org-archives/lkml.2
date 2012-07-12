Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908Ab2GLXcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:32:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161834Ab2GLWkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 091/187] NFS: Force the legacy idmapper to be single threaded
Date: Thu, 12 Jul 2012 15:34:07 -0700
Message-Id: <20120712191530.844421189@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit b1027439dff844675f6c0df97a1b1d190791a699 upstream.

It was initially coded under the assumption that there would only be one
request at a time, so use a lock to enforce this requirement..

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/idmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -57,6 +57,11 @@ unsigned int nfs_idmap_cache_timeout = 6
 static const struct cred *id_resolver_cache;
 static struct key_type key_type_id_resolver_legacy;
 
+struct idmap {
+	struct rpc_pipe		*idmap_pipe;
+	struct key_construction	*idmap_key_cons;
+	struct mutex		idmap_mutex;
+};
 
 /**
  * nfs_fattr_init_names - initialise the nfs_fattr owner_name/group_name fields
@@ -310,9 +315,11 @@ static ssize_t nfs_idmap_get_key(const c
 					    name, namelen, type, data,
 					    data_size, NULL);
 	if (ret < 0) {
+		mutex_lock(&idmap->idmap_mutex);
 		ret = nfs_idmap_request_key(&key_type_id_resolver_legacy,
 					    name, namelen, type, data,
 					    data_size, idmap);
+		mutex_unlock(&idmap->idmap_mutex);
 	}
 	return ret;
 }
@@ -354,11 +361,6 @@ static int nfs_idmap_lookup_id(const cha
 /* idmap classic begins here */
 module_param(nfs_idmap_cache_timeout, int, 0644);
 
-struct idmap {
-	struct rpc_pipe		*idmap_pipe;
-	struct key_construction	*idmap_key_cons;
-};
-
 enum {
 	Opt_find_uid, Opt_find_gid, Opt_find_user, Opt_find_group, Opt_find_err
 };
@@ -469,6 +471,7 @@ nfs_idmap_new(struct nfs_client *clp)
 		return error;
 	}
 	idmap->idmap_pipe = pipe;
+	mutex_init(&idmap->idmap_mutex);
 
 	clp->cl_idmap = idmap;
 	return 0;


