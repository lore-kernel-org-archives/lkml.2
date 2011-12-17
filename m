Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1LQW6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:58:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47743 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1LQW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:58:51 -0500
Date: Sat, 17 Dec 2011 22:58:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Namhyung Kim <namhyung@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: fput() called in loop_clr_fd() may cause bd_mutex
 recursive locking
Message-ID: <20111217225846.GC2203@ZenIV.linux.org.uk>
References: <20111217215333.GA3313@swordfish>
 <20111217221232.GA2203@ZenIV.linux.org.uk>
 <20111217221928.GB3313@swordfish>
 <20111217223033.GB2203@ZenIV.linux.org.uk>
 <20111217223745.GC3313@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111217223745.GC3313@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 01:37:45AM +0300, Sergey Senozhatsky wrote:
> > Think of it for a minute - if we could run into the
> > same bdev in that recursion, what would have happened on read() from
> > that sucker? So yes, it is a false positive. 
> 
> I've tried read()/write() some time ago and it worked. Perhaps, I just
> wasn't "lucky" enough to hit any problems.

Sure - exactly because of that loop prevention logics.  *If* we really
had been able to set a loop0 -> loop1 -> loop2 -> loop0 or something of
that sort, this warning wouldn't be a false positive.  But on any
such setup, where would IO attempts end up doing?  IOW, we have to
prevent such setups anyway and not just because of problems on close() -
they would be deadly on read() and write()...
