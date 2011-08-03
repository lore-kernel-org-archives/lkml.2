Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab1HCXaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:30:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab1HCX3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:29:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:51 2011
Message-Id: <20110803221251.874995413@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gnb@fmeh.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [078/102] svcrpc: fix list-corrupting race on nfsd shutdown
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit ebc63e531cc6a457595dd110b07ac530eae788c3 upstream.

After commit 3262c816a3d7fb1eaabce633caa317887ed549ae "[PATCH] knfsd:
split svc_serv into pools", svc_delete_xprt (then svc_delete_socket) no
longer removed its xpt_ready (then sk_ready) field from whatever list it
was on, noting that there was no point since the whole list was about to
be destroyed anyway.

That was mostly true, but forgot that a few svc_xprt_enqueue()'s might
still be hanging around playing with the about-to-be-destroyed list, and
could get themselves into trouble writing to freed memory if we left
this xprt on the list after freeing it.

(This is actually functionally identical to a patch made first by Ben
Greear, but with more comments.)

Cc: gnb@fmeh.org
Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svc_xprt.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -902,12 +902,13 @@ void svc_delete_xprt(struct svc_xprt *xp
 	if (!test_and_set_bit(XPT_DETACHED, &xprt->xpt_flags))
 		list_del_init(&xprt->xpt_list);
 	/*
-	 * We used to delete the transport from whichever list
-	 * it's sk_xprt.xpt_ready node was on, but we don't actually
-	 * need to.  This is because the only time we're called
-	 * while still attached to a queue, the queue itself
-	 * is about to be destroyed (in svc_destroy).
+	 * The only time we're called while xpt_ready is still on a list
+	 * is while the list itself is about to be destroyed (in
+	 * svc_destroy).  BUT svc_xprt_enqueue could still be attempting
+	 * to add new entries to the sp_sockets list, so we can't leave
+	 * a freed xprt on it.
 	 */
+	list_del_init(&xprt->xpt_ready);
 	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
 		serv->sv_tmpcnt--;
 	spin_unlock_bh(&serv->sv_lock);


