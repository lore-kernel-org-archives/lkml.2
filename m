Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1JVJHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 05:07:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35058 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1JVJHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 05:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxqG0S+ZS0RHgyFLzgg-c_zu+095OhFresCGAuv8MfQ6A@mail.gmail.com>
References: <CA+55aFx3-F1LzVwN_gSqXcsU7uWda41bHyJxGxHNODWURu0T_g@mail.gmail.com>
	<1c0cef7faec24db26e2a6397fa8843089824750f.1319230509.git.luto@mit.edu>
	<CA+55aFxqG0S+ZS0RHgyFLzgg-c_zu+095OhFresCGAuv8MfQ6A@mail.gmail.com>
Date: Sat, 22 Oct 2011 02:07:51 -0700
Message-ID: <CALCETrXAiHs9PyziHBm-gZRiyahYafbxxUSxJUcFh=a-0th0EQ@mail.gmail.com>
Subject: Re: [PATCH] x86-64: Set siginfo and context on vsyscall emulation faults
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
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

On Fri, Oct 21, 2011 at 9:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Oct 22, 2011 at 12:01 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> +static bool write_ok_or_segv(unsigned long ptr, size_t size)
>> +{
>> +       if (ptr == 0)
>> +               return true;
>
> Why is ptr==0 special? That makes no sense.
>

Pure laziness.  Null pointers to the vsyscalls are valid and mean that
userspace doesn't care about the result.  I could have put the check
in the caller just as easily.

> Also, this whole function makes the notion of setting the "sigsegv on
> fault" flag much less interesting. It would be much better if
> access_ok() (including the cases embedded in get_user/put_user/etc)
> just did it right automatically for everything, rather than
> special-casing it for just this.
>

Agreed.  If I add an option to let userspace opt in to the
signal-sending behavior, I'd want to convince myself that all callers
of access_ok should be affected.

> I wonder if we could just make access_ok() use a trap instead of just
> the regular compares (and then in the trap handler do the same logic
> as in the page fault handler)? Sadly, the 'bounds' instruction doesn't
> work for this (in 32-bit mode it does a *signed* compare, and in
> 64-bit mode it no longer exists), but something like that might.
>

I suspect that bounds is considerably slower than a comparison anyway.

FWIW, there's a different optimization that could make a lot of this
code much nicer: using asm goto for the failure path in get_user, etc.
 The failure path is already a branch, and if gcc could be convinced
to generate sensible code for:

if (put_user(...)) goto out;
if (put_user(...)) goto out;
if (put_user(...)) goto out;
if (put_user(...)) goto out;

then the uaccess_err mechanism and a whole lot of bitwise ors could go away.

Sadly, gcc (at least 4.5 and 4.6) has weird limitations on the kind of
constraints allowed on asm goto that, IIRC, make get_user impossible
and put_user a little dicey.  (I could have that backwards.)

> That said, I think that your patch looks acceptable as a "let's fix
> vsyscalls without doing the bigger change". But I really don't see why
> ptr==0 would be special.
>
> So I think your write_ok_or_segv() function should just be
>
>   static bool write_ok_or_segv(unsigned long ptr, size_t size)
>   {
>      if (access_ok(ptr, size))
>         return true;
>
>       .. send signal ...
>
>      return false;
>   }
>
> instead of that odd thing you have now.

Or a comment to clarify it.  Alternatively I could ignore the issue
because access to 0 is okay in the access_ok sense anyway.

--Andy
