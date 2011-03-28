Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1C1IvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:51:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35449 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1C1IvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=RwozV3g67F5XGwtiJFRDWkZBHveZdVwNgABfnmqtpPyZtgBQPn/5piwvW53FxeJzGh
         MX7ZSAZfaba2Espi49rH0DkqUY5C2/m0nppLnnrzSjJ7vUrL++snSrEQl5Z17aE32scd
         wqCf8UW50hsCEB3J8l6qgkvK1XSrNaDqPsurs=
Date: Mon, 28 Mar 2011 11:50:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: serge@hallyn.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -next] ipcns: use after free in free_ipc_ns()
Message-ID: <20110328085048.GI1885@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, serge@hallyn.com,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	David Howells <dhowells@redhat.com>,
	Daniel Lezcano <daniel.lezcano@free.fr>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We dereference "ns" after it has been freed.  This was introduced in
b515498f5bb5 "userns: add a user namespace owner of ipc ns".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 3c3e522..8054c8e 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -104,7 +104,6 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
-	kfree(ns);
 	atomic_dec(&nr_ipc_ns);
 
 	/*
@@ -113,6 +112,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	 */
 	ipcns_notify(IPCNS_REMOVED);
 	put_user_ns(ns->user_ns);
+	kfree(ns);
 }
 
 /*
