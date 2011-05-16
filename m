Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1EPRFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:05:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34915 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1EPRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=x+lO5NKkLfQd44zsKTe0G7J4EvwBhHW6+5+rQI1BOroe2qyy54dA6nEGQFZPFhROqd
         OclL/7Y+n40dVak8klhjkLxKGz8+kyLDrDqLBoa/bgTa2hDL47eoCQdPuig0nFAhAXC0
         if9yjWJwrUuWn70uBcYfDdL2ZLTlJMn6W/y0s=
MIME-Version: 1.0
In-Reply-To: <20110516164939.GD25898@one.firstfloor.org>
References: <cover.1305560561.git.luto@mit.edu> <20110516160943.GC25898@one.firstfloor.org>
 <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 16 May 2011 13:05:12 -0400
X-Google-Sender-Auth: f9Zlz0ECkKUyx7wazpL58Jcj0xk
Message-ID: <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> And unless you or someone else changes the primitive state of the
>> kernel, framepointers are going to stay simply because removing them
>> breaks profiling backtraces when the hit is inside vread().
>
> This doesn't work anyways because the glibc stub code calling vgettimeofday
> normally doesn't set up a frame pointer frame.
>
> The only way to unwind there is dwarf2.

For code in the vsyscall page, I think using CFI data is a lost cause.
 How is any user code supposed to find the CFI data?

For the vDSO, we could be nice to userspace and install the debugging
symbols somewhere sensible.  Currently we generate a buildid but we
don't install the symbols anywhere by default.

Longer term, it would be nice to mark the vsyscall page NX.  That
involves a few things:

1. Move vread to the vDSO.  That's not very hard.
2. Get glibc to stop using the old vsyscalls.  I think it still does
for static-linked programs.
3. Have a bit of a deprecation period.
4. Come up with some way to make old programs keep working even with
NX set.  Maybe just delete the vsyscall functions and emulate them on
a trap (with a printk_once warning about the performance loss).

That way all user code has (in principle) dwarf2.  And we won't have a
syscall instruction sitting at a predictable address.

--Andy

>
> -Andi
>
