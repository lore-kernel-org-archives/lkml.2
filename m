Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0EGJFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:05:45 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44767 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0EGJFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=gMH68+kWVmAgqwFN14/7Q78L0zy13ZG2aZpJFDcigu1W3I5g458A+JoFwtGMsdBOnU
         BtoC5bteAP6+6X4UBNX4fZeBC6fxhgBUVd3ypHld0Q8I5P1NY3SINx2n3IgewwVK6jWH
         5biTX9IxPG+hpoFjvfSjdyK11piruamNtk3zA=
Date: Fri, 7 May 2010 11:05:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Avishay Traeger <avishay@gmail.com>,
       osd-dev@open-osd.org, linux-kernel@vger.kernel.org
Subject: [patch] exofs: confusion between kmap() and kmap_atomic() api
Message-ID: <20100507090532.GD27064@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Benny Halevy <bhalevy@panasas.com>,
	Avishay Traeger <avishay@gmail.com>, osd-dev@open-osd.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For kmap_atomic() we call kunmap_atomic() on the returned pointer.
That's different from kmap() and kunmap() and so it's easy to get them
backwards.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index 4cfab1c..d91e9d8 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -608,7 +608,7 @@ int exofs_make_empty(struct inode *inode, struct inode *parent)
 	de->inode_no = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, PARENT_DIR, sizeof(PARENT_DIR));
 	exofs_set_de_type(de, inode);
-	kunmap_atomic(page, KM_USER0);
+	kunmap_atomic(kaddr, KM_USER0);
 	err = exofs_commit_chunk(page, 0, chunk_size);
 fail:
 	page_cache_release(page);
