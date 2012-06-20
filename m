Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2FTSkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:40:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab2FTSVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:38 -0400
Message-Id: <20120620173022.272069605@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Benny Halevy <bhalevy@tonian.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 15/61] nfsd4: BUG_ON(!is_spin_locked()) no good on UP kernels
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit bc2df47a408f2d64cf81bcfd0f6e3e14c84cb0ab upstream.

Most frequent symptom was a BUG triggering in expire_client, with the
server locking up shortly thereafter.

Introduced by 508dc6e110c6dbdc0bbe84298ccfe22de7538486 "nfsd41:
free_session/free_client must be called under the client_lock".

Cc: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -862,7 +862,7 @@ static void free_session(struct kref *kr
 	struct nfsd4_session *ses;
 	int mem;
 
-	BUG_ON(!spin_is_locked(&client_lock));
+	lockdep_assert_held(&client_lock);
 	ses = container_of(kref, struct nfsd4_session, se_ref);
 	nfsd4_del_conns(ses);
 	spin_lock(&nfsd_drc_lock);
@@ -1041,7 +1041,7 @@ static struct nfs4_client *alloc_client(
 static inline void
 free_client(struct nfs4_client *clp)
 {
-	BUG_ON(!spin_is_locked(&client_lock));
+	lockdep_assert_held(&client_lock);
 	while (!list_empty(&clp->cl_sessions)) {
 		struct nfsd4_session *ses;
 		ses = list_entry(clp->cl_sessions.next, struct nfsd4_session,


