Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2GJPwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:52:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48648 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab2GJPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:52:31 -0400
Date: Tue, 10 Jul 2012 16:52:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Message-ID: <20120710155226.GH1894@decadent.org.uk>
References: <20120709143116.348975190@decadent.org.uk>
 <20120709143120.461951078@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709143120.461951078@decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 26/48] udf: Avoid run away loop when partition table length
 is corrupted
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:31:42PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jan Kara <jack@suse.cz>
> 
> commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.
> 
> Check provided length of partition table so that (possibly maliciously)
> corrupted partition table cannot cause accessing data beyond current buffer.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  fs/udf/super.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 9da6f4e..ce911f5 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
[...]
> @@ -1232,13 +1233,20 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
>  		return 1;
>  	BUG_ON(ident != TAG_IDENT_LVD);
>  	lvd = (struct logicalVolDesc *)bh->b_data;
> +	table_len = le32_to_cpu(lvd->mapTableLength);
> +	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
[...]

I don't think this is sufficient, unless there has been some prior
validation of lvd->mapTableLength.  On a 32-bit machine, the addition
may overflow.  The untrusted value has to be validated before doing
any arithmetic on it, e.g.:

	if (table_len > sb->s_blocksize - sizeof(*lv)) {

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
