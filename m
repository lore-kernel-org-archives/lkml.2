Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2FKHwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:52:12 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:58461 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2FKHwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:52:11 -0400
Message-ID: <4FD5A3A8.4020305@ladisch.de>
Date: Mon, 11 Jun 2012 09:52:08 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Boszormenyi Zoltan <zboszor@pr.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
References: <4FD4F45D.5050103@pr.hu>
In-Reply-To: <4FD4F45D.5050103@pr.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boszormenyi Zoltan wrote:
> I have an AMD FX-8120 boxed CPU in an ASUS M5A99X-EVO mainboard
> with 32GB DDR3/1600 memory, running Fedora 17, upgraded from 16.
>
> I get occasional crashes and signal 11 during kernel compilation even
> with single-job make. Sometimes the compiler jumps out with a strange
> error message, like "stray \NNN character in the source". When re-running
> make, the error doesn't happen in the same file and the source file doesn't
> contain the character being complained about when inspecting with
> an editor or hexdump.
>
> Now, a few minutes ago I was able to catch this bug when I copied the
> kernel GIT tree to apply a patch manually and did "git commit -a".
> Strangely, the commit contained one extra file that I didn't touch.
> git diff showed this for the extra file:
>
> ==============================
> --- a/drivers/usb/gadget/fsl_usb2_udc.h
> +++ b/drivers/usb/gadget/fsl_usb2_udc.h
> @@ -427,7 +427,7 @@ struct ep_td_struct {
>  #define  DTD_ADDR_MASK                        0xFFFFFFE0
>  #define  DTD_PACKET_SIZE                      0x7FFF0000
>  #define  DTD_LENGTH_BIT_POS                   16
> -#define  DTD_ERROR_MASK                       (DTD_STATUS_HALTED | \
> +#define  DTD_ERROR_MASK                       (DTD_STATUS_HALTED | ^Z
>                                                 DTD_STATUS_DATA_BUFF_ERR | \
>                                                 DTD_STATUS_TRANSACTION_ERR)
>  /* Alignment requirements; must be a power of two */
> ==============================
>
> The "^Z" is a 0-character in the file and is not present in the
> original source tree, only in the copy.

Is it always a zero, or other invalids characters?
(The (number of) changed bits might tell something.)

> Similar errors happened during copying large files on the same
> machine but it seems it's enough to trigger if the total amount
> of data read is large enough.

Does "large enough" mean "large enough so that they are not in the file
cache"?

All caches and your memory are ECC protected, so I think it is unlikely
that the problem is with these.  If I had to guess, I'd point to your
disk (firmware) or the SATA controller.  (A bad or loose SATA cable
would throw CRC errors into the kernel log.  Are there any?)

What is the exact offset of the changed byte in the file?  (It might be
at a cacheline, sector, or page boundary.)

> Does anyone know whether it's a known problem in AMD FX CPUs?

http://support.amd.com/us/Processor_TechDocs/48063_15h_Mod_00h-0Fh_Rev_Guide.pdf


Regards,
Clemens
