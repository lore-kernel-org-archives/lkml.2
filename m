Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2E1RKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 13:10:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40014 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2E1RKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 13:10:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120528114124.GA6813@localhost>
References: <20120528114124.GA6813@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 May 2012 10:09:56 -0700
X-Google-Sender-Auth: CiuH7BNWq2KOFu1dUEVG_InvP0w
Message-ID: <CA+55aFxHt8q8+jQDuoaK=hObX+73iSBTa4bBWodCX3s-y4Q1GQ@mail.gmail.com>
Subject: Re: [GIT PULL] writeback changes for 3.5-rc1
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, pulled.

However, I have an independent question for you - have you looked at
any kind of per-file write-behind kind of logic?

The reason I ask is that pretty much every time I write some big file
(usually when over-writing a harddisk), I tend to use my own hackish
model, which looks like this:

#define BUFSIZE (8*1024*1024ul)

        ...
        for (..) {
                ...
                if (write(fd, buffer, BUFSIZE) != BUFSIZE)
                        break;
                sync_file_range(fd, index*BUFSIZE, BUFSIZE,
SYNC_FILE_RANGE_WRITE);
                if (index)
                        sync_file_range(fd, (index-1)*BUFSIZE,
BUFSIZE, SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER);
                ....

and it tends to be *beautiful* for both disk IO performane and for
system responsiveness while the big write is in progress.

And I'm wondering if we couldn't expose this kind of write-behind
logic from the kernel. Sure, it only works for the "contiguous write
of a single large file" model, but that model isn't actually all
*that* unusual.

Right now all the write-back logic is based on the
balance_dirty_pages() model, which is more of a global dirty model.
Which obviously is needed too - this isn't an "either or" kind of
thing, it's more of a "maybe we could have a streaming detector *and*
the 'random writes' code". So I was wondering if anybody had ever been
looking more at an explicit write-behind model that uses the same kind
of "per-file window" that the read-ahead code does.

(The above code only works well for known streaming writes, but the
*model* of saying "ok, let's start writeout for the previous streaming
block, and then wait for the writeout of the streaming block before
that" really does tend to result in very smooth IO and minimal
disruption of other processes..)

                      Linus

On Mon, May 28, 2012 at 4:41 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> Please pull the writeback changes, mainly from Jan Kara to avoid
> iput() in the flusher threads.
