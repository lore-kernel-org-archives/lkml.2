Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab0G3RTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:20 -0400
Received: from kroah.org ([198.145.64.141]:51763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171Ab0G3RTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:06 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:07 2010
Message-Id: <20100730171507.273253718@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>, "Theodore Tso" <tytso@mit.edu>
Subject: [084/165] ext4: Eliminate potential double free on error path
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit d3533d72e7478a61a3e1936956fc825289a2acf4 upstream (as of v2.6.33-rc3)

b_entry_name and buffer are initially NULL, are initialized within a loop
to the result of calling kmalloc, and are freed at the bottom of this loop.
The loop contains gotos to cleanup, which also frees b_entry_name and
buffer.  Some of these gotos are before the reinitializations of
b_entry_name and buffer.  To maintain the invariant that b_entry_name and
buffer are NULL at the top of the loop, and thus acceptable arguments to
kfree, these variables are now set to NULL after the kfrees.

This seems to be the simplest solution.  A more complicated solution
would be to introduce more labels in the error handling code at the end of
the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier E;
expression E1;
iterator I;
statement S;
@@

*kfree(E);
... when != E = E1
    when != I(E,...) S
    when != &E
*kfree(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/xattr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1327,6 +1327,8 @@ retry:
 			goto cleanup;
 		kfree(b_entry_name);
 		kfree(buffer);
+		b_entry_name = NULL;
+		buffer = NULL;
 		brelse(is->iloc.bh);
 		kfree(is);
 		kfree(bs);


