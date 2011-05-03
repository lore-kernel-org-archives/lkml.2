Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1ECKzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:55:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1ECKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:55:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: Allow setting of number of raw devices as a module parameter
Date: Tue, 3 May 2011 12:55:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1304029469-19672-1-git-send-email-jack@suse.cz> <201105022144.31612.arnd@arndb.de> <20110502211141.GA14889@quack.suse.cz>
In-Reply-To: <20110502211141.GA14889@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031255.06410.arnd@arndb.de>
X-Provags-ID: V02:K0:O/t4QKVfOZKd/9Y4YernUSms2jsTN1jVFSghwTpBxZv
 ofq4o1KrV1Z55RlLyIJNMbEOpSqVgFlw3t2PmwdaQuPwQFnb3t
 K82yd8qpMs0+9pi8RO/Yfclk6Vwku0jyuEVYHhdhy8tzUXZhz7
 G4JUCgEYb0me4BXvyjUOMm6rPOCi7PKLfM2AycbzAIT2y+WJpW
 XdpF7c7zzkV0scPoRGqdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 May 2011, Jan Kara wrote:
> > 
> > The character device layer uses kobj_lookup internally when opening
> > the device. When you are inside the driver, you can access it through
> > file->f_path.dentry->d_inode->i_cdev, from where you go to your own data
> > structure using container_of.
>
>   OK, but if I don't have the inode of the character device (like in
> RAW_GETBIND case)?

Oh, good point. That doesn't work as easily then. You'd have to use kobj_lookup,
but you can only do that from fs/char_dev.c because otherwise the cdev_map
is not visible.

So you could in theory add a cdev_lookup() function to fs/char_dev.c, but I'm
not sure if that is a good idea if the only user is raw.c. It's probably
not any cleaner than the approach you were suggesting.

Another idea would be to make the array dynamically sized, using some version
of realloc (which doesn't exist for vmalloc today), or to use a more complex
data structure for the lookup, like idr or radix_tree.

	Arnd
