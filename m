Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2HAAru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 20:47:50 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50668 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2HAArs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 20:47:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120622154645.1405.7749.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
	<20120622154645.1405.7749.stgit@localhost.localdomain>
Date: Tue, 31 Jul 2012 17:47:45 -0700
X-Google-Sender-Auth: fK_b9gO1bWwFXQL80dOe2-Girck
Message-ID: <CAE9FiQXfHYTM7PQcfeENHa+WXtrc1vJ2WKKFX=DT3tvJJFGb0w@mail.gmail.com>
Subject: Re: [PATCH 12/12] tty: move the handling of the tty release logic
From: Yinghai Lu <yinghai@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 8:47 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Now that we don't have tty->termios tied to drivers->tty we can untangle
> the logic here. In addition we can push the removal logic out of the
> destructor path.
>
> At that point we can think about sorting out tty_port and console and all
> the other ugly hangovers.
>
> An important other property we now have is that the tty mutex does now cover
> the drivers array. An assumption other bits of the code made and which is
> necessary for the tty lock patch.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>
>  drivers/tty/pty.c               |    8 --------
>  drivers/tty/tty_io.c            |   16 +++++-----------
>  drivers/tty/vt/vt.c             |    1 -
>  drivers/usb/serial/usb-serial.c |    3 +--
>  include/linux/tty.h             |    1 -
>  include/linux/tty_driver.h      |   11 +++--------
>  6 files changed, 9 insertions(+), 31 deletions(-)

Hi, Alan

This one cause regression on my test setup.

that setup is booting from pxe and initrd is updated from opensuse
11.3 rescue disk.

kernel has command line 115200, and later serial console will use
115200 automatically.

but with this one, serial console will switch back to 9600 instead.

bisect said:

36b3c070d2346c890d690d71f6eab02f8c511137 is the first bad commit
commit 36b3c070d2346c890d690d71f6eab02f8c511137
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue Jul 17 17:06:57 2012 +0100

    tty: Move the handling of the tty release logic

    Now that we don't have tty->termios tied to drivers->tty we can untangle
    the logic here. In addition we can push the removal logic out of the
    destructor path.

    At that point we can think about sorting out tty_port and console and all
    the other ugly hangovers.

    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 44db8111f7e5be2f60ae2b41328108a6e533f8a4
d0af41e84b2657e308a92e2ebad04ea5594e6bb4 M	drivers
:040000 040000 f75618c564287072c6a6a9d5462355ab780b06b8
4606b8b123694a2e8aaf1d3708fda66bda843742 M	include
