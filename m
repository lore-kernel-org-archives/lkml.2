Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2AZVpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:45:39 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60465
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735Ab2AZVpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:45:38 -0500
Date: Thu, 26 Jan 2012 16:45:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Niels de Vos <ndevos@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device if
 fsync() is called for a partition
Message-ID: <20120126214534.GA9319@infradead.org>
References: <4F213E1A.4060808@redhat.com>
 <1327584802-14298-1-git-send-email-ndevos@redhat.com>
 <20120126134051.6add3cd2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126134051.6add3cd2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 01:40:51PM -0800, Andrew Morton wrote:
> The Right Thing To Do here is to make the kernel behave logically and
> predictably, then modify the userspace tools.  But if we're modifying
> the userspace tools then we would just change userspace to issue a
> BLKFLSBUF to /dev/sda and leave the kernel alone.

The right fix is to make partition and whole disk access coherent,
which is fairly simply:

 - create the block device inode/mapping per gendisk, and only reference
   count it per block_device
 - make sure blkdev_get_block(s) applies the correct offset if used on
   partitions

