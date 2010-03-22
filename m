Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0CVNrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab0CVNrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:47:36 -0400
Date: Mon, 22 Mar 2010 09:47:21 -0400
From: Josef Bacik <josef@redhat.com>
To: Dan Carpenter <error27@gmail.com>, chris.mason@oracle.com,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: locking problems: Btrfs: be more selective in the defrag ioctl
Message-ID: <20100322134720.GA2383@localhost.localdomain>
References: <20100320113851.GB5331@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100320113851.GB5331@bicker>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 02:38:51PM +0300, Dan Carpenter wrote:
> Hi Chris,
> 
> There is a locking problem in 
> 	940100a4a7b78 "Btrfs: be more selective in the defrag ioctl"
> 
> There are two places where we break out of the while loop under the 
> lock.
> 
> fs/btrfs/ioctl.c +708 btrfs_defrag_file(159) error: double lock 'mutex:&inode->i_mutex'
>    600                  mutex_lock(&inode->i_mutex);
>    601                  if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
>    602                          BTRFS_I(inode)->force_compress = 1;
>    603  
>    604                  ret = btrfs_check_data_free_space(root, inode, PAGE_CACHE_SIZE);
>    605                  if (ret) {
>    606                          ret = -ENOSPC;
>    607                          break;
> 
> 	Here.
> 
>    608                  }
>    609  
>    610                  ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
>    611                  if (ret) {
>    612                          btrfs_free_reserved_data_space(root, inode,
>    613                                                         PAGE_CACHE_SIZE);
>    614                          ret = -ENOSPC;
>    615                          break;
> 
> 	And here.
> 
>    616                  }
> 
> Maybe we should have "goto err_reservations;" instead of break?  I
> don't know the code well enough to say.

No, everything is accounted for correctly.  If the metadata reservation fails,
we free the data space reservation and break.  If the data space reservation
fails, we're good to go and can just exit.  Thanks,

Josef
