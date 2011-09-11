Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab1IKLZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 07:25:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46782 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1IKLZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 07:25:53 -0400
Date: Sun, 11 Sep 2011 12:25:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] xip: use i_mutex for xip_file_fault
Message-ID: <20110911112552.GB2203@ZenIV.linux.org.uk>
References: <4E6B82DB.50803@gmail.com>
 <20110910155639.GY2203@ZenIV.linux.org.uk>
 <4E6C705F.8010101@gmail.com>
 <20110911111504.GA2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911111504.GA2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 12:15:04PM +0100, Al Viro wrote:

> write() grabs ->i_mutex on the file it's going to write to.  It uses
> copy_from_user() while holding ->i_mutex; that can end up calling ->fault().
> If your data comes from the same file mmapped in your address space, you
> have xip_write_fault() called while you are in xip_file_write() and *already*
> are holding ->i_mutex on the same inode.  With your patch it will, AFAICS,
> cheerfully deadlock.

Oh, wait...  You are only doing that to write side of pagefault?  That's
better, but not much:

thread 1: mmap the file, modify mapping
thread 2: write() to file

The former will do xip_write_fault() while holding ->mmap_sem.
The latter will do copy_from_user() from xip_file_write(), getting
pagefaults while holding ->i_mutex.

Note that we are grabbing ->mmap_sem and ->i_mutex in opposite orders.
I.e. that will deadlock on you - all you need is threads sharing the
address space.
