Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0GZPzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:55:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab0GZPzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:55:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1280157768.3569.14.camel@localhost>
References: <1280157768.3569.14.camel@localhost> <1279944664.2944.8.camel@localhost> <20100722175847.5552.11520.stgit@warthog.procyon.org.uk> <17723.1279897759@redhat.com> <9168.1280153997@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Add a dentry op to handle automounting rather than abusing follow_link() [ver #2]
Date: Mon, 26 Jul 2010 16:54:55 +0100
Message-ID: <30118.1280159695@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> wrote:

> > Does it make autofs easier if d_op->d_automount() is allowed to return
> > -EXDEV to request this?  Then you can return it in Oz mode to allow the
> > daemon to see/use the underlying mountpoint without recursing back into
> > d_automount().
> 
> Yes, it's really useful.

I think what's required, then, is if d_automount() returns -EXDEV then:

 (1) If the dentry is terminal in the lookup path, then we just return -EXDEV
     to indicate to __follow_mount() that we really do want to stop there.

 (2) If the dentry is not terminal, then we convert the error to -EREMOTE to
     indicate that we can't complete the pathwalk as one of the earlier
     components is inaccessible.

See the attached patch.

David
---
diff --git a/fs/namei.c b/fs/namei.c
index c154112..6c385d4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -653,8 +653,20 @@ static int follow_automount(struct path *path, unsigned flags, int res)
 		return -ELOOP;
 
 	mnt = path->dentry->d_op->d_automount(path);
-	if (IS_ERR(mnt))
+	if (IS_ERR(mnt)) {
+		/*
+		 * The filesystem is allowed to return -EXDEV here to indicate
+		 * they don't want to automount.  For instance, autofs would do
+		 * this so that its userspace daemon can mount on this dentry.
+		 *
+		 * However, we can only permit this if it's a terminal point in
+		 * the path being looked up; if it wasn't then the remainder of
+		 * the path is inaccessible and we should say so.
+		 */
+		if (PTR_ERR(mnt) == -EXDEV && (flags & LOOKUP_CONTINUE))
+			return -EREMOTE;
 		return PTR_ERR(mnt);
+	}
 	if (!mnt) /* mount collision */
 		return 0;
 

