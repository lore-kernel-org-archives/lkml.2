Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2DYBqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:46:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56772 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab2DYBqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <1335304497.28150.243.camel@twins>
References: <20120424161039.293018424@chello.nl> <20120424162224.526249106@chello.nl>
 <CA+55aFyvBTDh_DkXs6Z6zFmjyYxvWaAEm9-rJDXhvPx8CpDiKA@mail.gmail.com> <1335304497.28150.243.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Apr 2012 18:46:14 -0700
X-Google-Sender-Auth: LnLx95UGGaYgHy7d3bYOmJrJX8I
Message-ID: <CA+55aFx_efN7A2H2VuRGZiyh2xcV=p6uoDLcVAW2JOqmJJNd1Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 2:54 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> that does generate slightly better code in that it avoids some masks on
> 64bit:
>
> @@ -7,12 +7,11 @@
>  .LFB38:
>        .cfi_startproc
>        movq    %rdi, %r8
> -       movq    %rdi, %rdx
>        movq    %rsi, %rcx
> +       mov     %edi, %edx
>        shrq    $32, %r8
> -       andl    $4294967295, %edx
>        shrq    $32, %rcx
> -       andl    $4294967295, %esi
> +       mov     %esi, %esi

Oh christ.

What insane version of gcc is that? Can you please make a gcc bug-report?

Because a compiler that generates an instruction sequence like

    movq %rdi,%rsi
    andl $4294967295, %esi

is just so fricking stupid that it's outright buggy. That's just
crazy. It's demented. It's an "and" with all bits set.

But yeah, I do think that in general using a cast to 32-bit instead of
a mask to 32-bit is easier for the compiler. Although that still is a
particularly stupid code sequence to use.

                     Linus
