Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1GLURl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:17:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51245 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1GLURj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:17:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110712181536.GA30364@redhat.com>
References: <20110712181536.GA30364@redhat.com>
Date: Tue, 12 Jul 2011 21:17:37 +0100
Message-ID: <CAPM=9tywf2_Y8maO4Tc8Z4nMfk8oJPoFic7+wMLxekjgcs=grw@mail.gmail.com>
Subject: Re: drm_lock()->block_all_signals() is broken
From: Dave Airlie <airlied@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 7:15 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Hello.
>
> I tried many times to ask about the supposed behaviour of
> block_all_signals() in drm, but it seems nobody can answer.

Its not hard to explain, basically there exists hardware that you
program acceleration engines using MMIO, having multiple processes
writing to the MMIO area at once is a bad idea, so we use the DRM lock
which is like a pre-futex futex. Now the problem is if you stop or
kill a process in a critical section where it is writing to the
hardware directly with MMIO you could crash the hardware, so the idea
is that you block to the max until the critical section exits via the
drm unlock.

some links
http://lkml.indiana.edu/hypermail/linux/kernel/0202.2/0045.html

The only driver that might even use this and care in the tree is tdfx
as I think it might be MMIO programmed, though I'm not 100% sure. I
pretty much reckon we can deprecate block_all_signals as I forsee
fixing all the problem you pointed out with it would be worse than
just removing it.

>
> So I am going to send the patch which simply removes
> block_all_signals() and friends. There are numeruous problems
> with this interace, I can't even enumerate them. But I think
> that it is enough to mention that block_all_signals() simply
> can not work. AT ALL. I am wondering, was it ever tested and
> how.

I wasn't around, but it did work back in linux-2.4.0-test7 when it was
introduced,

http://www.kernel.org/pub/linux/kernel/v2.4/old-test-kernels/patch-2.4.0-test7.gz

is the initial patch. You should probably check that out and see if
you can work out how it originally worked, and the work out
if its really is broken now or if you haven't analysed it correctly.

> I strongly believe block_all_signals() should die. Given that
> it doesn't work, could somebody please explain me what will
> be broken?

> Just in case... Please look at the debugging patch below. With
> this patch,
>
>        $ perl -le 'syscall 157,666 and die $!; sleep 1, print while ++$_'
>        1
>        2
>        3
>        ^Z
>
> Hang. So it does react to ^Z anyway, just it is looping in the
> endless loop in the kernel. It can only look as if ^Z is ignored,
> because obviously bash doesn't see it stopped.

taking the drm lock usually means you will drop it without doing
anything stupid like sleeping for a long time, if the process dies,
the lock gets dropped automatically also.

I've only second hand knowledge of how this works though, and I'm on
holidays for another week or so, maybe once I get back I'll find some
time to figure out how it works vs what happens, but really I suspect
we can kill this with fire.

Dave.
