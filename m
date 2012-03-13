Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2CMAG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:06:59 -0400
Received: from home.keithp.com ([63.227.221.253]:47120 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2CMAG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:06:58 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Jones <davej@redhat.com>
Cc: Yang Bai <hamo.by@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz
Subject: Re: inode->i_wb_list corruption.
In-Reply-To: <20120312232630.GA20287@redhat.com>
References: <20120306185137.GA15881@redhat.com> <20120306210307.GC8781@quack.suse.cz> <20120307072608.GA24087@localhost> <20120307104240.GB18658@quack.suse.cz> <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com> <20120309145713.GA21543@redhat.com> <20120309151951.GA30160@redhat.com> <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com> <20120309180015.GA3862@redhat.com> <868vj97d20.fsf@sumi.keithp.com> <20120312232630.GA20287@redhat.com>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 12 Mar 2012 17:06:52 -0700
Message-ID: <861uoxmkir.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Mon, 12 Mar 2012 19:26:30 -0400, Dave Jones <davej@redhat.com> wrote:

> Thinking about how the GTT could contain stale pointers, I came up with this scenario:
> 
> Before we begin the thaw, the initramfs sets up a framebuffer.
> This causes the GTT to be setup.

Yes. The frame buffer is allocated as regular kernel pages, of course.

> - Thaw begins, hardware state still points to the GTT setup by the modesetting code.
>   At this point, any graphics operations are going to cause writes through
>   those translations. Bad news if we just wrote a bunch of thawed data
>   there.

The question is what data could still be pending there; we're running
just fbcon at that point, which uses only write-through
access. Presumably, any fbdev writes will have been long-since finished
once we start the new kernel.

> - Thaw begins, and data is written over the GTT setup by the initramfs, but 
>   the hardware registers still points at it, until thaw is complete, when we
>   reprogram the GTT registers to their pre-hibernate values.

I'm not sure how the new kernel could manage to do any writes through
this though -- it shouldn't touch the frame buffer until it has thawed
the video driver, right?

> If we could somehow set modeset=0 automatically if we detect a hibernate
> partition it would probably 'solve' it, but I suspect the real answer
> would be to do GTT teardown before we do a thaw.

We've got a ton of memory available in the 'stolen' area which the BIOS
used as a frame buffer; we should be able to switch to that before the
switch, if we decide that this is necessary.

-- 
keith.packard@intel.com
