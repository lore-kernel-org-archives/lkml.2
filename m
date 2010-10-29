Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab0J2O2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:28:06 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27815 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933902Ab0J2O2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:28:05 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 10:28:04 EDT
Date: Fri, 29 Oct 2010 16:10:26 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211 failure to check kmalloc return value in key_key_read
 could lead to unpleasant surprises
Message-ID: <alpine.LNX.2.00.1010291544510.8123@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed two small issues in mac80211/debugfs_key.c::key_key_read while 
reading through the code. Patch below.

The key_key_read() function returns ssize_t and the value that's actually 
returned is the return value of simple_read_from_buffer() which also 
returns ssize_t, so let's hold the return value in a ssize_t local 
variable rather than a int one.

Also, memory is allocated dynamically with kmalloc() which can fail, but 
the return value of kmalloc() is not checked, so we may end up operating 
on a null pointer further on. So check for a NULL return and bail out with 
-ENOMEM in that case.

Please keep me on CC on replies since I'm not subscribed to 
linux-wireless.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 debugfs_key.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 4aa47d0..1243d1d 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -203,9 +203,13 @@ static ssize_t key_key_read(struct file *file, char __user *userbuf,
 			    size_t count, loff_t *ppos)
 {
 	struct ieee80211_key *key = file->private_data;
-	int i, res, bufsize = 2 * key->conf.keylen + 2;
+	int i, bufsize = 2 * key->conf.keylen + 2;
 	char *buf = kmalloc(bufsize, GFP_KERNEL);
 	char *p = buf;
+	ssize_t res;
+
+	if (!buf)
+		return -ENOMEM;
 
 	for (i = 0; i < key->conf.keylen; i++)
 		p += scnprintf(p, bufsize + buf - p, "%02x", key->conf.key[i]);


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
