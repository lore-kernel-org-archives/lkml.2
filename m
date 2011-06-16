Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab1FPRi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:38:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48704 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab1FPRi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <4DFA3D30.2070909@gmail.com>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
 <1308158588-17249-4-git-send-email-dirk.brandewie@gmail.com>
 <20110616220003.7ac89d56@feng-i7> <4DFA3D30.2070909@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 16 Jun 2011 11:38:05 -0600
X-Google-Sender-Auth: gThVR4YYYcMoqxvTW8hkcWNhiq4
Message-ID: <BANLkTinaP5w4N-pnoWMor-JWQfC8mc9yWg@mail.gmail.com>
Subject: Re: [PATCH 3/5] dw_spi: rework message processing
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        alan@linux.intel.com, alek.du@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 11:28 AM, Dirk Brandewie
<dirk.brandewie@gmail.com> wrote:
> On 06/16/2011 07:00 AM, Feng Tang wrote:
>>
>> Hi Dirk,
>>
>> IMHO, the patch is too big, it contains too many changes to the original
>> drivers, and we can't see clearly what you've changed to each logical
>> code part or section, If possible, could you separate this patch to
>> several small ones in a logical way.
>>
>> First, I have some questions, what devices have you tested with this
>> patch?
>> high speed, low speed? Do you have any performance data to show the
>> benefit
>> of this change? Current dw_spi driver has been tested with many devices,
>> so
>> to not break them or cause obvious regression, we have to be cautious.
>
> See Thread with grant for list of environments where it has been tested.
> The boot time of the platforms it is being used on decreased 2-5 seconds
> with no regressions reported.  It has been in use/under test for ~3 months
> in various Meego and Android builds.  It clears all the bugs reported
> against the driver that I am aware of.  If you can give me pointers to
> teams/projects that are using v2.6.37+ kernels I would be more that happy to
> provide them with patches for their kernel to ensure we get the most
> comprehensive test possible.
>
>>
>> Here are some general comments according to the commit logs:
>> 1. I think the threaded irq handling is a good idea. And let driver chose
>> to
>>    use poll or interrupt is good, some other spi controller driver has
>> used
>>    that way for a long time
>> 2. Why you remove the cs_change code, in some case, the controller is only
>>    be used by one device, we don't need do the config for every single
>>    spi_transfer
>
> There is no guarantee that all the transfers in a given spi_message have the
> same values for  speed_hz, bits_per_word, cs_change and delay_usecs atleast
> nothing I could find put that restriction in place. Since we need to deal
> with possible changes (although unlikely) it gets rid some state we need to
> maintain and makes the code path common for all transfers.
>
>> 3. Why do you remove the chip select control code, dw_spi controller hw
>> has
>>    some problem in chip select controller by SER, and thus many devices
>> has
>>    to use external GPIO has their chip select, this is real world usages!
>
> Which devices/platforms are you referring to?  I was unable to find any
> platforms or client drivers using this functionality. If they are not public
> please respond internally.  In any case it is mute since I already agreed to
> put is back in in my response to Grant.
>
>> 4. I saw you enable both TX/RX interrupt when doing interrupt transfer,
>> spi
>>    devices' TX/RX are born to be simutaneous, when one word is sent over
>>    TX line, a RX word will be received from RX line, so both the orignal
>>    interrupt transfer handling written by me and the later optimization
>>    from Alek Du only enable TX interrupt, which will only generate half of
>>    IRQs comparing to enble both TX/RX, this is huge when the data rate is
>>    several Mb per second
>
> I the current driver the txfltr register is set to 0 (FIFO empty) in the
> interrupt transfer case which will drop chip select every FIFO length bytes.
>
> In my transfer setup the RX FIFO interrupt is set to a value lower than the
> TX threshold which will keep both interrupts from firing at the same time.
>
> The TX interrupt will drive the transfer until there are less than
> tx_threshold bytes left to transfer then by the RX interrupt to drive the
> remainder of the transfer without dropping chip select.

Be careful here.  Can you guarantee that the kernel will process the
IRQ before the FIFO drains?  If not, then you'll need something more
reliable.

g.
