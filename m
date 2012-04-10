Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2DJRgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:36:25 -0400
Received: from mga05.intel.com ([192.55.52.89]:45070 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757856Ab2DJRgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:22 -0400
MIME-Version: 1.0
In-Reply-To: <4F84575F.7090909@wwwdotorg.org>
References: <20120409194514.8004.53204.stgit@dwillia2-linux.jf.intel.com>
	<20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
	<4F84575F.7090909@wwwdotorg.org>
Date: Tue, 10 Apr 2012 10:36:19 -0700
Message-ID: <CABE8wwsDM=4Lp5Fa79V29tG2RypfA-MxN7zfhtze7sOLCVdL7A@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] tegra, serial8250: add ->handle_break() uart_port op
From: Dan Williams <dan.j.williams@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        linux-kernel@vger.kernel.org, ArndBergmannarnd@arndb.de,
        Grant Likely <grant.likely@secretlab.ca>, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 8:53 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/09/2012 01:48 PM, Dan Williams wrote:
>> The "KT" serial port has another use case for a "received break" quirk,
>> so before adding another special case to the 8250 core take this
>> opportunity to push such quirks out of the core and into a uart_port op.
>
>> diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
> ...
>> +CONFIG_SERIAL_TEGRA=y
>
> Instead of that,
>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> ...
>> +# FIXME remove this option when Tegra completes conversion to open firmware
>> +config SERIAL_TEGRA
>> +     bool "Tegra serial port support"
>> +     depends on SERIAL_OF_PLATFORM=y
>> +     help
>> +       If you have a machine based on NVIDIA Tegra you can enable its
>> +       onboard serial ports by enabling this option.
>> +
>
> Can we just make that default y if ARCH_TEGRA?
>
> defconfig changes are apparently a little touchy.
>
> Actually, why even introduce a new config variable; why not replace the
> ifdefs in of_serial.[ch] with CONFIG_ARCH_TEGRA?

Nice, yes, that makes things a bit cleaner.

>> --- a/arch/arm/mach-tegra/devices.h
>> +++ b/arch/arm/mach-tegra/devices.h
>> @@ -53,5 +53,4 @@ extern struct platform_device tegra_i2s_device1;
>>  extern struct platform_device tegra_i2s_device2;
>>  extern struct platform_device tegra_das_device;
>>  extern struct platform_device tegra_pcm_device;
>> -
>>  #endif
>
> That's left over from a previous patch version.

yep.

>> @@ -84,6 +106,9 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
>>               | UPF_FIXED_PORT | UPF_FIXED_TYPE;
>>       port->dev = &ofdev->dev;
>>
>> +     if (type == PORT_TEGRA)
>> +             port->handle_break = tegra_serial_handle_break;
>
> This is going to mean that everything in 8250.c:uart_config[] will move
> into the exact same data structure in of_serial.c eventually, so I still
> don't see the point of this exercise. But, I guess I won't argue against
> it any more.

To me serial8250_config is about serial port geometries, uart_port ops
are about quirks.  Once open firmware needs to deal with a serial port
with a standard geometry but with a runtime quirk this approach of
just looking at the type will need to be revisited.  The fact that
'PORT_TEGRA' is enough to identify the geometry and the quirk is
serendipitous.

>> diff --git a/include/linux/of_serial.h b/include/linux/of_serial.h
> ...
>> + * FIXME remove this file when tegra finishes conversion to open firmware,
>
> remove this *prototype* not *file*?

The entire file should go away since it is only there to export
tegra_serial_handle_break to the deprecated board files.  Once this is
open firmware only tegra_serial_handle_break can be marked static,
right?

--
Dan
