Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063Ab1KCBoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:44:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934941Ab1KCBnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:43:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:46 2011
Message-Id: <20111102222746.624797914@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [075/101] nfsd4: fix seqid_mutating_error
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1507,6 +1507,18 @@ static void write_cinfo(__be32 **p, stru
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
@@ -363,12 +363,6 @@ struct nfs4_stateid {
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


