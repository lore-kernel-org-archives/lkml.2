Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1HCX2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:28:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab1HCX15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:46 2011
Message-Id: <20110803221246.626130921@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [026/102] CIFS: Fix oops while mounting with prefixpath
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Shilovsky <piastryyy@gmail.com>

commit f5bc1e755d23d022bf948904386337fc3e5e29a8 upstream.

commit fec11dd9a0109fe52fd631e5c510778d6cbff6cc caused
a regression when we have already mounted //server/share/a
and want to mount //server/share/a/b.

The problem is that lookup_one_len calls __lookup_hash
with nd pointer as NULL. Then __lookup_hash calls
do_revalidate in the case when dentry exists and we end
up with NULL pointer deference in cifs_d_revalidate:

if (nd->flags & LOOKUP_RCU)
	return -ECHILD;

Fix this by checking nd for NULL.

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
Reviewed-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -641,7 +641,7 @@ lookup_out:
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	if (nd->flags & LOOKUP_RCU)
+	if (nd && (nd->flags & LOOKUP_RCU))
 		return -ECHILD;
 
 	if (direntry->d_inode) {


