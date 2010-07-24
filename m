Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0GXNvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 09:51:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43720 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0GXNvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 09:51:31 -0400
Date: Sat, 24 Jul 2010 14:51:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Lubomir Rintel <lkundrak@v3.sk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] [fs/sysv] V7: Add support for non-PDP11 v7
 filesystems
Message-ID: <20100724135128.GA11645@ZenIV.linux.org.uk>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
 <1279559802-19154-2-git-send-email-lkundrak@v3.sk>
 <1279559802-19154-3-git-send-email-lkundrak@v3.sk>
 <1279559802-19154-4-git-send-email-lkundrak@v3.sk>
 <20100719145851.GD25279@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719145851.GD25279@lst.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 04:58:51PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 19, 2010 at 07:16:42PM +0200, Lubomir Rintel wrote:
> > A mount-time option was added that makes it possible to override the
> > endianness and an attempt is made to autodetect it (which seems easy,
> > given the disk addresses are 3-byte.
> > 
> > No attempt is made to detect big-endian filesystems -- were there any?
> > Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.
> 
> Do you actually need the mount option?  We get away just fine with
> it for sysv filesystems.  And if not I'd be consistent and accept the
> options for both sysv and v7 filesystems.

Actually, it shouldn't be too hard to detect the damn thing even without magic.
Look - we always have the inode table starting at block 2, so on-disk root
inode is guaranteed to be found correctly.  Now, suppose we'd mistaken
l-e for pdp or vice versa; the half-words of i_size would get swapped.
What could pass both tests?  Suppose the right size is a * 65536 + b;
then we have: a and b are both multiples of 16 and at least one is non-zero.
So all we need is to reject root directories bigger than 1Mb.  And posted
patches do reject that (and lower than that, actually).

So I'd rather see a variant without that option.  Simply get both bh, then
try the same sanity checks with LE and PDP used for s_bytesex.  And use
one that works - we _know_ that it's impossible to have both pass at the
same time.

I'm fine with the rest of patch series as is; Lubomir, could you redo the
last one that way and resend?
