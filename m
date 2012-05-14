Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab2ENUnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:43:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829Ab2ENUnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:43:07 -0400
Date: Mon, 14 May 2012 22:42:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] floppy: remove floppy-specific O_EXCL handling
In-Reply-To: <20120514162521.GA2366@google.com>
Message-ID: <alpine.LNX.2.00.1205142237590.15448@pobox.suse.cz>
References: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz> <20120514162521.GA2366@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Tejun Heo wrote:

> > Block layer now handles O_EXCL in a generic way for block devices.
> > 
> > The semantics is however different for floppy and all other block devices,
> > as floppy driver contains its own O_EXCL handling.
> > 
> > The semantics for all-but-floppy bdevs is "there can be at most one O_EXCL 
> > open of this file", while for floppy bdev the semantics is "if someone has 
> > the bdev open with O_EXCL, noone else can open it".
> > 
> > Remove the floppy-specific handling and let the generic bdev code O_EXCL
> > handling take over.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Patch looks good to me 

Thanks.

> but why do we want to change this at this point?

Because since

	commit e525fd89d380c4a94c0d63913a1dd1a593ed25e7
	Author: Tejun Heo <tj@kernel.org>
	Date:   Sat Nov 13 11:55:17 2010 +0100

	    block: make blkdev_get/put() handle exclusive access

mount of /dev/fd0 actually causes the fd0 block device be claimed with 
_EXCL. Before this commit, you are able to mount /dev/fd0 and then open() 
it afterward. After this commit you can't any more, because mounting 
/dev/fd0 already passes O_EXCL to floppy_open(), and thus noone else can 
open(/dev/fd0) any more.

My commit brings things back into shape, i.e. you can, equally to other 
block devices, both mount it and open() it afterwards.

-- 
Jiri Kosina
SUSE Labs
