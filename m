Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1JJU2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:28:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13090 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1JJU2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:28:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eYyFERehN2Z2okCgfaTJ4F0VmUTui6iHfImCFVECBfibmOoImGSpd17KZIHrJB5gE
	Goj/ZxZEB7qrBp3zhzi7A==
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U2H08ohbgmDxWNPkh8bm8uBPt-2_H2B4cSb9LvEFWdHA@mail.gmail.com>
References: <1318024753-15336-1-git-send-email-dianders@chromium.org>
	<4E900E9E.2070604@gmail.com>
	<CAD=FV=U2H08ohbgmDxWNPkh8bm8uBPt-2_H2B4cSb9LvEFWdHA@mail.gmail.com>
Date: Mon, 10 Oct 2011 13:28:31 -0700
X-Google-Sender-Auth: 7XYbcKKLZrpJcj2DWFwMPRsie_g
Message-ID: <CAD=FV=Vv_FDjYYTZLF8kBaYELy5Lq9en9+9hw8QCVT89KeMnew@mail.gmail.com>
Subject: Re: [PATCH] TTY: serial_core: Fix crash if agetty() run on
 non-console serial port
From: Doug Anderson <dianders@chromium.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Tom Warren <twarren@nvidia.com>,
        Allen Martin <AMartin@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so I've tracked down the source of the HUP.  Unfortunately, it
looks to be hardware that I have no control over.

Specifically, on the nVidia Tegra 250 on UARTB (and probably UARTs C,
D, and E), the DCD / DSR / DTR / RI lines are not pinned out.
However, some of the lines seem to be connected internally.
Specifically, the DTR line appears to be tied to the DCD and DSR lines
for some reason.

What does that mean for us?  It means that when we call this in
uart_suspend_port():
  ops->set_mctrl(uport, 0);

...we'll drop DTR.  ...and because the lines are tied, we'll get a
drop of DCD and DSR.  ...and a drop of DCD is a hangup.


So where does that leave us?

1. I'd like to get rid of the HUP, and it looks like I can use
mcr_mask / mcr_force to do this.  I could do this in a nice way
(adding it as a flag in the serial8250_config structure) so that I
don't need to use the ugly ALPHA_KLUDGE_MCR.  I'll submit a separate
patch for this and make sure to include everyone on this thread.

2. I still think that my original patch has some merit to it.  It
shouldn't hurt anything, and there's always the (very unlikely) case
that someone else could see this if they get a DCD drop at just the
right time during suspend.  If you agree, I'd love to get an ack on
it.  :)


Look for my mcr_mask / mcr_force soon.  I look forward to your
thoughts on the matter.


Thanks again,

-Doug

--

P.S. For the truly interested, here's the writeup I did for
<http://crosbug.com/21461>, which is the bug entry I created in the
Chromium OS project...

Specifically, here's the stack trace of the HUP being thrown into the system:

  <7>[   52.882844] ttyS0 hangup...
  <5>[   52.885986] Backtrace:
  <5>[   52.888770] [<c0053fa4>] (unwind_backtrace+0x0/0xec) from
[<c042ab14>] (dump_stack+0x28/0x30)
  <5>[   52.897853] [<c042ab14>] (dump_stack+0x28/0x30) from
[<c0266f78>] (tty_hangup+0x40/0x6c)
  <5>[   52.906486] [<c0266f78>] (tty_hangup+0x40/0x6c) from
[<c02828fc>] (check_modem_status+0xf4/0x1dc)
  <5>[   52.915914] [<c02828fc>] (check_modem_status+0xf4/0x1dc) from
[<c0283e08>] (serial8250_handle_port+0x2d0/0x300)
  <5>[   52.926591] [<c0283e08>] (serial8250_handle_port+0x2d0/0x300)
from [<c0283e98>] (serial8250_interrupt+0x60/0x134)
  <5>[   52.937449] [<c0283e98>] (serial8250_interrupt+0x60/0x134)
from [<c00c0904>] (handle_IRQ_event+0x88/0x198)
  <5>[   52.947681] [<c00c0904>] (handle_IRQ_event+0x88/0x198) from
[<c00c27d8>] (handle_level_irq+0xf4/0x188)
  <5>[   52.957565] [<c00c27d8>] (handle_level_irq+0xf4/0x188) from
[<c0047320>] (asm_do_IRQ+0x98/0xd8)
  <5>[   52.966810] [<c0047320>] (asm_do_IRQ+0x98/0xd8) from
[<c004cf38>] (__irq_svc+0x38/0xc0)
  <5>[   52.975316] Exception stack(0xf4fe5d28 to 0xf4fe5d70)
  <5>[   52.980800] 5d20:                   c060aac4 a0000093 00000000
00000000 c0698988 f5000800
  <5>[   52.989504] 5d40: c05f7cc0 f5000840 c05f7c08 00000000 f5000838
f4fe5da4 f4fe5d28 f4fe5d70
  <5>[   52.998192] 5d60: c005b2b4 c0281000 60000013 ffffffff
  <5>[   53.003688] [<c004cf38>] (__irq_svc+0x38/0xc0) from
[<c0281000>] (uart_suspend_port+0x18c/0x2e8)
  <5>[   53.013023] [<c0281000>] (uart_suspend_port+0x18c/0x2e8) from
[<c0282a70>] (serial8250_suspend+0x4c/0x68)
  <5>[   53.023176] [<c0282a70>] (serial8250_suspend+0x4c/0x68) from
