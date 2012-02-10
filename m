Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2BJVUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:20:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34669 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab2BJVUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:20:00 -0500
Date: Fri, 10 Feb 2012 21:19:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Anton Altaparmakov <anton@tuxera.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Szabolcs Szakacsits <szaka@tuxera.com>,
        Janne Kalliom?ki <janne@tuxera.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Direct i/o changes break all non-GPL file systems
Message-ID: <20120210211946.GJ23916@ZenIV.linux.org.uk>
References: <92291682-5422-4AE2-9608-97775603E7FD@tuxera.com>
 <20120208001519.501b6fea@pyramind.ukuu.org.uk>
 <673AFC57-2B73-49AC-962E-CAB1DE775B2C@tuxera.com>
 <D35F212C-0C17-43CE-885D-62C6DF58E2C2@dilger.ca>
 <CA+55aFyBAiZ3khqQiSU0OBafMABsAzdU5DLzZvaM_Et52Wte5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyBAiZ3khqQiSU0OBafMABsAzdU5DLzZvaM_Et52Wte5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:28:27AM -0800, Linus Torvalds wrote:
> On Tue, Feb 7, 2012 at 5:51 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> >
> > This doesn't affect me directly, since Lustre is itself a GPL filesystem,
> > but it does seem a bit harsh for such a minor amount of functionality.
> 
> It also wasn't documented in the commit or apparently even intentional.
> 
> > Looking at inode_dio_wait(), there isn't anything in there that couldn't
> > be implemented without using that GPL-only symbol export. ?Both inode_dio_wait()
> > and __inode_dio_wait() use only functions that are themselves EXPORT_SYMBOL()
> > (i.e. not GPL-only) and locally accessible structures (inode->i_dio_count
> > and inode->i_state), so I don't see any benefit or reason in making
> > inode_dio_wait() itself GPL.
> 
> Yes. I suspect we should just remove the _GPL part. Christoph, Al?

I'm all for it; TBH, I simply missed _GPL on those back then.  As far as I'm
concerned, there are 3 cases:
	1) it's a part of general-purpose API and it does make sense for
modules; use EXPORT_SYMBOL
	2) it's a kernel-internal thing that is not used by in-tree modules
and should not be used by any modules; don't export it at all
	3) it's a layering violation that unfortunately still is needed for
an in-tree module.  The *only* case where I'd consider EXPORT_SYMBOL_GPL
borderline useful, as a bad proxy for EXPORT_SYMBOL_DONT_USE_OUT_OF_TREE.

It's Christoph's code, though, so I'm not happy with just going ahead and
ripping that _GPL off those exports.  Christoph?

And folks, for the future, do not use ..._GPL on VFS exports unless you have
a damn good reason to discourage the use in out-of-tree modules in general.
Which needs to be clearly documented.
