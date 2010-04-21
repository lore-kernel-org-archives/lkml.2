Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0DUWlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:41:00 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35007 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab0DUWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:40:58 -0400
To: xorg-ati <xorg-driver-ati@lists.x.org>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Cc: xorg@lists.freedesktop.org
Subject: Radeon KMS bug(?) after Linux kernel 2.6.32 causes a crash of X server 1.8.0+ on termination
References: <87iq7pd68h.fsf@spindle.srvr.nix>
From: Nix <nix@esperi.org.uk>
Emacs: because you deserve a brk today.
Date: Wed, 21 Apr 2010 23:40:52 +0100
In-Reply-To: <87iq7pd68h.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of "Sun, 18 Apr 2010 00:11:42 +0100")
Message-ID: <87pr1sfmyz.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Apr 2010, nix@esperi.org.uk said:

> So far, every time I've quit X 1.8.0 (1.8-stable tip of tree), it's
> coredumped and left my console unusable until I restart. (I'm using the
> tip of the xf86-video-ati tree, and KMS, both of which worked fine with
> 1.7.5. Obviously I've recompiled all the drivers I'm usingt, or X
> wouldn't work at all...)
>
> The backtrace differs depending on whether auditing is enabled or not.
>
> With auditing on, we are hit with a segfault here:
>
> #0  0x00007f7e06148985 in _xstat () from /lib/libc.so.6
> #1  0x00007f7e061198d0 in __tzfile_read () from /lib/libc.so.6
> #2  0x00007f7e06118c8a in tzset_internal () from /lib/libc.so.6
> #3  0x00007f7e06118df9 in __tz_convert () from /lib/libc.so.6
> #4  0x00007f7e06117439 in ctime () from /lib/libc.so.6
> #5  0x00000000004533c8 in AuditPrefix ()
> #6  0x0000000000453956 in VAuditF ()
> #7  0x0000000000453add in AuditF ()
> #8  0x000000000043e5c6 in CloseDownClient ()
> #9  0x0000000000443af8 in Dispatch ()
> #10 0x0000000000420dc5 in main ()
>
> With it off, I see this instead:
>
> Program received signal SIGTERM, Terminated.
> 0x000000000042904c in FreeClientResources ()
> (gdb) bt
> #0  0x000000000042904c in FreeClientResources ()
> #1  0x000000000043e4c2 in CloseDownClient ()
> #2  0x0000000000443af8 in Dispatch ()
> #3  0x0000000000420dc5 in main ()
>
> which might look like normal termination, except that
> FreeClientResources() of course does not contain an exit(), and the
> console is still unusable.
>
> I suspect a double-free() somewhere, and/or heap corruption.

Nope. This bug only appears with KMS enabled; it does not appear in
2.6.32.10 (when termination happens normally, with only

[   71.267834] Unpin not necessary for ffff88033d66dc00 !

in the kernel log) but does appear with current tip; seen with 2.6.34rc3
and later (i.e. as soon as I upgraded the X server).

So this is either a KMS bug corrupting something in userspace, or a bug
in the X server triggered by the presence of KMS and some feature only
available in 2.6.33+. It's nearly midnight here so I'm going to leave it
at that tonight. I'll do a bisection of the kernel tomorrow, and perhaps
a bisection of the X server, to see where it started crashing between
1.7.5 and 1.8.0.
