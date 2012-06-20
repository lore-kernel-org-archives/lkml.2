Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2FTSVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab2FTSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:35 -0400
Message-Id: <20120620173022.187381499@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fred Isaman <iisaman@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 14/61] NFSv4: Fix unnecessary delegation returns in nfs4_do_open
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1861,6 +1861,7 @@ static struct nfs4_state *nfs4_do_open(s
 	struct nfs4_state *res;
 	int status;
 
+	fmode &= FMODE_READ|FMODE_WRITE;
 	do {
 		status = _nfs4_do_open(dir, dentry, fmode, flags, sattr, cred, &res);
 		if (status == 0)


