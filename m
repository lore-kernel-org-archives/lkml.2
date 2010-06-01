Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0FAIXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:23:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63559 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab0FAIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=bAkKFHMqn7ZhBG9Q//mCBw7ZSFk4lirThE84BetCYC8of8aKuTC6nxHoG1KsIEw8k9
         1Xvayj4d6a5edrX7uKFlMB6SkS11Ys+FHys3HltUfxtt+XqquB2A4R49PimNSfFwsna7
         yOCkr/qCaqWs1lAGud+F/GZB3t80lbhxhmqGs=
Date: Tue, 1 Jun 2010 10:23:11 +0200
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] btrfs: uninitialized data is check_path_shared()
Message-ID: <20100601082311.GM5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refs can be used with uninitialized data if btrfs_lookup_extent_info()
fails on the first pass through the loop.  In the original code if that
happens then check_path_shared() probably returns 1, but with this patch
it will continue through the loop.

I'm not super familiar with this code so please look it over carefully.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fa6ccc1..9640dae 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2673,7 +2673,7 @@ static int check_path_shared(struct btrfs_root *root,
 	struct extent_buffer *eb;
 	int level;
 	int ret;
-	u64 refs;
+	u64 refs = 0;
 
 	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
 		if (!path->nodes[level])
