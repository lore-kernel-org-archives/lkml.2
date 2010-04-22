Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0DVLJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:09:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:52048 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0DVLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:09:03 -0400
Subject: Re: [PATCH] mtd: Do not corrupt backing device for inode
From: David Woodhouse <dwmw2@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1271863269-5423-1-git-send-email-kirill@shutemov.name>
References: <20100415172300.GF3561@quack.suse.cz>
	 <1271863269-5423-1-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 12:08:55 +0100
Message-ID: <1271934535.11751.1550.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 18:21 +0300, Kirill A. Shutemov wrote:
> +		/*
> +		 * We cannot modify file->f_mapping->backing_dev_info directly,
> +		 * because it will corrupt backing device for inode, since
> +		 * inode->i_mapping is equal to file->f_mapping. So we have to
> +		 * copy f_mapping first.
> +		 */
> +		file->f_mapping = kmalloc(sizeof(*file->f_mapping), GFP_KERNEL);
> +		memcpy(file->f_mapping, inode->i_mapping,
> +				sizeof(*file->f_mapping));
>  		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
> +	}

Ick. What about the rest of file->f_mapping? That'll still be inherited.

Jan pointed at drivers/char/raw.c as an example, but that doesn't do
anything as ugly as this -- that sets file->f_mapping to point at
bdev->bd_inode->i_mapping instead.

I suspect we should do something similar -- have an inode for the MTD
device, with a valid i_data of its own.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

