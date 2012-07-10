Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2GJQE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:04:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab2GJQEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:04:55 -0400
Date: Tue, 10 Jul 2012 18:04:52 +0200
From: Jan Kara <jack@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: Re: [ 26/48] udf: Avoid run away loop when partition table length
 is corrupted
Message-ID: <20120710160452.GB19005@quack.suse.cz>
References: <20120709143116.348975190@decadent.org.uk>
 <20120709143120.461951078@decadent.org.uk>
 <20120710155226.GH1894@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20120710155226.GH1894@decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 10-07-12 16:52:26, Ben Hutchings wrote:
> On Mon, Jul 09, 2012 at 03:31:42PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.
> > 
> > Check provided length of partition table so that (possibly maliciously)
> > corrupted partition table cannot cause accessing data beyond current buffer.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  fs/udf/super.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/udf/super.c b/fs/udf/super.c
> > index 9da6f4e..ce911f5 100644
> > --- a/fs/udf/super.c
> > +++ b/fs/udf/super.c
> [...]
> > @@ -1232,13 +1233,20 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
> >  		return 1;
> >  	BUG_ON(ident != TAG_IDENT_LVD);
> >  	lvd = (struct logicalVolDesc *)bh->b_data;
> > +	table_len = le32_to_cpu(lvd->mapTableLength);
> > +	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
> [...]
> 
> I don't think this is sufficient, unless there has been some prior
> validation of lvd->mapTableLength.  On a 32-bit machine, the addition
> may overflow.  The untrusted value has to be validated before doing
> any arithmetic on it, e.g.:
> 
> 	if (table_len > sb->s_blocksize - sizeof(*lv)) {
  Yeah, thanks for spotting this! I've queued the attached patch. I don't
find this really pressing so I'll push it in the next merge window. OK?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--3V7upXqbjpZ4EhLz
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-udf-Improve-table-length-check-to-avoid-possible-ove.patch"

>From 57b9655d01ef057a523e810d29c37ac09b80eead Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 10 Jul 2012 17:58:04 +0200
Subject: [PATCH] udf: Improve table length check to avoid possible overflow

When a partition table length is corrupted to be close to 1 << 32, the
check for its length may overflow on 32-bit systems and we will think
the length is valid. Later on the kernel can crash trying to read beyond
end of buffer. Fix the check to avoid possible overflow.

CC: stable@vger.kernel.org
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8a75838..dcbf987 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1340,7 +1340,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	BUG_ON(ident != TAG_IDENT_LVD);
 	lvd = (struct logicalVolDesc *)bh->b_data;
 	table_len = le32_to_cpu(lvd->mapTableLength);
-	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
+	if (table_len > sb->s_blocksize - sizeof(*lvd)) {
 		udf_err(sb, "error loading logical volume descriptor: "
 			"Partition table too long (%u > %lu)\n", table_len,
 			sb->s_blocksize - sizeof(*lvd));
-- 
1.7.1


--3V7upXqbjpZ4EhLz--
