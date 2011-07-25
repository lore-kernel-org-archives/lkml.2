Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1GYDWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 23:22:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45078 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1GYDWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 23:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7H1j1cewgWP6Jmkw_H9dZVh1kxRGgTLa+ju=ns4gYxMdA@mail.gmail.com>
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
 <20110724211526.GA6785@elte.hu> <CAObL_7H1j1cewgWP6Jmkw_H9dZVh1kxRGgTLa+ju=ns4gYxMdA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 24 Jul 2011 23:21:55 -0400
X-Google-Sender-Auth: nUd2Ao1cMedlSlAch3COfcMygKw
Message-ID: <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 6:34 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> I had in mind something a little less ambitious: making
> kernel_fpu_begin very fast, especially when used more than once.
> Currently it's slow enough to have spawned arch/x86/crypto/fpu.c,
> which is a hideous piece of infrastructure that exists solely to
> reduce the number of kernel_fpu_begin/end pairs when using AES-NI.
> Clobbering registers in syscall would reduce the cost even more, but
> it might require having a way to detect whether the most recent kernel
> entry was via syscall or some other means.

I think it will be very hard to inadvertently cause a regression,
because the current code looks pretty bad.

1. Once a task uses xstate for five timeslices, the kernel decides
that it will continue using it.  The only thing that clears that
condition is __unlazy_fpu called with TS_USEDFPU set.  The only way I
can see for that to happen is if kernel_fpu_begin is called twice in a
row between context switches, and that has little do with the task's
xstate usage.

2. __switch_to, when switching to a task with fpu_counter > 5, will do
stts(); clts().

The combination means that when switching between two xstate-using
tasks (or even tasks that were once xstate-using), we pay the full
price of a state save/restore *and* stts/clts.

--Andy
