Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab1JPODc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 10:03:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37623 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1JPODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 10:03:30 -0400
Subject: Re: [PATCH 1/2] jffs2: implement mount option parsing and
 compression overriding
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Sun, 16 Oct 2011 17:03:00 +0300
In-Reply-To: <20111015125006.685efc30@queued.net>
References: <20111015125006.685efc30@queued.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318773789.7278.7.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please, cc the fs-devel mailing list when you sumbit v2.

On Sat, 2011-10-15 at 12:50 -0700, Andres Salomon wrote:
> Currently jffs2 has compile-time constants (and .config options)
> controlling whether or not the various compression/decompression
> drivers are built in and enabled.  This is fine for embedded
> systems, but it clashes with distribution kernels.  Distro kernels
> tend to turn on everything; this causes OpenFirmware to fall
> over, as it understands ZLIB-compressed inodes.  Booting a kernel
> that has LZO compression enabled, writing to the boot partition,
> and then rebooting causes OFW to fail to read the kernel from
> the filesystem.  This is because LZO compression has priority
> when writing new data to jffs2, if LZO is enabled.
> 
> This patch adds mount option parsing, and a single supported
> option ("compr=none").  This adds the flexibility of being
> able to specify which compressor overrides on a per-superblock
> basis.  For now, we can simply disable compression;
> additional flexibility coming soon.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

You forgot to implement .show_options method of
'struct super_operations' - it is needed to make sure 'compr=none'
is shown when you do 'cat /proc/mounts'.


> +	err = jffs2_parse_options(c, data);
> +	if (err) {
> +		printk(KERN_ERR "JFFS2 error: invalid or unknown mount option\n");

'jffs2_parse_options()' prints the error message, do not duplicate it
please.

> +		return -EINVAL;
> +	}
> +
> +	return jffs2_do_remount_fs(sb, flags, data);
> +}
> +
>  static const struct super_operations jffs2_super_operations =
>  {
>  	.alloc_inode =	jffs2_alloc_inode,
> @@ -166,6 +234,13 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
>  	c->os_priv = sb;
>  	sb->s_fs_info = c;
>  
> +	ret = jffs2_parse_options(c, data);
> +	if (ret) {
> +		printk(KERN_ERR "JFFS2 error: invalid or unknown mount option\n");

Ditto - kill this printk please.


-- 
Best Regards,
Artem Bityutskiy

