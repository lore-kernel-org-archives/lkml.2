Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0IWFht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 01:37:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35877 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0IWFhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 01:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gq+mSBi70ujtX2e3KV+QG6WF7A3M/XtNT7Hj726h/GA6csT0i/W1bjBY9oXkVdUY0z
         a1ZvGiZ69fh19FfrDPpGBZ7AOdnrZjE5YwxqCOF/DawxnUKjp7fooYfCbPT6D4ZandEn
         jO0dJSyVZ4fQkqw21Jgt9dIxYB6uATgWx1Ev0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1009212333280.6717@eddie.linux-mips.org>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<1284087065-32722-3-git-send-email-ying.huang@intel.com>
	<alpine.LFD.2.00.1009212333280.6717@eddie.linux-mips.org>
Date: Thu, 23 Sep 2010 13:37:47 +0800
Message-ID: <AANLkTineDMoGdtZUnnDKxCo_Xreud2MUWWn0GR7iDgAa@mail.gmail.com>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR error
From: huang ying <huang.ying.caritas@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Maciej,

On Wed, Sep 22, 2010 at 7:04 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Fri, 10 Sep 2010, Huang Ying wrote:
>
>> memory parity error is only valid for IBM PC-AT, newer machine use 7
>> bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
>> reported via MCE. So corresponding function name and kernel log string
>> is changed.
>
>  Things perhaps changed over the last few years while I have not been
> watching, but for many years the bit #7 of the NMI status port
> (implemented by the southbridge at 0x61 in the port I/O space) was still
> used for memory parity or ECC errors even after the original IBM PC/AT.
> The usual arrangement was in the event of a memory error the memory
> controller in the northbridge would assert the chip's PCI SERR output
> line, which in turn would be trapped by the southbridge and converted to
> an NMI event while setting the said bit in the NMI status port.  See e.g.
> the 82349HX System Controller datasheet (Intel document number 290551).

Thanks for your information. So EDAC function call in NMI handler
should be kept? But as you pointed out, the function name of
corresponding handler should be PCI SERR instead of memory parity. It
just can be used to report memory error on some system. I think we can
rename the function and string to PCI SERR and add some comments for
EDAC function call that checks memory errors.

>  So the name of the error reported is not that unjustified except, of
> course, to be precise the handler would have to scan the state of the SERR
> output reported by all the PCI devices in the PCI configuration space to
> find the originator and then interpret the event accordingly.  Which
> obviously means the only piece of code that could exactly know what the
> reason was is the respective device driver as causes of SERR are
> device-specific and may require processing of device-specific registers to
> determine the cause and/or recover (a device reset may be required in some
> cases).

In addition to PCI SERR, I think modern system rely more on PCIE AER,
which can report more information about error. There are recovery
support for PCIE AER in kernel already. Do we need some similar
mechanism for PCI SERR? Because PCIE AER becomes more and more common
on server platform, I think some minimal check such as scaning devices
SERR/PERR bit should be sufficient.

>  Of course using the MCE seems natural and better, especially if the
> exception can be raised synchronously and stop the failing memory load CPU
> instruction from completion -- this is important for parity and MBE ECC
> errors, where in some cases the handler may be able to retry the failing
> operation having refreshed RAM from the backing store or otherwise the
> affected process must be killed (unless a kernel memory location is
> involved that is, where the whole system has to be brought down).
>
>  OTOH, for CPU stores and DMA transactions the event will always be
> asynchronous and an NMI might be a better option, as in the case of parity
> and MBE ECC errors the whole system will probably have to be brought down,
> and with SBE ECC errors scrubbing can be done at any time and otherwise
> (except from logging and/or marking the physical page bad, as required) no
> action is needed.

In fact, MCE is a special exception, it can be used for asynchronous
events too. Such as memory error detected by patrol scrubbing, please
take a look at latest Intel 64 and IA32 architectures software
developer's manual Vol 3A section 15.9.3: Architecturally Defined UCR
Errors.

Best Regards,
Huang Ying