[<c0292b40>] (platform_pm_suspend+0x58/0x6c)
  <5>[   53.033321] [<c0292b40>] (platform_pm_suspend+0x58/0x6c) from
[<c029654c>] (pm_op+0x60/0xbc)
  <5>[   53.042297] [<c029654c>] (pm_op+0x60/0xbc) from [<c0296d8c>]
(__device_suspend+0x138/0x1c8)
  <5>[   53.051184] [<c0296d8c>] (__device_suspend+0x138/0x1c8) from
[<c029715c>] (dpm_suspend_start+0x2ec/0x3dc)
  <5>[   53.061333] [<c029715c>] (dpm_suspend_start+0x2ec/0x3dc) from
[<c00b89cc>] (suspend_devices_and_enter+0xa8/0x2e0)
  <5>[   53.072189] [<c00b89cc>]
(suspend_devices_and_enter+0xa8/0x2e0) from [<c00b8cdc>]
(enter_state+0xd8/0x140)
  <5>[   53.082415] [<c00b8cdc>] (enter_state+0xd8/0x140) from
[<c00b80c4>] (state_store+0xb4/0xc8)
  <5>[   53.091306] [<c00b80c4>] (state_store+0xb4/0xc8) from
[<c02258ac>] (kobj_attr_store+0x1c/0x28)
  <5>[   53.100474] [<c02258ac>] (kobj_attr_store+0x1c/0x28) from
[<c0170628>] (sysfs_write_file+0x118/0x14c)
  <5>[   53.110272] [<c0170628>] (sysfs_write_file+0x118/0x14c) from
[<c011e050>] (vfs_write+0xc4/0x140)
  <5>[   53.119608] [<c011e050>] (vfs_write+0xc4/0x140) from
[<c011e2cc>] (sys_write+0x4c/0x78)
  <5>[   53.128136] [<c011e2cc>] (sys_write+0x4c/0x78) from
[<c004d380>] (ret_fast_syscall+0x0/0x30)


The check_modem_status+0xf4 is actually the line:
  uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);

The uart_suspend_port()+0x18c is the unlocking of the IRQ following the line:
  ops->set_mctrl(uport, 0);


I've gone digging and it looks like the set_mctrl() ends up changing
MCR from 0x0b to 0x00.  In the progress, the MSR goes from 0xb0 to
0x1a.  Decoding that...

MCR:
  * RTS:    disable
  * CTS:    disable
  * LOOKBK: disable
  * OUT2:   enable         => disable
  * OUT1:   disable
  * RTS:    FORCE_RTS_LOW  => FORCE_RTS_HI
  * DTR:    FORCE_DTR_LOW  => FORCE_DTR_HI

MSR:
  * CD:   1  => 0
  * RI:   0
  * DSR:  1  => 0
  * CTS:  1

  * DCD:  0  => 1
  * DRI:  0
  * DDSR: 0  => 1
  * DCTS: 0

I tracked the changes to MCR down one bit at a time, and it appears
the the DTR bit change is the magic bit.  I'm guessing that DTR is
routed internally back to the CD and DSR lines (the lines don't appear
to be externally available on the CPU according to the tech reference
manual).
  <6>[   41.302967] set_mctrl MSR starts at b0
  <6>[   41.307640] set_mctrl MCR 0b => 03, MSR became b0
  <6>[   41.313289] set_mctrl MCR 03 => 01, MSR became b0
  <6>[   41.318937] set_mctrl MCR 01 => 00, MSR became 1a

...and just to confirm I didn't mess up, I tried the other order:
  <6>[   54.522910] set_mctrl MSR starts at b0
  <6>[   54.527577] set_mctrl MCR 0b => 0a, MSR became 1a
  <6>[   54.533226] set_mctrl MCR 0a => 08, MSR became 1a
  <6>[   54.538870] set_mctrl MCR 08 => 00, MSR became 1a

---

On Sat, Oct 8, 2011 at 8:55 AM, Doug Anderson <dianders@chromium.org> wrote:
>
> On Sat, Oct 8, 2011 at 1:49 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> > I cannot reproduce this. What uart driver is this with? And where does
> > it call uart_suspend_port from? Basically, it would mean that it calls
> > uart_suspend_port while userspace is still running? Or who HUPs the port
> > (the second point in your list)?
>
> Thank you for testing!  I am working with the 8250 driver controlling
> the onboard UART on an nVidia Tegra T25 (ARM).
>
> You raise very good questions, and I'm happy to keep tracking down to
> continue to look for a deeper root cause.  I continued to do some more
> testing of this patch (with the help of a few others) after posting
> the list.  We tried the same setup on an x86-based board and the HUP
> doesn't show up.  ...so my patch wasn't needed on that board (although
> my patch didn't hurt).  ...that means, as you already pointed out,
> that the HUP must _not_ be coming from userspace.
>
> Probably the true bug in my system is that a spurious HUP is being
> generated as a result of the suspend.  That is probably platform
> dependent and would explain why this hasn't been a bigger problem for
> others.
>
>
> ...however, even though my patch shouldn't be needed for any hardware
> that doesn't generate the spurious HUP, it might still be worthwhile
> to consider including it?  ...or perhaps changing it to a BUG_ON or
> WARN_ON to at least detect the case of running the shutdown code after
> the suspend code?  Definitely the case that I ran into (shutdown after
> suspend) will definitely cause a crash during resume.
>
>
> I will spend time on Monday digging into the source of the HUP and
> will post a followup.
>
> -Doug
