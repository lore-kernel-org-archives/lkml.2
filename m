Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2JQOv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:51:57 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:60563 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab2JQOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:51:56 -0400
Message-ID: <1350485448.3206.146.camel@linaro1.home>
Subject: Re: [PATCH 9/9] ARM: add uprobes support
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Dave Martin <dave.martin@linaro.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com
Date: Wed, 17 Oct 2012 15:50:48 +0100
In-Reply-To: <20121015174450.GB18614@linaro.org>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
	 <1350242593-17761-9-git-send-email-rabin@rab.in>
	 <20121015111443.GA2006@linaro.org>
	 <CAH+eYFC1fr0vpK2T4hz9LK=Nz5bzQBQ4O-o0f9tsnj-_D9ZEJg@mail.gmail.com>
	 <20121015174450.GB18614@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost04-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 18:44 +0100, Dave Martin wrote:
> On Mon, Oct 15, 2012 at 01:44:55PM +0200, Rabin Vincent wrote:
> > 2012/10/15 Dave Martin <dave.martin@linaro.org>:
> > > On Sun, Oct 14, 2012 at 09:23:13PM +0200, Rabin Vincent wrote:
> > >> Add basic uprobes support for ARM.
> > >>
> > >> perf probe --exec and SystemTap's userspace probing work.  The ARM
> > >> kprobes test code has also been run in a userspace harness to test the
> > >> uprobe instruction decoding.
> > >
> > > The assumption that the target code is ARM appears to be buried all over
> > > the place.
> > 
> > Right, as stated:
> > 
> > >> Caveats:
> > >>  - Thumb is not supported
> > 
> > > Certainly this code as currently written must depend on !THUMB2_KERNEL.
> > 
> > Why?  It currently works for ARM userspace even if the kernel is
> > Thumb-2.
> 
> My bad, I misread what was happening in the Makefile changes.
> 
> My concern is about whether we can build the ARM and Thumb-2 kprobes
> code into the same kernel.  If so, no problem, but I believe this is
> not a tested configuration for kprobes itself.

When reworking kprobes I originally started by having ARM instruction
support in Thumb kernels (with all test cases working) and, if I
remember correct, this got dropped because we had difficulty in coming
up with a robust way of specifying whether a probe pointer was in Thumb
code or not. (Different methods of getting pointers to Thumb code didn't
always set bit 0 so we 'solved' this by ignoring bit 0 and assuming all
code in Thumb kernels was Thumb.)

<snip>
> General question which I'm not sure I understand yet: is is possible
> to combine uprobes/kprobes decode more completely?  It's not obvious
> to me whether the uprobes-specific decoding only relates to features
> which architecturally execute differently in user mode versus
> privileged mode.  Some explanation somewhere could be helpful.

I just been looking at the decoding changes in patch 8 and had similar
thoughts. The patch as it stands looks rather bolted on the side and
makes the resulting code rather messy. My initial thoughts are that
either:

a) uprobes is similar enough to kprobes that the existing code can be
morphed into something that cleanly supports both, or

b) the similarities aren't close enough and that we should factor out
the similarities into a more generalised decoding base, which the
{u,k}probe code can then build on.

c) some mix of a) and b)

I can't help but think of the various calls over the past year or so for
a general ARM/Thumb instruction decoding framework (the last one only a
few weeks ago on the linux-arm-kernel list). Perhaps b) would be a small
step towards that.

I hope to find some time to understand the uprobe patches in more
detail, so I can try and come up with some sensible suggestions on a
cleaner solution; because I feel that as they stand they aren't really
suitable for inclusion in the kernel.

Rabin, what tree/commit are your patches based on? (They don't seem to
apply cleanly to 3.6 or 3.7-rc1.) I want to apply them locally so I can
use my favourite visualisation tool and to play with them.

Thanks

-- 
Tixy

