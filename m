Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0CTLjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:39:04 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38959 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0CTLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=in/ds0SjLxCYbgBj24skPh7FNCJ9nTWGL9AnUNxHFAh/k8eGrkw5CE0z6Hdj7u1RNj
         NS6YADfWbFE5rQDUCZfjAgoiRWvyo0PVuwzR+x8QoCLw8HnFqGfcUPXeZIB4XmjYFvKh
         2EQ8TcBf1BtaiuxhUkz/r3Nqg41f5XEGIN4KU=
Date: Sat, 20 Mar 2010 14:38:51 +0300
From: Dan Carpenter <error27@gmail.com>
To: chris.mason@oracle.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: locking problems: Btrfs: be more selective in the defrag ioctl
Message-ID: <20100320113851.GB5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

There is a locking problem in 
	940100a4a7b78 "Btrfs: be more selective in the defrag ioctl"

There are two places where we break out of the while loop under the 
lock.

fs/btrfs/ioctl.c +708 btrfs_defrag_file(159) error: double lock 'mutex:&inode->i_mutex'
   600                  mutex_lock(&inode->i_mutex);
   601                  if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
   602                          BTRFS_I(inode)->force_compress = 1;
   603  
   604                  ret = btrfs_check_data_free_space(root, inode, PAGE_CACHE_SIZE);
   605                  if (ret) {
   606                          ret = -ENOSPC;
   607                          break;

	Here.

   608                  }
   609  
   610                  ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
   611                  if (ret) {
   612                          btrfs_free_reserved_data_space(root, inode,
   613                                                         PAGE_CACHE_SIZE);
   614                          ret = -ENOSPC;
   615                          break;

	And here.

   616                  }

Maybe we should have "goto err_reservations;" instead of break?  I
don't know the code well enough to say.

regards,
dan carpenter
