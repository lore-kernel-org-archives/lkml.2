Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161037Ab2ERKFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:05:11 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:55605 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967310Ab2ERKFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:05:09 -0400
Message-ID: <4FB61ECE.6060202@mev.co.uk>
Date: Fri, 18 May 2012 11:05:02 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH] staging: comedi: Convert struct addi_board initialization
 to C99 format
References: <201205161751.56913.hartleys@visionengravers.com> <20120517021805.GA32592@kroah.com> <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net> <4FB49E74.8030409@mev.co.uk> <20120517133221.GB5090@kroah.com> <4FB51FFA.3090800@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698AE0FF8@AUSP01VMBX24.collaborationhost.net> <4FB54356.5020203@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698AE1119@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698AE1119@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-17 22:12, H Hartley Sweeten wrote:
> On Thursday, May 17, 2012 11:29 AM, Ian Abbott wrote:
>> On 17/05/2012 17:38, H Hartley Sweeten wrote:
>>> BTW, what actual hardware do you have available to test with?
>>
>> Not a lot.  Just the Amplicon cards (amplc_* drivers).
>
> Speaking of the amplc_* drivers... What's up with them?
>
> The dio200, pc236, and pc263 drivers appear to be some kind of
> hybrid comedi driver/comedi pci driver.

That's right.  The ISA devices and PCI devices are selected separately 
in the configuration, but they are similar enough to share the same code.

> If the driver is simply
> registered as a comedi pci driver will the isa drivers still work?

Yes if both the ISA devices and PCI devices are enabled in the 
configuration.  But you might have one or the other.

In amplc_dio200.c (for example, but similarly for the others), you can 
assume that at least one of the CONFIG_COMEDI_AMPLC_DIO200_ISA and 
CONFIG_COMEDI_AMPLC_DIO200_PCI macros is #define'd, so you could do 
(with the existing variable names, that you'd probably change):

#ifdef CONFIG_COMEDI_AMPLC_DIO200_PCI
module_comedi_pci_driver(driver_amplc_dio200, 
driver_amplc_dio200_pci_driver);
#else
module_comedi_driver(driver_amplc_dio200);
#endif

(I guess you'd change driver_amplc_dio200 to amplc_dio200_driver and 
driver_amplc_dio200_pci_driver to amplc_dio200_pci_driver.)

> If so we can get rid of a bunch of #ifdef stuff.

Some of them are there to separately configure the ISA and PCI devices 
and some are just there to trim out some code that is unreachable when 
one or the other isn't defined.

I tend not to include several functions within the same #ifdef, so it 
should be easy to move things around to avoid forward declarations.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
