Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab0I2UTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:19:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45983 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab0I2UTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=j3KJN+FywYqZjm902PUajYcYpEkMOMWuq+7YMufcYfGP+zzwbuecHJT4BEmTOPPyYs
         Ovs0jTeyEOB3cWKd+A8vRjz9OqbzTenewru4R0uBDcifug27dKkenluC6zFDaW+n9YnL
         HhaEie6k5Phn1y6C4wzPZki8zneo2zyryfikI=
Message-ID: <4CA3BBAD.8080207@gmail.com>
Date: Thu, 30 Sep 2010 00:20:29 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Btrfs: Don't dereference extent_mapping if NULL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't dereference em if it's NULL or an error pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I just noticed this by code analysis. It wasn't tested in any way.

 fs/btrfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..d4a37f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1787,7 +1787,8 @@ static int btrfs_io_failed_hook(struct bio *failed_bio,
 
 		read_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, start, failrec->len);
-		if (em->start > start || em->start + em->len < start) {
+		if (em && !IS_ERR(em) && (em->start > start ||
+					em->start + em->len < start)) {
 			free_extent_map(em);
 			em = NULL;
 		}
