Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1E2T53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:57:29 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42362 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab1E2T50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=pMOvxOsKrE50youhZ5+7NOaZ2R1D6vmaHhmN38kHt05EJvN/Pk5DX6K0AJpPw/Ma38
         0ceq58IbmfwiPjqorwT0+uoixyZMt/PyS1gQOvoAzuX7+8dHQaqtCjlNff8Z+4Tg1Qq/
         QBdr0ZNUY7Kg3QIISvWBUpU9Jqv+P114D/uR8=
MIME-Version: 1.0
In-Reply-To: <20110529194922.GC13539@elte.hu>
References: <cover.1306517576.git.luto@mit.edu> <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
 <20110529191055.GC9835@elte.hu> <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
 <20110529194922.GC13539@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 15:57:05 -0400
X-Google-Sender-Auth: ouupILT3h8XFgdo7fu03Tbt1dxk
Message-ID: <BANLkTi=w37QWARQCOTLVXQq6EiW0rdDfcw@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 3:49 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> > Ok, i suspect you marked it 0xCC because that's the INT3 instruction
>> > - not very useful for exploits?
>>
>> Exactly.
>>
>> The comments in irq_vectors.h make it sound like vectors 0x81..0xed
>> are used for device interrupts but AFAICT it's only 0x20..0x39 that
>> are used, so the precise choice of vector doesn't matter that much.
>
> No, we use almost all of the vector space for device interrupts. Why
> do you think only 0x20..0x39 is used?

Possibility my inability to understand all the IRQ mapping code in
just half an hour of trying.

In arch/x86/kernel/irq.c, arch_probe_nr_irqs returns NR_IRQS_LEGACY,
which I think means that the genirq code allocates will only expect
IRQs on that many vectors.

If I'm wrong then my patch could be bad: if something tries to use
vector 0xcc for a device interrupt, then the vsyscall emulation code
will eat that interrupt.

(0xcc is barely below the maximum.  INVALIDATE_TLB_VECTOR_START could
be as low as 0xcf.)

--Andy
