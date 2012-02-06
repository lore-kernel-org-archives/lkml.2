Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2BFRpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:45:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42176 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BFRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:45:51 -0500
Date: Mon, 6 Feb 2012 17:45:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] hfsplus: Add an ioctl to bless files
Message-ID: <20120206174549.GA1655@srcf.ucam.org>
References: <1328215191-4201-1-git-send-email-mjg@redhat.com>
 <1328215191-4201-2-git-send-email-mjg@redhat.com>
 <20120206173553.GB1135@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206173553.GB1135@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 12:35:53PM -0500, Christoph Hellwig wrote:
> +#define HFSPLUS_IOC_BLESS              _IO('f', 0x20)
> 
> I'd probably move this to fs.h and follow the numbering there,
> otherwise we are bound to run into conflicts.

Ok. Any problem with leaving something filesystem specific in there?

> > +static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
> 
> Care to add a little comment on what this ioctl does, bless is a bit
> of a generic name.

Will do.

> > +{
> > +	struct inode *inode = file->f_dentry->d_inode;
> 
> Please use file->f_path.dentry instead of the f_dentry define, please.

Ok.

> > +	mutex_lock(&sbi->vh_mutex);
> > +	vh->finder_info[0] = bvh->finder_info[0] =
> > +		cpu_to_be32(parent_ino(file->f_dentry));
> > +	vh->finder_info[1] = bvh->finder_info[1] = cpu_to_be32(inode->i_ino);
> > +	vh->finder_info[5] = bvh->finder_info[5] =
> > +		cpu_to_be32(parent_ino(file->f_dentry));
> 
> Any idea why we write the parent twice?

>From the spec:

"finderInfo[0] contains the directory ID of the directory containing the 
bootable system (for example, the System Folder in Mac OS 8 or 9, or 
/System/Library/CoreServices in Mac OS X). It is zero if there is no 
bootable system on the volume. This value is typically equal to either 
finderInfo[3] or finderInfo[5]."

finderInfo[3] is the OS8/9 system folder, finderInfo[5] is the OS X one. 
I'd guess it's just to indicate whether the boot media should default to 
OS8/9 or OS X, but it's not entirely clear.

> Not directly relevant, but where do you plan to put the userspace to
> call this ioctl?

There's a git repo at git://cavan.codon.org.uk/mactel-boot

-- 
Matthew Garrett | mjg59@srcf.ucam.org
