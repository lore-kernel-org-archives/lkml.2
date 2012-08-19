Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2HSO1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:27:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51764 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2HSO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:27:43 -0400
Date: Sun, 19 Aug 2012 15:27:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dan Luedtke <mail@danrl.de>
Cc: Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Message-ID: <20120819142732.GB23464@ZenIV.linux.org.uk>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
 <1345371135.4441.2.camel@tunafish>
 <5030BC7E.3030000@gmail.com>
 <1345383264.4441.56.camel@tunafish>
 <20120819120254.GA2369@pompeji.miese-zwerge.org>
 <1345390432.2716.34.camel@tunafish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345390432.2716.34.camel@tunafish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 05:33:52PM +0200, Dan Luedtke wrote:

> Still wondering if anyone bothers to actually look at the code?

Some obvious notes:
	* unlimited recursion is a killer; here its depth is controlled
by the fs image contents and it's trivial to cook one that would overflow
kernel stack.  Seeing that you want to use it for removable media, that's
a gaping security hole right there
	* unlink() does *not* truncate the file contents; file that had been
opened and unlinked should keep its contents until it's closed.  The same
goes for overwriting rename().
	* while we are at it, neither of those should free the on-disk
inode; again, that should happen only when the inode is evicted.
	* I might be missing something, but copying a bunch of files
with something like cp /foo/* /mnt seems to be guaranteed to create
really lousy binary tree in target directory (they will go in lexicographical
order and you don't seem to rebalance the tree at all)
	* you are really abusing iget() there.  Leaving the locking issues
aside, that's going to get you icache filled with irrelevant stuff.  Moreover,
it's far too heavy a club; allocating and filling struct inode when all you
really need is name and a couple of pointers in the disk block?
	* minor point, but endianness-flipping in place is *the* way to get
hard-to-catch endianness bugs.  foo = cpu_to_le64(foo) is a bloody bad idea;
either use object for host-endian all along, or use it only for (in your
case) little-endian.
