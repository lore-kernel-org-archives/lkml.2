Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0KTCEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:04:42 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44345 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab0KTCEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WRpPxBIcy/+CqOgViTPwlzKYk8I38EAaAx7D+bbDQgiw4HTze3hPRfjmIIKPegL2N6
         WtGxPcRXXsSmxuO/JkXWECq+S+Ey3WkrNQyfedNlCKBIaVcL9QdGG55zfPJ/VB/whLPz
         3LU4QNP4s6qAoWDtWLj5NQEWxcfuqlLKCtx2M=
MIME-Version: 1.0
In-Reply-To: <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
Date: Sat, 20 Nov 2010 10:04:39 +0800
Message-ID: <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: huang ying <huang.ying.caritas@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 19, 2010 at 12:10 AM, Huang Ying <ying.huang@intel.com> wrote:
>>
>> This is used by APEI ERST and GEHS. But it is a generic hardware
>> error reporting mechanism and can be used by other hardware error
>> reporting mechanisms such as EDAC, PCIe AER, Machine Check, etc.
>
> Yeah, no.
>
> Really.
>
> We don't want some specific hardware error reporting mechanism.
> Hardware errors are way less common than other errors, so making
> something that is special to them just isn't very interesting.
>
> I seriously suggest that the only _sane_ way to handle hardware errors is to
>  (a) admit that they are rare
>  (b) not try to use some odd special mechanism for them
>  (c) just 'printk' them so that you can use the absolutely most
> standard way to report them, and one that administrators are already
> used to and has support for network logging with existing tools etc.

We thought about 'printk' for hardware errors before, but it has some
issues too.

1) It mixes software errors and hardware errors. When Andi Kleen
maintained the Machine Check code, he found many users report the
hardware errors as software bug to software vendor instead of as
hardware error to hardware vendor. Having explicit hardware error
reporting interface may help these users.

2) Hardware error reporting may flush other information in printk
buffer. Considering one pin of your ECC DIMM is broken, tons of 1 bit
corrected memory error will be reported. Although we can enforce some
kind of throttling, your printk buffer may be full of the hardware
error reporting eventually.

3) We need some kind of user space hardware error daemon, which is
used to enforce some policy. For example, if the number of corrected
memory errors reported on one page exceeds the threshold, we can
offline the page to prevent some fatal error to occur in the future,
because fatal error may begin with corrected errors in reality. printk
is good for administrator, and may be not good enough for the hardware
error daemon.

But yes, printk is convenient for administrator or end user. So we
plan to printk some summary information about hardware errors too. But
leave the full hardware error information to the hardware error
specific interface, so that the administrator can get some clue and
hardware error information will not flush the printk buffer.

>  (d) and if you want to make them persistent and NMI-safe, just do
> that on the _printk_ level. That way, any NMI-safeness or persistency
> helps everybody.
>
> I really see _zero_ point to some hw-error-specific model.

Best Regards,
Huang Ying
