Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1H0O6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1H0O6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:53 2011
Message-Id: <20110826215053.066597817@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@ZenIV.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [02/35] cifs: demote cERROR in build_path_from_dentry to cFYI
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit fa71f447065f676157ba6a2c121ba419818fc559 upstream.

Running the cthon tests on a recent kernel caused this message to pop
occasionally:

    CIFS VFS: did not end path lookup where expected namelen is 0

Some added debugging showed that namelen and dfsplen were both 0 when
this occurred. That means that the read_seqretry returned true.

Assuming that the comment inside the if statement is true, this should
be harmless and just means that we raced with a rename. If that is the
case, then there's no need for alarm and we can demote this to cFYI.

While we're at it, print the dfsplen too so that we can see what
happened here if the message pops during debugging.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -110,8 +110,8 @@ cifs_bp_rename_retry:
 	}
 	rcu_read_unlock();
 	if (namelen != dfsplen || read_seqretry(&rename_lock, seq)) {
-		cERROR(1, "did not end path lookup where expected namelen is %d",
-			namelen);
+		cFYI(1, "did not end path lookup where expected. namelen=%d "
+			"dfsplen=%d", namelen, dfsplen);
 		/* presumably this is only possible if racing with a rename
 		of one of the parent directories  (we can not lock the dentries
 		above us to prevent this, but retrying should be harmless) */


