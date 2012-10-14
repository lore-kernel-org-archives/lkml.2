Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2JNUYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 16:24:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52184 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2JNUYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 16:24:44 -0400
Date: Sun, 14 Oct 2012 21:24:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Mack <zonque@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [git pull] signals pile 3
Message-ID: <20121014202431.GL21164@n2100.arm.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk> <507ADBBB.9090209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507ADBBB.9090209@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 05:35:23PM +0200, Daniel Mack wrote:
> I rebased my ARM development branch and figured that your patch 9fff2fa
> ("arm: switch to saner kernel_execve() semantics") breaks the boot on my
> board right after init is invoked via NFS:

Ok, I'm not going to assign blame to Al's commits (I never reviewed his
stuff before they hit mainline - patches never posted to the ARM mailing
list, and the development actually happened within the merge window,
all things we tell people not to do...)  I _still_ haven't reviewed that
stuff yet.

But... nevertheless...

> [    4.682072] VFS: Mounted root (nfs filesystem) on device 0:12.
> [    4.690744] devtmpfs: mounted
> [    4.694395] Freeing init memory: 172K
> [    5.291417] Internal error: Oops - undefined instruction: 0 [#1] SMP
> THUMB2

Ok, so this tells us the kernel was built using Thumb2 ISA.

> [    5.298734] Modules linked in:
> [    5.301952] CPU: 0    Not tainted  (3.6.0-11053-g56c8535 #128)
> [    5.308071] PC is at cpsw_probe+0x422/0x9ac

PC is not word aligned, so it can't be running in the ARM ISA.

> [    5.312459] LR is at trace_hardirqs_on_caller+0x8f/0xfc
> [    5.317934] pc : [<c03493de>]    lr : [<c005e81f>]    psr: 60000113

Note that this reconfirms the above (well, it should do, it's the same
value.)

> [    5.317934] sp : cf055fb0  ip : 00000000  fp : 00000000
> [    5.329944] r10: 00000000  r9 : 00000000  r8 : 00000000
> [    5.335413] r7 : 00000000  r6 : 00000000  r5 : c034458d  r4 : 00000000
> [    5.342244] r3 : cf057a40  r2 : 00000000  r1 : 00000001  r0 : 00000000
> [    5.349078] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
> Segment user

And this tells us that we're running in ARM mode, not Thumb mode.

> [    5.356546] Control: 50c5387d  Table: 8f434019  DAC: 00000015
> [    5.362562] Process init (pid: 1, stack limit = 0xcf054240)
> [    5.368395] Stack: (0xcf055fb0 to 0xcf056000)
> [    5.372961] 5fa0:                                     00000001
> 00000000 00000000 00000000
> [    5.381525] 5fc0: cf055fb0 c000d1a8 00000000 00000000 00000000
> 00000000 00000000 00000000
> [    5.390091] 5fe0: 00000000 bee83f10 00000000 b6fdedd0 00000010
> 00000000 aaaabfaf a8babbaa

No stack backtrace (and it's silent about why that is).

The other strange thing here is that the stack dump above is showing that
the stack is completely empty - which shouldn't be the case if we're in a
driver probe function - driver probe functions are called via the driver
model layers...

> [    5.398664] Code: 2206a010 718ef508 0184f8da f8b1f65d (3070f8d8)

And now we come to the Code: line, which makes no sense as an ARM ISA:

   0:   2206a010        andcs   sl, r6, #16
   4:   718ef508        orrvc   pc, lr, r8, lsl #10
   8:   0184f8da        ldrdeq  pc, [r4, sl]
   c:   f8b1f65d                        ; <UNDEFINED> instruction: 0xf8b1f65d
  10:   3070f8d8        ldrsbtcc        pc, [r0], #-136 ; 0xffffff78    ; <UNPREDICTABLE>

But as Thumb, it looks more reasonable:

   0:   a010            add     r0, pc, #64     ; (adr r0, 44 <foo+0x44>)
   2:   2206            movs    r2, #6
   4:   f508 718e       add.w   r1, r8, #284    ; 0x11c
   8:   f8da 0184       ldr.w   r0, [sl, #388]  ; 0x184
   c:   f65d f8b1       bl      ffe5d172 <foo+0xffe5d172>
  10:   f8d8 3070       ldr.w   r3, [r8, #112]  ; 0x70

I don't have any further comments to make on this yet, as I've no idea
what state stuff is in, but the above oops dump to me suggests that
we've randomly jumped into some part of the kernel which just happens
to be cpsw_probe().

Please send me (in private mail) your vmlinux file and a corresponding
oops dump from that same kernel, and I'll dig and try and work out
what's going on...

This kind of investigation reminds me of those I did back in the 1990s
when stuff was rather unstable and ARM was a young architecture.  Now
all we need is for an ARM platform to dump its entire memory out the
ethernet port, bringing an university department network to a halt (I
did that once - back in the 1990s - sorry Tim!)
