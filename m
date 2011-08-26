Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1H0PBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:01:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1H0O7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215053.906092135@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [10/35] NFSv4.1: Return NFS4ERR_BADSESSION to callbacks during session resets
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 910ac68a2b80c7de95bc8488734067b1bb15d583 upstream.

If the client is in the process of resetting the session when it receives
a callback, then returning NFS4ERR_DELAY may cause a deadlock with the
DESTROY_SESSION call.

Basically, if the client returns NFS4ERR_DELAY in response to the
CB_SEQUENCE call, then the server is entitled to believe that the
client is busy because it is already processing that call. In that
case, the server is perfectly entitled to respond with a
NFS4ERR_BACK_CHAN_BUSY to any DESTROY_SESSION call.

Fix this by having the client reply with a NFS4ERR_BADSESSION in
response to the callback if it is resetting the session.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/callback_proc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -437,6 +437,11 @@ __be32 nfs4_callback_sequence(struct cb_
 	if (test_bit(NFS4_SESSION_DRAINING, &clp->cl_session->session_state)) {
 		spin_unlock(&tbl->slot_tbl_lock);
 		status = htonl(NFS4ERR_DELAY);
+		/* Return NFS4ERR_BADSESSION if we're draining the session
+		 * in order to reset it.
+		 */
+		if (test_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state))
+			status = htonl(NFS4ERR_BADSESSION);
 		goto out;
 	}
 


