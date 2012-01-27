Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2A0JUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:20:39 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42398 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab2A0JUf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:20:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP12Bj1K3j5HL1=GTj=xEC+oWgB7VFeQL_Pg23fCevTQAcw@mail.gmail.com>
References: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
	<58311.79.160.186.248.1327615864.squirrel@www.nlc.no>
	<CAFLxGvzsg71gtyPEtOAVnS-DtozYzqgoGNK-ZJRvBfq1mf3Oug@mail.gmail.com>
	<CAFLxGvzffs=uSjxogdWtk_gqoJHPnmgQSLw9WaZRr_be=J5cgw@mail.gmail.com>
	<20120127010838.GA27899@suse.de>
	<CAPXgP12Bj1K3j5HL1=GTj=xEC+oWgB7VFeQL_Pg23fCevTQAcw@mail.gmail.com>
Date: Fri, 27 Jan 2012 10:20:33 +0100
Message-ID: <CAFLxGvzth1m=iUmXbU2WyGrw0i8441d2nKLjH=mY_f1O-hkKPQ@mail.gmail.com>
Subject: Re: [uml-devel] /sys/class/tty/tty0/active?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, stian@nixia.no,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Kay,

>> Is that a problem for UML somehow?

The login on ttyX takes 30+ seconds.
This very ugly and mostly wrong hack makes the login fast again:
mount -o bind /sys/class/tty/console/ /sys/class/tty/tty0/

/sys/class/tty/console/active exists and contains "tty0"...

> In general, the "crippled" environments might not really the right
> thing too run full-blown user login managers like logind.
>
> The main systemd 'init' will not have any problems with that, but
> running logind might not really work out under UML.
>
> Depending how far full-OS support in UML should go, logind should
> either not run inside UML, or if, UML should provide the needed bits
> for in virtual consoles.

Any x86 distribution works fine in UML.
If this will be no longer true due to systemd then better no systemd developer
ever crosses my way. ;-)

> If it is not to be solved otherwise, maybe logind needs more
> VT-avoiding logic like this:
>  http://cgit.freedesktop.org/systemd/systemd/commit/?id=addedec48ba0ffc4472ef6d3b5a45c9d4239f1cd

Yeah, would make sense.
Many systems don't have CONFIG_VT set.

One good thing is that systemd seems to uncover a nasty bug in UML's
console driver.
A login on tty0 crashes UML.

UML's console driver (arch/um/drivers/line.c) implements tty_operations.
The crash happens because the tty subsystem calls the driver's close()
function and later
write_room() or chars_in_buffer().

write_room() and chars_in_buffer() fail badly because close() already
cleaned up the driver's private data...

Greg, is UML's assumption wrong that after closing the tty no call to
write_room() or chars_in_buffer() can happen?
I have no idea why systemd is able to trigger this, UML's console
driver is old and has always worked quite well.

-- 
Thanks,
//richard
