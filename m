Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1FPTwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:52:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44143 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1FPTwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VCJjPrHlCmJHbnf4LfvxhV+vHhwAIr+Necw3rcE4dAnWH27k+3WkP2aZv/8Mtv+aAm
         9gtar3K44MRileETx6Ri0aP6OW2LRE9PV8ImkZky5FEsCfPa8Er7f0BBS7z3w9wrRuU2
         zmMqlT7ohhS4QoAL+Jp2HdGvaP6hVtsyt9Gic=
Message-ID: <4DFA5EFD.6020608@gmail.com>
Date: Thu, 16 Jun 2011 12:52:29 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Feng Tang <feng.tang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        alan@linux.intel.com, alek.du@intel.com
Subject: Re: [PATCH 3/5] dw_spi: rework message processing
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com> <1308158588-17249-4-git-send-email-dirk.brandewie@gmail.com> <20110616220003.7ac89d56@feng-i7> <4DFA3D30.2070909@gmail.com> <BANLkTinaP5w4N-pnoWMor-JWQfC8mc9yWg@mail.gmail.com>
In-Reply-To: <BANLkTinaP5w4N-pnoWMor-JWQfC8mc9yWg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 10:38 AM, Grant Likely wrote:
> On Thu, Jun 16, 2011 at 11:28 AM, Dirk Brandewie
> <dirk.brandewie@gmail.com>  wrote:
>> On 06/16/2011 07:00 AM, Feng Tang wrote:
>>>
>>> 4. I saw you enable both TX/RX interrupt when doing interrupt transfer,
>>> spi
>>>     devices' TX/RX are born to be simutaneous, when one word is sent over
>>>     TX line, a RX word will be received from RX line, so both the orignal
>>>     interrupt transfer handling written by me and the later optimization
>>>     from Alek Du only enable TX interrupt, which will only generate half of
>>>     IRQs comparing to enble both TX/RX, this is huge when the data rate is
>>>     several Mb per second
>>
>> I the current driver the txfltr register is set to 0 (FIFO empty) in the
>> interrupt transfer case which will drop chip select every FIFO length bytes.
>>
>> In my transfer setup the RX FIFO interrupt is set to a value lower than the
>> TX threshold which will keep both interrupts from firing at the same time.
>>
>> The TX interrupt will drive the transfer until there are less than
>> tx_threshold bytes left to transfer then by the RX interrupt to drive the
>> remainder of the transfer without dropping chip select.
>
> Be careful here.  Can you guarantee that the kernel will process the
> IRQ before the FIFO drains?  If not, then you'll need something more
> reliable.

I can't guarantee when IRQ are processed :-)

Without actual control over when chip is de-asserted I don't think we guarantee 
that chip select will be not dropped, chip select is dropped when the TX fifo 
goes empty.

With a sufficiently high bitrate client, heavily loaded system and fixed size 
fifo we are domed at some point.  As tx_threshold approaches fifo depth you give 
yourself a bigger buffer in time but increase the number of interrupts you need 
to deal with increasing the system load.

For high bitrate devices the client driver should be using DMA IMHO to work 
around this limitation in the designware IP.  Of course this doesn't solve the 
problem of chip select dropping between transfers in the same message.

I took a SWAG at tx_threshold in my changes to try to limit the number of 
interrupts it will need tuning for a reasonable default and likely the addition 
of a module parameter or platform data to set it for any given SOC/system.

--Dirk




