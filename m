Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705Ab1KJD03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:26:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934673Ab1KJD0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:09 2011
Message-Id: <20111109212709.867374085@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [093/262] nfsd4: fix seqid_mutating_error
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 576163005de286bbd418fcb99cfd0971523a0c6d upstream.

The set of errors here does *not* agree with the set of errors specified
in the rfc!

While we're there, turn this macros into a function, for the usual
reasons, and move it to the one place where it's actually used.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |   12 ++++++++++++
 fs/nfsd/state.h   |    6 ------
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1548,6 +1548,18 @@ static void write_cinfo(__be32 **p, stru
 								\
 	save = resp->p;
 
+static bool seqid_mutating_err(__be32 err)
+{
+	/* rfc 3530 section 8.1.5: */
+	return	err != nfserr_stale_clientid &&
+		err != nfserr_stale_stateid &&
+		err != nfserr_bad_stateid &&
+		err != nfserr_bad_seqid &&
+		err != nfserr_bad_xdr &&
+		err != nfserr_resource &&
+		err != nfserr_nofilehandle;
+}
+
 /*
  * Routine for encoding the result of a "seqid-mutating" NFSv4 operation.  This
  * is where sequence id's are incremented, and the replay cache is filled.
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -447,12 +447,6 @@ struct nfs4_stateid {
 #define WR_STATE	        0x00000020
 #define CLOSE_STATE             0x00000040
 
-#define seqid_mutating_err(err)                       \
-	(((err) != nfserr_stale_clientid) &&    \
-	((err) != nfserr_bad_seqid) &&          \
-	((err) != nfserr_stale_stateid) &&      \
-	((err) != nfserr_bad_stateid))
-
 struct nfsd4_compound_state;
 
 extern __be32 nfs4_preprocess_stateid_op(struct nfsd4_compound_state *cstate,


