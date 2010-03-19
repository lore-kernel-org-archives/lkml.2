Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0CSL7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:59:10 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:38506 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0CSL7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ErxpapBFYG4/aglMwA3sSp/HceySJoezzZlW7g/xsxW9dXweR4h25RqOwEveAw2mtJ
         yg5S6A1lQglqr/3I4zjTi8s3AQfZo9LNZLfSB9WmSYCHQ4td7XS3Ls6j7g4+ctA+mrHs
         ZJM9MpL8RUL1ZbnRvKQspe2H1UVK2bWyu9Dio=
MIME-Version: 1.0
In-Reply-To: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
Date: Fri, 19 Mar 2010 07:59:04 -0400
Message-ID: <9e4733911003190459l570af3cn16530c1ece989e2@mail.gmail.com>
Subject: Re: [PATCH 0/5] V2 usb console improvements series
From: Jon Smirl <jonsmirl@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 5:05 PM, Jason Wessel
<jason.wessel@windriver.com> wrote:
> I aggregated and ported all usb patches I have previously posted which
> are not mainlined into a single series aimed at providing a stable usb
> console.

Jason, are you aware that the FTDI chips correctly signals the RTS/CTS
lines when it is busy doing USB processing? They work ok ignoring
RTS/CTS up to about 600Kb/s. For higher baud rates you needs to
implement RTS/CTS. My embedded system has a DMA based serial port that
I am running at 2Mb/s. The RTS/CTS handshake works to automatically
flow control the hardware DMA system. If you don't do this the chip
will simply drop the characters.


>
> Greg Kroah-Hartman already picked up the first 2 patches in the
> series, but for completeness they are provided here because one of the
> other patches requires the context changes.
>
> Differences in V2 vs V1 patch set
>  * The optimize usb sysrq was dropped entirely
>  * Removed the unused export symbol per Alan Stern's comments
>  * Updated the definition of usb_poll_irq() per Alan Stern's comments
>
>
> Thanks,
> Jason.
>
>
> -- The recap about synchronous usb serial consoles --
>
> This is picking up where Alan Stern and I left off after a discussion
> in September 2009.
>
> The serial uart code implements the console writes synchronously such
> that you get the data right away and "pay the toll" in terms of system
> performance loss if you do lots of printk's to the console.  The usb
> serial console code just eats the data if there is no room left in the
> queue, and you do not see the data until the interrupts are restored.
>
> If we assume the main reason you would use a usb console device is to
> get printk's then every effort should be made to be able to see the
> printk's on the usb console device.  In this patch series, two
> conditions must be met before the hcd device would get polled.
>
> 1) The data write is a usb serial console write
> 2) The usb serial driver has set the variable max_in_flight_urbs
>
> Based on Alan's comments about the 1ms minimum response time for the
> hcd device I ended up using a maximum 3ms delay loop.  The 3ms was
> selected based on testing the usb_debug device and the ftdi usb rs232
> port.  I found the usb_debug device needed the 1ms and the ftdi device
> required slightly more than 2ms in the worst case else there was some
> sporadic data loss.
>
> I also tested incurring the penalty 3ms for each write with the device
> in a "failed" capacity.  In that case it introduced a 3ms delay for
> each printk() which only showed any noticeable delay with the "SysRq t"
> packet.
>
> Part of having the console stable requires that usb sysrq handler get
> executed in a tasklet.  The hcd device lock is always held while the
> driver call backs are executed.  The means you cannot get the sysrq
> printk's out to the usb console device after the in_flight urb queue
> is filled.
>
> Thanks,
> Jason.
>
> ---
>
> The following changes since commit a3d3203e4bb40f253b1541e310dc0f9305be7c84:
>  Linus Torvalds (1):
>        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh
>
> Jason Wessel (5):
>      tty_port,usb-console: Fix usb serial console open/close regression
>      usb-serial: Use tty_port version of console instead of the usb_serial_port version
>      usb-console: pass baud from console to the initial tty open
>      usb-hcd,usb-console: poll hcd device to force usb console writes
>      usb-serialy,sysrq: Run the sysrq handler in a tasklet
>
>  drivers/char/sysrq.c            |   29 ++++++++++++++++
>  drivers/char/tty_port.c         |    2 +-
>  drivers/usb/core/hcd.c          |   10 +++++
>  drivers/usb/serial/console.c    |   70 ++++++++++++++++++++++----------------
>  drivers/usb/serial/ftdi_sio.c   |    9 +++--
>  drivers/usb/serial/generic.c    |    6 ++--
>  drivers/usb/serial/pl2303.c     |    8 +++--
>  drivers/usb/serial/usb-serial.c |    4 +-
>  drivers/usb/serial/usb_debug.c  |    2 +-
>  include/linux/sysrq.h           |    4 ++
>  include/linux/tty.h             |    1 +
>  include/linux/usb.h             |    3 ++
>  include/linux/usb/serial.h      |    2 -
>  13 files changed, 104 insertions(+), 46 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
