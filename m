Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0ENAHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:07:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57208 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0ENAHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:07:50 -0400
Date: Fri, 14 May 2010 10:07:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cheng Renquan <crquan@gmail.com>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20100514100747.42445cdf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/super.c between commit 5dfc589a8467470226feccdc50f1b32713318e7b
("ceph: unregister bdi before kill_anon_super releases device name") from
Linus' tree and commits 9f2a2a1faa0fd990d4930605583a67d7dff28bff ("ceph:
use ceph_sb_to_client instead of ceph_client") and
c72b09ba224e6f2c00bcf810a0a62059fcf405f7 ("ceph: name bdi ceph-%d instead
of major:minor") from the ceph tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ceph/super.c
index 110857b,30fa891..0000000
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@@ -8,14 -8,10 +8,11 @@@
  #include <linux/module.h>
  #include <linux/mount.h>
  #include <linux/parser.h>
- #include <linux/rwsem.h>
  #include <linux/sched.h>
  #include <linux/seq_file.h>
 +#include <linux/slab.h>
  #include <linux/statfs.h>
  #include <linux/string.h>
- #include <linux/version.h>
- #include <linux/vmalloc.h>
  
  #include "decode.h"
  #include "super.h"
@@@ -893,9 -910,8 +921,10 @@@ static int ceph_register_bdi(struct sup
  		client->backing_dev_info.ra_pages =
  			(client->mount_args->rsize + PAGE_CACHE_SIZE - 1)
  			>> PAGE_SHIFT;
- 	err = bdi_register_dev(&client->backing_dev_info, sb->s_dev);
+ 	err = bdi_register(&client->backing_dev_info, NULL, "ceph-%d",
+ 			   atomic_long_inc_return(&bdi_seq));
 +	if (!err)
 +		sb->s_bdi = &client->backing_dev_info;
  	return err;
  }
  
