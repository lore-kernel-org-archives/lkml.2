Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab2FZP1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:27:53 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:34154 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab2FZP1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <x49r4t2rul5.fsf@segfault.boston.devel.redhat.com>
References: <x49r4t2rul5.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 26 Jun 2012 11:27:50 -0400
Message-ID: <CA+5PVA6j+deqA9n7ZsZDcSsCKTvHs4B1QMfrL4KvHVWTC=dV7A@mail.gmail.com>
Subject: Re: [patch] block: fix infinite loop in __getblk_slow
From: Josh Boyer <jwboyer@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Nick Piggin <npiggin@kernel.dk>,
        LKML List <linux-kernel@vger.kernel.org>, torsten.hilbrich@secunet.com,
        Richard Jones <rjones@redhat.com>, stable@vger.kernel.org,
        Marcos Mello <marcosfrm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 10:55 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> This commit:
>
> commit 080399aaaf3531f5b8761ec0ac30ff98891e8686
> Author: Jeff Moyer <jmoyer@redhat.com>
> Date:   Fri May 11 16:34:10 2012 +0200
>
>     block: don't mark buffers beyond end of disk as mapped
>
> exposed a bug in __getblk_slow that causes mount to hang as it loops
> infinitely waiting for a buffer that lies beyond the end of the disk to
> become uptodate.  The problem was initially reported by Torsten Hilbrich
> here: https://lkml.org/lkml/2012/6/18/54, and also reported
> independently here:
> http://www.sysresccd.org/forums/viewtopic.php?f=13&t=4511, and then
> Richard W.M. Jones and Marcos Mello noted a few separate bugzillas also
> associated with the same issue.
>
> The main problem is here, in __getblk_slow:
>
>         for (;;) {
>                 struct buffer_head * bh;
>                 int ret;
>
>                 bh = __find_get_block(bdev, block, size);
>                 if (bh)
>                         return bh;
>
>                 ret = grow_buffers(bdev, block, size);
>                 if (ret < 0)
>                         return NULL;
>                 if (ret == 0)
>                         free_more_memory();
>         }
>
> __find_get_block does not find the block, since it will not be marked as
> mapped, and so grow_buffers is called to fill in the buffers for the
> associated page.  I believe the for (;;) loop is there primarily to
> retry in the case of memory pressure keeping grow_buffers from
> succeeding.  However, we also continue to loop for other cases, like the
> block lying beond the end of the disk.  So, the fix I came up with is to
> only loop when grow_buffers fails due to memory allocation issues
> (return value of 0).
>
> The attached patch was tested by myself, Torsten, and Rich, and was
> found to resolve the problem in call cases.
>
> Comments, as always, are appreciated.

Is this needed in addition to your earlier patch here:

http://article.gmane.org/gmane.linux.kernel/1316228

or is it a replacement for that?

josh
