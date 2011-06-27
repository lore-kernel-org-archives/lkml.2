Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1F0OXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:23:01 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:37917 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1F0OWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:22:55 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
Date: Mon, 27 Jun 2011 16:22:52 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com> <201106230942.24105.alexander.stein@systec-electronic.com> <4E04206C.5000008@dsn.okisemi.com>
In-Reply-To: <4E04206C.5000008@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271622.52763.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday 24 June 2011 07:28:12 Tomoya MORINAGA wrote:
> Hi Alexander Stein
> 
> I couldn't see the issue at all.
> 
> (2011/06/23 16:42), Alexander Stein wrote:
> > The close and open is actually needed (I had a separate application for
> > that yesterday).
> 
> Does the above mean that we must delete "close" processing from your
> test program, right ?
> (Modifying like this, I couldn't see the issue)

As you've written below, you used setserial to enable DMA mode. I used my own 
application for that using 2 ioctls.

> > If all is done without closing again, I get the following bug:
> Does the above mean that executing your test program many times whose 2
> "close" are deleted , did you see the issue ?

The issue is only printed once. steps in short:
* Enable DMA
* Send 270 chars

> My steps like below
> Boot Fedora14
> Install DMA driver
> Install pch_uart driver
> Enable DMA (setserial /dev/ttyPCH0 ^low_latency)
> Modifying your test program
>   Delete 2 close() function.
> Compile your test program.
> Execute the tp.
> Execute the tp.
> Execute the tp.
> I couldn't see any error message.

Ok. I have a 2.6.39 kernel with the following patches:
pch_phub: Don't panic if dmi_get_system_info returns NULL
drivers/tty/serial/pch_uart.c: don't oops if dmi_get_system_info returns NULL
pch_uart: Add console support

I need these to get a booting board with console support on pch_uart.
After boot (dma and pch_uart compiled into kernel), I do
* setserial /dev/ttyPCH0 ^low_latency
* ./raise_dma_fault
<- Here I get the message

For the reference the used code for raise_dma_fault:
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/serial.h>
int main(int argc, char *argv[])
{
int fd;
char buf[270];

	fd = open ("/dev/ttyPCH0", O_RDWR);
	write (fd, buf, 270);

	close (fd);
	return 0;
}

Maybe you need to enable CONFIG_TRACE_IRQFLAGS and CONFIG_PROVE_LOCKING 
additionally to see the messages.

Regards,
Alexander
