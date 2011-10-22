Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1JVEqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 00:46:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1JVEqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 00:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <1c0cef7faec24db26e2a6397fa8843089824750f.1319230509.git.luto@mit.edu>
References: <CA+55aFx3-F1LzVwN_gSqXcsU7uWda41bHyJxGxHNODWURu0T_g@mail.gmail.com>
 <1c0cef7faec24db26e2a6397fa8843089824750f.1319230509.git.luto@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Oct 2011 07:46:21 +0300
X-Google-Sender-Auth: WCGepP5kEG1d4UUB59ABGJLLbCU
Message-ID: <CA+55aFxqG0S+ZS0RHgyFLzgg-c_zu+095OhFresCGAuv8MfQ6A@mail.gmail.com>
Subject: Re: [PATCH] x86-64: Set siginfo and context on vsyscall emulation faults
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 12:01 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> +static bool write_ok_or_segv(unsigned long ptr, size_t size)
> +{
> +       if (ptr == 0)
> +               return true;

Why is ptr==0 special? That makes no sense.

Also, this whole function makes the notion of setting the "sigsegv on
fault" flag much less interesting. It would be much better if
access_ok() (including the cases embedded in get_user/put_user/etc)
just did it right automatically for everything, rather than
special-casing it for just this.

I wonder if we could just make access_ok() use a trap instead of just
the regular compares (and then in the trap handler do the same logic
as in the page fault handler)? Sadly, the 'bounds' instruction doesn't
work for this (in 32-bit mode it does a *signed* compare, and in
64-bit mode it no longer exists), but something like that might.

That said, I think that your patch looks acceptable as a "let's fix
vsyscalls without doing the bigger change". But I really don't see why
ptr==0 would be special.

So I think your write_ok_or_segv() function should just be

   static bool write_ok_or_segv(unsigned long ptr, size_t size)
   {
      if (access_ok(ptr, size))
         return true;

       .. send signal ...

      return false;
   }

instead of that odd thing you have now.

           Linus
