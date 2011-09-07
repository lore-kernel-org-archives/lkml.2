Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1IGQQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:16:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41087 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab1IGQQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:16:04 -0400
MIME-Version: 1.0
In-Reply-To: <yw1xy5y0cvah.fsf@unicorn.mansr.com>
References: <87ehzstr07.fsf@vostro.fn.ogness.net> <yw1xy5y0cvah.fsf@unicorn.mansr.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 7 Sep 2011 15:28:21 +0100
X-Google-Sender-Auth: vRy4U0i7xh_8n1IKkqM0Tbw0UOA
Message-ID: <CAHkRjk7M__rtJ0cLWT65uC_trff6LtRQhY1qeii+2_gL24_+Hw@mail.gmail.com>
Subject: Re: [PATCH] ARM: alignment: setup alignment handler earlier
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/7 Måns Rullgård <mans@mansr.com>:
> John Ogness <john.ogness@linutronix.de> writes:
>
>> From 6f3f381800367127dc6430d9b9fa9bd6fc6d8ed0 Mon Sep 17 00:00:00 2001
>> From: John Ogness <john.ogness@linutronix.de>
>>
>> The alignment exception handler is setup fairly late in
>> the boot process (fs_initcall). However, with newer gcc
>> versions and the compiler option -fconserve-stack, code
>> accessing unaligned data is generated in functions that
>> are called earlier, for example pcpu_dump_alloc_info().
>
> This is a gcc bug and should not be worked around like this.  There was
> another patch[1] to disable -fconserve-stack on ARM due to this broken
> behaviour.  This patch was the outcome of a rather lengthy discussion[2].
>
> [1] http://article.gmane.org/gmane.linux.kernel/1148272
> [2] http://thread.gmane.org/gmane.linux.ports.arm.kernel/117863

I got some feedback from the gcc guys here in ARM (but then I went on
holiday and forgot about this). They convinced me that there isn't any
gcc bug, it is behaving correctly. Even with -fconserve-stack, the
variables on the stack are naturally aligned as expected (ints to
32-bit boundary etc.) The unaligned access happens when gcc populates
a char[9] string on the stack - see the pcpu_dump_alloc_info()
function. Since unaligned accesses are on by default, gcc generates
some unaligned STR to populate the string on the stack. This looks
like a perfectly valid behaviour.

>> This results in unhandled alignment exceptions during
>> boot. By setting up the exception handler sooner, we
>> reduce the window where a compiler may generate code
>> accessing unaligned data.
>
> I will also restate my opinion that enabling strict alignment checking
> on ARMv6 and later is *wrong* in the first place.

That's probably the solution.

-- 
Catalin
