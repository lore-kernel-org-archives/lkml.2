Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2KVSd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:33:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:49007 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab2KVSdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 075/171] ceph: ensure auth ops are defined before use
Date: Wed, 21 Nov 2012 16:40:21 -0800
Message-Id: <20121122004040.900999901@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit a255651d4cad89f1a606edd36135af892ada4f20)

In the create_authorizer method for both the mds and osd clients,
the auth_client->ops pointer is blindly dereferenced.  There is no
obvious guarantee that this pointer has been assigned.  And
furthermore, even if the ops pointer is non-null there is definitely
no guarantee that the create_authorizer or destroy_authorizer
methods are defined.

Add checks in both routines to make sure they are defined (non-null)
before use.  Add similar checks in a few other spots in these files
while we're at it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c  |   14 ++++++--------
 net/ceph/osd_client.c |   15 ++++++++++-----
 2 files changed, 16 insertions(+), 13 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3406,16 +3406,14 @@ static int get_authorizer(struct ceph_co
 	int ret = 0;
 
 	if (force_new && auth->authorizer) {
-		ac->ops->destroy_authorizer(ac, auth->authorizer);
+		if (ac->ops && ac->ops->destroy_authorizer)
+			ac->ops->destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (auth->authorizer == NULL) {
-		if (ac->ops->create_authorizer) {
-			ret = ac->ops->create_authorizer(ac,
-						CEPH_ENTITY_TYPE_MDS, auth);
-			if (ret)
-				return ret;
-		}
+	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
+		ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_MDS, auth);
+		if (ret)
+			return ret;
 	}
 
 	*proto = ac->protocol;
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -664,10 +664,10 @@ static void put_osd(struct ceph_osd *osd
 {
 	dout("put_osd %p %d -> %d\n", osd, atomic_read(&osd->o_ref),
 	     atomic_read(&osd->o_ref) - 1);
-	if (atomic_dec_and_test(&osd->o_ref)) {
+	if (atomic_dec_and_test(&osd->o_ref) && osd->o_auth.authorizer) {
 		struct ceph_auth_client *ac = osd->o_osdc->client->monc.auth;
 
-		if (osd->o_auth.authorizer)
+		if (ac->ops && ac->ops->destroy_authorizer)
 			ac->ops->destroy_authorizer(ac, osd->o_auth.authorizer);
 		kfree(osd);
 	}
@@ -2119,10 +2119,11 @@ static int get_authorizer(struct ceph_co
 	int ret = 0;
 
 	if (force_new && auth->authorizer) {
-		ac->ops->destroy_authorizer(ac, auth->authorizer);
+		if (ac->ops && ac->ops->destroy_authorizer)
+			ac->ops->destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (auth->authorizer == NULL) {
+	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
 		ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_OSD, auth);
 		if (ret)
 			return ret;
@@ -2144,6 +2145,10 @@ static int verify_authorizer_reply(struc
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
+	/*
+	 * XXX If ac->ops or ac->ops->verify_authorizer_reply is null,
+	 * XXX which do we do:  succeed or fail?
+	 */
 	return ac->ops->verify_authorizer_reply(ac, o->o_auth.authorizer, len);
 }
 
@@ -2153,7 +2158,7 @@ static int invalidate_authorizer(struct
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
-	if (ac->ops->invalidate_authorizer)
+	if (ac->ops && ac->ops->invalidate_authorizer)
 		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
 
 	return ceph_monc_validate_auth(&osdc->client->monc);


