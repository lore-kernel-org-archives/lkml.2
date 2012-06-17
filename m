Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2FQOBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 10:01:08 -0400
Received: from canardo.mork.no ([148.122.252.1]:53701 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab2FQOBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 10:01:06 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct usb_device_id)=24 is not a modulo of the size of section __mod_usb_device_table=44.
Organization: m
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
	<20120615201021.GB14544@kroah.com>
	<CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
	<20120615231220.GC8205@kroah.com> <87lijns84s.fsf@nemi.mork.no>
	<m2bokjb6tv.fsf@igel.home>
Date: Sun, 17 Jun 2012 16:00:57 +0200
In-Reply-To: <m2bokjb6tv.fsf@igel.home> (Andreas Schwab's message of "Sat, 16
	Jun 2012 17:43:40 +0200")
Message-ID: <87fw9urqau.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@linux-m68k.org> writes:
> Bjørn Mork <bjorn@mork.no> writes:
>
>> AFAIK (which admittedly is not much wrt cross building) there is no way
>> we can make the host built file2alias know the proper aligment for the
>> structure in the target built modules.  That's the background for this
>> fix: 
>>
>> commit 4ce6efed48d736e3384c39ff87bda723e1f8e041
>> Author: Sam Ravnborg <sam@uranus.ravnborg.org>
>> Date:   Sun Mar 23 21:38:54 2008 +0100
>>
>>     kbuild: soften modpost checks when doing cross builds
>
> This is not a fix in any sense of the word.  modpost can only work
> properly if its view of the device_id structures matches *exactly* that
> of the target.

You are absolutely correct, of course.  I am starting to believe Greg is
correct.  Cross building works mostly by pure luck :-)

I found that the reason the change I referred to above didn't kick in
was because CONFIG_DEBUG_SECTION_MISMATCH was set, causing modpost to be
called from scripts/Makefile.build without the "-c" option:

 # Do section mismatch analysis for each module/built-in.o
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
   cmd_secanalysis = ; scripts/mod/modpost $@
 endif


But as you point out: The whole "soften modpost check" concept is bogus.
It just cannot work.  And I just verified it doing a m68k allmodconfig
build without CONFIG_DEBUG_SECTION_MISMATCH.  modpost will bail out
unless host and target aligment matches:

  scripts/mod/modpost -m -a -o /usr/local/src/build-tmp/linux/Module.symvers    -S  -c -s
drivers/media/video/gspca/gspca_sunplus: struct usb_device_id is 24 bytes.  The last of 55 is:
0x04 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 
FATAL: drivers/media/video/gspca/gspca_sunplus: struct usb_device_id is not terminated with a NULL entry!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


So the prosed fix from Greg is certainly the correct one, until someone
rewrites modpost to be completely cross build safe.


Bjørn
