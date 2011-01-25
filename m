Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1AYBIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:08:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40814 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AYBIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:08:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JxR4IQd4izTu1yCVBVSjRv+aWSrj8YEI3/pGAbtq8yH2lS3Jqg/Hl0IjqrUmHVAGp6
         tUV4bHfYLhUteSvYbxIMNVXdX3h5tg2CrhxMa8Wdsp2awo2ZG7veqOTKs5WICLDTX594
         ZLjTfm4B4pjTCb8qTwuLKu84NVP6dAwsTDiZI=
MIME-Version: 1.0
In-Reply-To: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>
Date: Tue, 25 Jan 2011 12:08:50 +1100
Message-ID: <AANLkTikPfjzpQn4nYgoAyAJ6sDnZM-a0b3V794Q_Mpy+@mail.gmail.com>
Subject: Re: [PATCH 0/6] Clean up ticketlock implementation
From: Nick Piggin <npiggin@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 10:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Hi all,
>
> This series cleans up the x86 ticketlock implementation by converting
> a large proportion of it to C.  This eliminates the need for having
> separate implementations for "large" (NR_CPUS >= 256) and "small"
> (NR_CPUS < 256) ticket locks.
>
> This also lays the groundwork for future changes to the ticketlock
> implementation.
>
> Of course, the big question when converting from assembler to C is
> what the compiler will do to the code.  In general, the results are
> very similar.
>
> For example, the original hand-coded small-ticket ticket_lock is:
>      movl   $256, %eax
>      lock xadd %ax,(%rdi)
>   1: cmp    %ah,%al
>      je     2f
>      pause
>      mov    (%rdi),%al
>      jmp    1b
>   2:
>
> The C version, compiled by gcc 4.5.1 is:
>        movl   $256, %eax
>        lock; xaddw %ax, (%rdi)
>        movzbl  %ah, %edx
> .L3:    cmpb    %dl, %al
>        je      .L2
>        rep; nop
>        movb    (%rdi), %al     # lock_1(D)->D.5949.tickets.head, inc$head
>        jmp     .L3     #
> .L2:
>
> So very similar, except the compiler misses directly comparing
> %ah to %al.

Oh :(

Have you filed a bug with gcc?
