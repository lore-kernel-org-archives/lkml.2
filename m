Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0ENBEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 21:04:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:58401 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab0ENBEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 21:04:45 -0400
Subject: Re: [PATCH v4] mtd: Do not corrupt backing device of device node
 inode
From: David Woodhouse <dwmw2@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1273074054-11849-1-git-send-email-kirill@shutemov.name>
References: <1273074054-11849-1-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 02:04:34 +0100
Message-ID: <1273799074.9999.653.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 18:40 +0300, Kirill A. Shutemov wrote:
> We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> backing device of device node inode, since file->f_mapping is equal to
> inode->i_mapping (see __dentry_open() in fs/open.c).
> 
> Let's introduce separate inode for MTD device with appropriate backing
> device.

I hate the fact that we have to do this -- is it really the only option?

Is it _just_ for the backing_device_info? Can't that be done
differently?

> @@ -85,11 +88,27 @@ static int mtd_open(struct inode *inode, struct file *file)
>  		goto out;
>  	}
>  
> -	if (mtd->backing_dev_info)
> -		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
> +	if (!mtd->inode) {
> +		mtd->inode = new_inode(mtd_inode_mnt->mnt_sb);

I believe that would be a race condition, if it wasn't for the BKL.

And what happens when you close the chardevice and call iput() on the
inode so it's destroyed, and then you re-open the device? You never set
mtd->inode = NULL, so won't it now try to igrab a stale pointer?

You won't have seen this in your testing unless you made it prune the
icache between the close and open calls.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

