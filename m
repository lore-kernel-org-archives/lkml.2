Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab1CCR34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:29:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26099 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab1CCR3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:29:54 -0500
MIME-Version: 1.0
Message-ID: <763a2305-27c6-4f44-8962-db72b434c037@default>
Date: Thu, 3 Mar 2011 09:29:04 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Matt <jackdachef@gmail.com>, gregkh@suse.de,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@redhat.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Yan Zheng <zheng.z.yan@intel.com>, miaox@cn.fujitsu.com,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: RE: [PATCH V2 0/3] drivers/staging: zcache: dynamic page cache/swap
 compression
References: <20110207032407.GA27404@ca-server1.us.oracle.com>
 <1ddd01a8-591a-42bc-8bb3-561843b31acb@default>
 <AANLkTimFATx-gYVgY_pVdZsySSBmXvKFkhTJUeVFBcop@mail.gmail.com>
 <AANLkTimqSSxHrLhL9t4DOmDeuAA41B9e-qnr+vnUsucL@mail.gmail.com>
 <AANLkTi=4QkV4wtMmDd6+XXhvkva+fq9m5PVYGC0qBUc3@mail.gmail.com>
 <AANLkTimOssgM7JYSpwB=5zmF_JJ2ByH+PWO7N+YZNB_y@mail.gmail.com>
 <e647042e-419e-4e61-a563-e489596bd659@default
 AANLkTim_U+mJtHk7drvqMOmUwd4ro8J0dazZMDsNqH=o@mail.gmail.com>
In-Reply-To: <AANLkTim_U+mJtHk7drvqMOmUwd4ro8J0dazZMDsNqH=o@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D6FCFFC.01E5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I definitely see a bug in cleancache_get_key in the monolithic
> > zcache+cleancache+frontswap patch I posted on oss.oracle.com
> > that is corrected in linux-next but I don't see how it could
> > get provoked by btrfs.
> >
> > The bug is that, in cleancache_get_key, the return value of fhfn
> should
> > be checked against 255.  If the return value is 255,
> cleancache_get_key
> > should return -1.  This should disable cleancache for any filesystem
> > where KEY_MAX is too large.
> >
> > But cleancache_get_key always calls fhfn with connectable == 0 and
> > CLEANCACHE_KEY_MAX==6 should be greater than
> BTRFS_FID_SIZE_CONNECTABLE
> > (which I think should be 5?).  And the elements written into the
> > typecast btrfs_fid should be only writing the first 5 32-bit words.
> 
> BTRFS_FID_SIZE_NON_CONNECTALBE is 5,  not BTRFS_FID_SIZE_CONNECTABLE.
> Anyway, you passed connectable with 0 so it should be only writing the
> first 5 32-bit words as you said.
> That's one I missed. ;-)
> 
> Thanks.
> --
> Kind regards,
> Minchan Kim

Sorry, I realized that I solved this with Matt offlist and never
posted the solution on-list, so for the archives:

This patch applies on top of the cleancache patch.  It is really
a horrible hack but solving it correctly requires the interface
to encode_fh ops to change, which would require changes to many
filesystems, so best saved for a later time.  If/when cleancache
gets merged, this patch will need to be applied on top of it
for btrfs to work properly when cleancache is enabled.

Basically, the problem is that, in all current filesystems,
obtaining the filehandle requires a dentry ONLY if connectable
is set.  Otherwise, the dentry is only used to get the inode.
But cleancache_get_key only has an inode, and the alias list
of dentries associated with the inode may be empty.  So
either the encode_fh interface would need to be changed
or, in this hack-y solution, a dentry is created temporarily
only for the purpose of dereferencing it.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff -Napur -X linux-2.6.37.1/Documentation/dontdiff linux-2.6.37.1/mm/cleancache.c linux-2.6.37.1-fix/mm/cleancache.c
--- linux-2.6.37.1/mm/cleancache.c	2011-02-25 11:38:47.000000000 -0800
+++ linux-2.6.37.1-fix/mm/cleancache.c	2011-02-25 08:53:46.000000000 -0800
@@ -78,15 +78,14 @@ static int cleancache_get_key(struct ino
 	int (*fhfn)(struct dentry *, __u32 *fh, int *, int);
 	int maxlen = CLEANCACHE_KEY_MAX;
 	struct super_block *sb = inode->i_sb;
-	struct dentry *d;
 
 	key->u.ino = inode->i_ino;
 	if (sb->s_export_op != NULL) {
 		fhfn = sb->s_export_op->encode_fh;
 		if  (fhfn) {
-			d = list_first_entry(&inode->i_dentry,
-						struct dentry, d_alias);
-			(void)(*fhfn)(d, &key->u.fh[0], &maxlen, 0);
+			struct dentry d;
+			d.d_inode = inode;
+			(void)(*fhfn)(&d, &key->u.fh[0], &maxlen, 0);
 			if (maxlen > CLEANCACHE_KEY_MAX)
 				return -1;
 		}
