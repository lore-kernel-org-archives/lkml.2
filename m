Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1BQAq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:46:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752Ab1BQAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:46:55 -0500
MIME-Version: 1.0
In-Reply-To: <20110217002335.GI29600@atj.dyndns.org>
References: <20110216181153.5b8f81d5@katamari> <20110216232816.GH29600@atj.dyndns.org>
 <AANLkTikuMNjk=nBvaARXJ0LBp_8OS+-iMv20t-rf34ph@mail.gmail.com> <20110217002335.GI29600@atj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 16:46:02 -0800
Message-ID: <AANLkTi=JJGBE6uq78FD_s902PaqQ1SptEmUN7=X5fRvF@mail.gmail.com>
Subject: Re: [Patch v2] block: revert block_dev read-only check
To: Tejun Heo <tj@kernel.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 4:23 PM, Tejun Heo <tj@kernel.org> wrote:
>
> It has been a while so the details might be a bit off but read/write
> permissions on block devices are rather weird.
>
> * RO block devices can be opened RW.

Well, yes and no.

If the device node is RW, then that's often the most important part.
Whether the device itself then thinks it is read-only or not is almost
totally irrelevant. The internal "bdev_read_only()" thing is very much
a secondary thing, and has nothing to do with security, and everything
to do with random block device internals. So don't take it too
seriously.

BUT.

Some device drivers have actually done a good job historically, and
check the RW flags at open time. The only one I know of is the
traditional floppy.c, though.

HOWEVER - even then it also checks the FMODE_NDELAY, and skips all the
checks (including for media) if that bit isn't set. Because being too
anal about it is simply _wrong_. You may need to override the RO state
of the device, and you may need to open it writably in order to do so!

Because to make things even more complicated, even if the open
succeeded, the floppy driver will then check the writable bit (that it
might have ignored at open time) for certain ioctl's.

End result: it's almost certainly wrong to think that you can stop RW
open calls based on whether the device is somehow read-only. Even on a
physically read-only device you may need to have write permissions to
do certain operations.

So quite frankly, if you want to enforce read-only, you should
probably do it at command queueing time, not at open() time. Because
at open time, you just don't know enough.

                         Linus
