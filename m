Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1APVZC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:25:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1APVZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qdOM7xmp7MVdWyfQwu9Jju9uJs1oXizD/CyjnqpH70LdosrIw8+c1D6pfx9moolvEC
         kBkJ6b7n22eUGfGK+Uv/igDlSPnisUGZGzFVsNfgh2ieoJMCoUu4aa4TRfoxJqyZp+RV
         7xYlAyXkB3m4emmHPD9+Fs7Cl57RP76iQUMp0=
MIME-Version: 1.0
In-Reply-To: <20110115154019.GF15996@n2100.arm.linux.org.uk>
References: <1294990949-2729-1-git-send-email-ccross@android.com>
	<AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
	<20110114120229.GA15996@n2100.arm.linux.org.uk>
	<1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
	<20110114154919.GE15996@n2100.arm.linux.org.uk>
	<1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
	<20110114163520.GH15996@n2100.arm.linux.org.uk>
	<1295024327.7901.70.camel@e102109-lin.cambridge.arm.com>
	<20110114173050.GJ15996@n2100.arm.linux.org.uk>
	<AANLkTin_pMzNc-ZL+rVcwaVawer0poyxhatqw5P-A2qW@mail.gmail.com>
	<20110115154019.GF15996@n2100.arm.linux.org.uk>
Date: Sun, 16 Jan 2011 21:25:00 +0000
X-Google-Sender-Auth: Ml2Z0Pr6FIcTgWhwfHkVcRgDo6s
Message-ID: <AANLkTim8OhAtqADck0Snq-7z7opw=coiQ4=DeO0O7Qa-@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2011 15:40, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Jan 15, 2011 at 03:31:04PM +0000, Catalin Marinas wrote:
>> On 14 January 2011 17:30, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > +@  r9  = normal "successful" return address
>> >  @  r10 = vfp_state union
>> >  @  r11 = CPU number
>> > -@  lr  = failure return
>> > -
>> > +@  lr  = unrecognised instruction return address
>> > +@  IRQs enabled.
>> >  ENTRY(vfp_support_entry)
>> >        DBGSTR3 "instr %08x pc %08x state %p", r0, r2, r10
>> >
>> > @@ -138,9 +138,12 @@ check_for_exception:
>> >                                        @ exception before retrying branch
>> >                                        @ out before setting an FPEXC that
>> >                                        @ stops us reading stuff
>> > -       VFPFMXR FPEXC, r1               @ restore FPEXC last
>> > -       sub     r2, r2, #4
>> > -       str     r2, [sp, #S_PC]         @ retry the instruction
>> > +       VFPFMXR FPEXC, r1               @ Restore FPEXC last
>> > +       sub     r2, r2, #4              @ Retry current instruction - if Thumb
>> > +       str     r2, [sp, #S_PC]         @ mode it's two 16-bit instructions,
>> > +                                       @ else it's one 32-bit instruction, so
>> > +                                       @ always subtract 4 from the following
>> > +                                       @ instruction address.
>>
>> I would say it's always a 32-bit instruction but made up of two 16-bit
>> values to allow half-word alignment.
>
> Do you have a suggested replacement text?

Maybe something like: Retry the current VFP instruction (32-bit in
both ARM and Thumb modes).

(I was wondering whether we can get on the above code path with
asynchronous VFP exceptions where the interrupted instruction may not
be the VFP one. But I think all Thumb-2 processors these days generate
synchronous exceptions)

-- 
Catalin
