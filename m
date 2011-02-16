Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1BPBdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:33:04 -0500
Received: from kroah.org ([198.145.64.141]:39244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab1BPAVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:36 2011
Message-Id: <20110216001436.398815984@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [113/272] nfsd4: name->id mapping should fail with BADOWNER not BADNAME
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

commit f6af99ec1b261e21219d5eba99e3af48fc6c32d4 upstream.

According to rfc 3530 BADNAME is for strings that represent paths;
BADOWNER is for user/group names that don't map.

And the too-long name should probably be BADOWNER as well; it's
effectively the same as if we couldn't map it.

Reported-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reported-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4idmap.c |    4 ++--
 fs/nfsd/nfsd.h      |    1 +
 fs/nfsd/nfsproc.c   |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -524,13 +524,13 @@ idmap_name_to_id(struct svc_rqst *rqstp,
 	int ret;
 
 	if (namelen + 1 > sizeof(key.name))
-		return -EINVAL;
+		return -ESRCH; /* nfserr_badowner */
 	memcpy(key.name, name, namelen);
 	key.name[namelen] = '\0';
 	strlcpy(key.authname, rqst_authname(rqstp), sizeof(key.authname));
 	ret = idmap_lookup(rqstp, nametoid_lookup, &key, &nametoid_cache, &item);
 	if (ret == -ENOENT)
-		ret = -ESRCH; /* nfserr_badname */
+		ret = -ESRCH; /* nfserr_badowner */
 	if (ret)
 		return ret;
 	*id = item->id;
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -158,6 +158,7 @@ void		nfsd_lockd_shutdown(void);
 #define	nfserr_attrnotsupp	cpu_to_be32(NFSERR_ATTRNOTSUPP)
 #define	nfserr_bad_xdr		cpu_to_be32(NFSERR_BAD_XDR)
 #define	nfserr_openmode		cpu_to_be32(NFSERR_OPENMODE)
+#define	nfserr_badowner		cpu_to_be32(NFSERR_BADOWNER)
 #define	nfserr_locks_held	cpu_to_be32(NFSERR_LOCKS_HELD)
 #define	nfserr_op_illegal	cpu_to_be32(NFSERR_OP_ILLEGAL)
 #define	nfserr_grace		cpu_to_be32(NFSERR_GRACE)
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -737,7 +737,7 @@ nfserrno (int errno)
 		{ nfserr_jukebox, -ERESTARTSYS },
 		{ nfserr_dropit, -EAGAIN },
 		{ nfserr_dropit, -ENOMEM },
-		{ nfserr_badname, -ESRCH },
+		{ nfserr_badowner, -ESRCH },
 		{ nfserr_io, -ETXTBSY },
 		{ nfserr_notsupp, -EOPNOTSUPP },
 		{ nfserr_toosmall, -ETOOSMALL },


