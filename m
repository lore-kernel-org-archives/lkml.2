Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2FQS27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:28:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50339 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757959Ab2FQSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:54 -0400
Message-Id: <20120617175946.552500752@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Fred Isaman <iisaman@netapp.com>
Subject: [ 37/69] NFSv4: Fix unnecessary delegation returns in nfs4_do_open
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2d0dbc6ae8a5194aaecb9cfffb9053f38fce8b86 upstream.

While nfs4_do_open() expects the fmode argument to be restricted to
combinations of FMODE_READ and FMODE_WRITE, both nfs4_atomic_open()
and nfs4_proc_create will pass the nfs_open_context->mode,
which contains the full fmode_t.

This patch ensures that nfs4_do_open strips the other fmode_t bits,
fixing a problem in which the nfs4_do_open call would result in an
unnecessary delegation return.

Reported-by: Fred Isaman <iisaman@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1825,6 +1825,7 @@
 	struct nfs4_state *res;
 	int status;
 
+	fmode &= FMODE_READ|FMODE_WRITE;
 	do {
 		status = _nfs4_do_open(dir, dentry, fmode, flags, sattr, cred, &res);
 		if (status == 0)


