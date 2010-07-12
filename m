Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0GLK7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:59:07 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54817 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0GLK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:59:04 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V16 07/12] vfs: Support null pathname in linkat
In-Reply-To: <E1OYE1D-0005qC-AI@pomaz-ex.szeredi.hu>
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1OYE1D-0005qC-AI@pomaz-ex.szeredi.hu>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Mon, 12 Jul 2010 16:28:53 +0530
Message-ID: <87aapxyniq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 10:05:39 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> > This enables to use linkat to create hardlinks from a
> > file descriptor pointing to the file. This can be used
> > with open_by_handle syscall that returns a file descriptor.
> 
> This needs more thought, filesystems don't usually tolerate
> resurrecting a file which has already been unlinked (i_nlink == 0).
> 

We get -ENOENT error when we do that on ext*

open("test", O_RDONLY)                  = 3
unlink("test")                          = 0
linkat(3, NULL, AT_FDCWD, "test3", 0)   = -1 ENOENT (No such file or directory)

ext4_link does the below

/*
 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
 * otherwise has the potential to corrupt the orphan inode list.
 */
if (inode->i_nlink == 0)
	return -ENOENT;

I can move this check to VFS so that we do it for all file systems. 

-aneesh
