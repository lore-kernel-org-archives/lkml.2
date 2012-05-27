Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2E0JGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 05:06:53 -0400
Received: from antcom.de ([188.40.178.216]:60040 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab2E0JGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 05:06:51 -0400
Message-ID: <4FC1EEA7.2060109@antcom.de>
Date: Sun, 27 May 2012 11:06:47 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC] serial/8250: Adjusting FIFO parameters for LPC32xx
References: <1338048678-23991-1-git-send-email-stigge@antcom.de> <201205270232.58253.arnd@arndb.de>
In-Reply-To: <201205270232.58253.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/05/12 04:32, Arnd Bergmann wrote:
>> this is how the modified FIFO is handled in the repositories at
>> git.lpclinux.com. Is there a better way for doing this (without ifdef)?  Looks
>> like registering additional types (like PORT_16550A) isn't encouraged.  Maybe
>> extending of_serial.c? The latter currently doesn't handle .fifosize and
>> .tx_loadsz, though.
>>
>> Any suggestions appreciated.
> 
> We occasionally add new types, and I think that would be ok here too, if it's
> actually a new type. It definitely doesn't look like a 16550.
> 
> I wonder if it's in fact a PORT_16654, or if we can at least pretend it's one.

Thanks for the hint!

I did it via the following modification in of_serial.c:

--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -179,6 +179,7 @@ static struct of_device_id __devinitdata of_platform_serial_table[] = {
        { .compatible = "ns16450",  .data = (void *)PORT_16450, },
        { .compatible = "ns16550a", .data = (void *)PORT_16550A, },
        { .compatible = "ns16550",  .data = (void *)PORT_16550, },
+       { .compatible = "ns16654",  .data = (void *)PORT_16654, },
        { .compatible = "ns16750",  .data = (void *)PORT_16750, },
        { .compatible = "ns16850",  .data = (void *)PORT_16850, },
        { .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },

Works for now, will need to test more thoroughly with LPC32xx (note that
the manual explicitly mentions "downwards compatible with the INS16Cx50"
and "Register locations conform to ‘550 industry standard" but nothing
about an EFR register which 16654 is configured for in 8250.c).

The patch should be useful in of_serial anyway (even without the LPC32xx
case).

Wondering if it should rather be .compatible = "st16654"?
Will prepare a patch with adjustment of Documentation/.../of-serial.txt when
we agree on sth.

Thanks,

Roland
