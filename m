Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0G3RDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:03:38 -0400
Received: from kroah.org ([198.145.64.141]:35496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0G3RDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:31 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:54 2010
Message-Id: <20100730165954.122456275@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>
Subject: [03/17] cifs: remove bogus first_time check in NTLMv2 session setup code
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 8a224d489454b7457105848610cfebebdec5638d upstream.

This bug appears to be the result of a cut-and-paste mistake from the
NTLMv1 code. The function to generate the MAC key was commented out, but
not the conditional above it. The conditional then ended up causing the
session setup key not to be copied to the buffer unless this was the
first session on the socket, and that made all but the first NTLMv2
session setup fail.

Fix this by removing the conditional and all of the commented clutter
that made it difficult to see.

Reported-by: Gunther Deschner <gdeschne@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/sess.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -482,15 +482,7 @@ CIFS_SessSetup(unsigned int xid, struct
 
 		/* calculate session key */
 		setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
-		if (first_time) /* should this be moved into common code
-				   with similar ntlmv2 path? */
-		/*   cifs_calculate_ntlmv2_mac_key(ses->server->mac_signing_key,
-				response BB FIXME, v2_sess_key); */
-
-		/* copy session key */
-
-	/*	memcpy(bcc_ptr, (char *)ntlm_session_key,LM2_SESS_KEY_SIZE);
-		bcc_ptr += LM2_SESS_KEY_SIZE; */
+		/* FIXME: calculate MAC key */
 		memcpy(bcc_ptr, (char *)v2_sess_key,
 		       sizeof(struct ntlmv2_resp));
 		bcc_ptr += sizeof(struct ntlmv2_resp);


