Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2ACMiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 07:38:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab2ACMit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 07:38:49 -0500
Date: Tue, 3 Jan 2012 13:38:41 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "'Jan Kara'" <jack@suse.cz>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, haiyangz@microsoft.com,
        hjanssen@microsoft.com, "'Mimi Zohar'" <zohar@linux.vnet.ibm.com>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>, James Morris <jmorris@namei.org>,
        Jorge Bastos <mysql.jorge@decimal.pt>
Subject: Re: Reiserfs.c bug in 3.2-rc5
Message-ID: <20120103123841.GA31457@quack.suse.cz>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
 <20111213180707.GI11747@quack.suse.cz>
 <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
 <20120102115222.GA3626@quack.suse.cz>
 <005301ccc998$201c9da0$6055d8e0$@jorge@decimal.pt>
 <20120103010826.GF3626@quack.suse.cz>
 <000701ccc9fa$74df73f0$5e9e5bd0$@jorge@decimal.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000701ccc9fa$74df73f0$5e9e5bd0$@jorge@decimal.pt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hell,

On Tue 03-01-12 09:31:22, Jorge Bastos wrote:
> >   Yes, thanks! So we see that reiserfs_security_init() returned bogus
> >   number 790797. This is caused by security_old_inode_init_security()
> >   either returning some bogus number or setting sec->length to
> >   something bogus.  In any case it's some security module problem so
> >   I'm adding Mimi Zohar who did the changes in this code recently to
> >   CC. I'm also adding Rafael since this is a regression.
> > 
> >   Also I think he might use your kernel config so can you please send
> > it?
> > Thanks.
> 
> Sure,
> Please grab it here:
> 
> http://neotrix.decimal.pt/bugs/config-3.2-rc7.txt 
> 
> Let me know when the fix gets commited git master.
  Thanks! So I've managed to reproduce the problem and I now understand
what is the problem. Commit 1e39f384bb01b0395b69cb70c2cacae65012f203 makes
security_old_inode_init_security() return 0 when CONFIG_SECURITY is not
set. But that makes caller such as reiserfs_security_init() assume that
security_old_inode_init_security() has set name, value, and len arguments
properly (which is IMO correct assumption). But they were left
uninitialized which makes things break in an interesting ways... The fix is
below.

Mimi, James, Linus, this patch fixes a regression from 3.1 and should make
it to 3.2 if possible.

								Honza
----

>From 5bcd17065fa27d5f27756e24a98331f796ff2481 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 3 Jan 2012 13:14:29 +0100
Subject: [PATCH] security: Fix security_old_inode_init_security() when CONFIG_SECURITY is not set

Commit 1e39f384bb01b0395b69cb70c2cacae65012f203 makes
security_old_inode_init_security() return 0 when CONFIG_SECURITY is not set.
But that makes callers such as reiserfs_security_init() assume that
security_old_inode_init_security() has set name, value, and len arguments
properly. But security_old_inode_init_security() left them uninitialized
which then results in interesting failures.

Revert security_old_inode_init_security() to the old behavior of returning
EOPNOTSUPP since both callers (reiserfs and ocfs2) handle this just fine.

Reported-by: Jorge Bastos <mysql.jorge@decimal.pt>
CC: James Morris <jmorris@namei.org>
CC: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/security.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 19d8e04..e8c619d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2056,7 +2056,7 @@ static inline int security_old_inode_init_security(struct inode *inode,
 						   char **name, void **value,
 						   size_t *len)
 {
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int security_inode_create(struct inode *dir,
-- 
1.7.1

