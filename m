Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2DLLRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:17:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43404 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2DLLRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204111735530.12033@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>
	<4F748CD6.4080704@parrot.com>
	<alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>
	<1333110503.5440.24.camel@sauron.fi.intel.com>
	<alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
	<1333111321.5440.29.camel@sauron.fi.intel.com>
	<alpine.DEB.2.00.1203301709080.10066@eristoteles.iwoars.net>
	<1334147205.13842.8.camel@sauron.fi.intel.com>
	<alpine.DEB.2.00.1204111514120.10181@eristoteles.iwoars.net>
	<alpine.DEB.2.00.1204111735530.12033@eristoteles.iwoars.net>
Date: Thu, 12 Apr 2012 14:17:30 +0300
Message-ID: <CAF4G-tKbm-f84+8-zcAO60jvqhrv-jG90P=2o+J6PByvfQY7Rw@mail.gmail.com>
Subject: Re: [PATCH] UBIFS: use ubi's new ubi_leb_change sync parameter
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

let's not CC fsdevel anymore so far - we generate too much traffic there.

On Wed, Apr 11, 2012 at 6:38 PM, Joel Reardon <joel@clambassador.com> wrote:
> This patch fixes UBIFS to use the new sync parameter for ubi's ubi_leb_change
> function. In the previous post, one of the calls had sync = 1, this is
> fixed. This, along with the ubi patch that introduces the new
> parameter, was tested using integck for both sync=0 and sync=1 in the
> tnc_commit's call to leb_change and the underlying free'd PEB was
> inspected through debug statements to ensure that it was later reallocated
> for new data.

I was thinking about this again and I do not really like the patch
anymore because it
does not solve the problem.

Indeed, we have the wear-levelling subsystem which may decide at any point that
the contents of one of the PEBs containing keys has to be moved to a
different PEB.
It will move it and then schedule the old PEB for erasure. Your
solution does not guarantee
that this old PEB is now erased. And thus, you do not achieve what you
want to achieve.

First of all, notice, that you can work on this aspect independently
of the UBIFS part.

I guess you actually have 2 choices.

1. Flush entire erasblocks queue.
2. Implement a funtion which will flush the queue only for a specific LEB.

The first approach may be very slow, especially on NOR. Also, I've
just noticed that
ubi_sync() does not actually do this - it only calls 'mtd_sync()'. You
need to introduce a
parameter to mtd_sync() which will tell whether to only sync the MTD
device or also
flush the entire queue. This is trivial. To flush the queue, you need
to call 'ubi_wl_flush()'.

The second approach is also not too difficult to do, I think.

Basically, you add a 'int lnum' parameter to 'mtd_sync()'. Then you
add this parameter
to 'ubi_wl_flush()', and may be to 'do_work()' as well.

Then you need to make sure you have 'lnum' available in the elements
of the 'ubi->works'
list. This basically means you need to have an 'int lnum' field in
'struct ubi_work'. Probably
this means that 'schedule_work()' should also accept an 'int lnum'
argument. Does not
sound too difficult.

Then you will be able to achieve what you want by calling
'ubi_leb_change()' first, and
then 'ubi_sync(lnum)'.

Also note, after mount you also have to call 'ubi_sync(lnum)' for all
LEBs containing
the keys. This is because you may have an unclean reboot just before
you have erased
the old PEB.

So, I am sorry, but I am removing so far this patch from my tree.

What do you think?

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)
