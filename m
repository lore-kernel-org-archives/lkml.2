Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1CJWT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:19:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:45002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1CJWTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:19:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qgpm9o+7Ls0FY+KnYkd67CnX+4/sv6e4tb+Spcl5jcmWKbk+Iock4HQyzZlrRJu537
         DC0SmEGqOfCq5aMZ5Nnw==
MIME-Version: 1.0
In-Reply-To: <AANLkTinTfHqrbVFh6Q68kP=UKJjye8J+iDhRHTcm8BPF@mail.gmail.com>
References: <1299639325-10384-1-git-send-email-sjg@chromium.org>
	<AANLkTinTfHqrbVFh6Q68kP=UKJjye8J+iDhRHTcm8BPF@mail.gmail.com>
Date: Thu, 10 Mar 2011 14:19:20 -0800
X-Google-Sender-Auth: D8kd-JmqBZ2auByJMOfc2JKd8Fs
Message-ID: <AANLkTinh4-rvhDGesy=STFsiLGyjBb8Scb+BR7tfXQ+G@mail.gmail.com>
Subject: Re: [RFC PATCH V2] ARM: Use generic BUG() handler
From: Simon Glass <sjg@chromium.org>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Mikael Pettersson <mikpe@it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 1:51 AM, Dave Martin <dave.martin@linaro.org> wrote:
> On Wed, Mar 9, 2011 at 2:55 AM, Simon Glass <sjg@chromium.org> wrote:
>> +#ifdef CONFIG_THUMB2_KERNEL
>> +#define BUG_INSTR_VALUE 0xf7f2
>
> This isn't an undefined instruction... it's actually half of some
> 32-bit Thumb instruction. Did you mean 0xdexx instead?

Yes, will fix.

>> +#define BUG_INSTR_TYPE ".hword "
>> +#else
>> +#define BUG_INSTR_VALUE 0xe7f001f2
>> +#define BUG_INSTR_TYPE ".word "
>> +#endif
>> +
>
> This works, but do we really need to split the definition of the bug
> instruction into two macros?

This is so that I can test for the correct instruction word in valid_bug_addr().

>
> Unless you can see a use for calling _BUG() directly with a different
> instruction value, of course...
>

>> +       /*
>> +       * .exit.text is discarded at runtime, not link time, to deal with
>> +       *  references from bug_table
>> +       */
>> +       .exit.text : AT(ADDR(.exit.text)) {
>> +               EXIT_TEXT
>> +       }
>> +
>> +       .exit.data : AT(ADDR(.exit.data)) {
>> +               EXIT_DATA
>> +       }
>
> This is the same unfortunate hack we have to do for other fixups,
> because there's no way to separate out some of these entries in such a
> way that they can be discarded at link time...  I did have an idea for
> an extention to gas which would allow fixups and similar data to be
> emitted in separate ancillary sections which the linker can handle
> sensibly, so that bug entries referencing .exit.text (for example) can
> be discarded at link time.
>
> See http://sourceware.org/ml/binutils/2011-02/msg00004.html
>
> I haven't received any support for the idea so far though...

Well yes, and some might even argue that calling BUG() in __exit code
is not a great idea. Here we are adding in all exit data again which
is about 8.5KB in my kernel. These two pages are then reclaimed at
runtime.

However, at present I don't see any alternative to this, and this is
what is done on other architectures to support BUG().

>
> Cheers
> ---Dave
>

I will tidy this up, test it properly on Thumb and submit a patch.

Regards,
Simon
