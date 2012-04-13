Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2DMH0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 03:26:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab2DMH0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 03:26:18 -0400
Date: Fri, 13 Apr 2012 00:26:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind1@gmail.com
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v1 0/3] do not use s_dirt in FAT FS
Message-Id: <20120413002656.b67e58ad.akpm@linux-foundation.org>
In-Reply-To: <1334299108.2544.68.camel@sauron.fi.intel.com>
References: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
	<20120412171257.a0fc35b4.akpm@linux-foundation.org>
	<1334299108.2544.68.camel@sauron.fi.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 09:38:28 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:

> > That implies that we retain ->write_super, probably in a modified form.
> > Modified to permit the VFS to determine whether the superblock needs
> > treatment, if ->s_dirt doesn't suffice.
> 
> I tried this approach and it was vetoed by Al Viro. Although it is
> simpler to me to resurrect my old patches, I agree with Al that killing
> '->write_super()' is a better approach.

Well, it can be done without a super_operation vector - pass the
library code a superblock* and a function address.  But the difference
is pointless fluff.

> We do not want to serve a whole
> kernel thread in the generic code for few baroque citizens.

One could refcount the thread, but I think I misread the code - the
amount of generic boilerplate which was added to the fs is in fact
pretty small.

> Please, see this thread for the reference:
> http://lkml.org/lkml/2010/7/22/96
> 
> > The code as you've proposed it will cause more wakeups than needed - if
> > multiple filesystems are mounted and active, their timers will get out
> > of sync.  Which rather defeats the intent of the whole work!  This
> > problem should be addressable via some new centralised way of managing
> > things.
> 
> I do not think this is an issue. If we have many file-systems, and all
> of them are actively used so that the super block becomes dirty, which
> most probably means there is also write-back - so be it, it is ok to arm
> many timers. And if we make them deferrable for most of the FSes (which
> we can not do for the generic timer, because we do not know FSes needs)
> - then this is not an issue at all.

OK.

> Also, if you look at this from the angle that only few old FSes will
> have this, it becomes not that bad. I assume I will change this
> patch-set and won't use delayed works here.

I don't think I understand that.  You intend to alter this patchset?
