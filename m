Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0J3BWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 21:22:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641Ab0J3BWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 21:22:06 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikBmewDmBJWHzdTerJE2W4GqRYMxLCdAJyz5JDB@mail.gmail.com>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr> <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr> <AANLkTikBmewDmBJWHzdTerJE2W4GqRYMxLCdAJyz5JDB@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Oct 2010 18:16:48 -0700
Message-ID: <AANLkTikEpV7GWG9fd3=zfrhOZtbPvxJWfXAO30iN8aae@mail.gmail.com>
Subject: Re: Sync writeback still broken
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Greg KH <gregkh@suse.de>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 5:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Guys, what is the status of this?
>
> The original patch in that email thread still makes no sense and the
> commit log for it cannot be the real issue. But the _problem_ seems to
> be real, and the code is apparently a total mess, still.

Btw, is the problem just that insane WB_SYNC_ALL thing?

The problem with WB_SYNC_ALL seems to be that it synchrnously writes
out one inode at a time. And it's not just the data, it's the inode
itself.

So rather than write out all pages for _all_ inodes, and then wait for
them, and write out _all_ metadata, and then wait for that, it seems
like the WB_SYNC_ALL code does the truly stupid thing, which is to
"write out some data for one inode, then _synchronously_ wait for
that, then write out the metadata for that single inode, then
_synchronously_ wait for THAT" and then rinse and repeat for each
inode.

The sane thing for "WB_SYNC_ALL" would be to:
 - for_each_inode: write out all data (no waiting)
 - for_each_inode: wait for the data for that inode, write out the inode
 - for_each_inode: wait for the inode

so that you avoid the whole synchronous wait thing, and can do all
inodes in one go.

I dunno. Who even uses WB_SYNC_ALL? It's just "sync()" itself, isn't
it? And "umount()", I guess. I didn't actually look at the code.

                  Linus
