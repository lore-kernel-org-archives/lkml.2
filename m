Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0LOAO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:14:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35257 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab0LOAO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:14:27 -0500
Date: Wed, 15 Dec 2010 11:14:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herb Shiu <herb_shiu@tcloudcomputing.com>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20101215111423.6ba822eb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/mds_client.c between commit
25933abdd8c562182ca6dc9f8c4c2cc8265c3a80 ("ceph: Handle file locks in
replies from the MDS") from Linus' tree and commit
cba1a66d511d46c426ea02c322293b48f3b88cf2 ("ceph: implement DIRLAYOUTHASH
feature to get dir layout from MDS") from the ceph tree.

I fixed it up (hopefully correctly, see below) and can carry this fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ceph/mds_client.c
index 38800ea,bb9ff98..0000000
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@@ -202,38 -212,6 +211,38 @@@ out_bad
  }
  
  /*
 + * parse fcntl F_GETLK results
 + */
 +static int parse_reply_info_filelock(void **p, void *end,
 +                struct ceph_mds_reply_info_parsed *info)
 +{
 +	if (*p + sizeof(*info->filelock_reply) > end)
 +		goto bad;
 +
 +	info->filelock_reply = *p;
 +	*p += sizeof(*info->filelock_reply);
 +
 +	if (unlikely(*p != end))
 +		goto bad;
 +	return 0;
 +
 +bad:
 +	return -EIO;
 +}
 +
 +/*
 + * parse extra results
 + */
 +static int parse_reply_info_extra(void **p, void *end,
-                 struct ceph_mds_reply_info_parsed *info)
++                struct ceph_mds_reply_info_parsed *info, int features)
 +{
 +	if (info->head->op == CEPH_MDS_OP_GETFILELOCK)
 +		return parse_reply_info_filelock(p, end, info);
 +	else
- 		return parse_reply_info_dir(p, end, info);
++		return parse_reply_info_dir(p, end, info, features);
 +}
 +
 +/*
   * parse entire mds reply
   */
  static int parse_reply_info(struct ceph_msg *msg,
@@@ -255,10 -234,10 +265,10 @@@
  			goto out_bad;
  	}
  
 -	/* dir content */
 +	/* extra */
  	ceph_decode_32_safe(&p, end, len, bad);
  	if (len > 0) {
- 		err = parse_reply_info_extra(&p, p+len, info);
 -		err = parse_reply_info_dir(&p, p+len, info, features);
++		err = parse_reply_info_extra(&p, p+len, info, features);
  		if (err < 0)
  			goto out_bad;
  	}
