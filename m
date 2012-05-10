Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2EJPpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:45:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51365 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2EJPpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <4FABBCE4.3050503@siemens.com>
References: <4FAAEB37.1080001@siemens.com> <CA+55aFz-z6F=ynvTZp2xrSyq+Ar7huT92_S9e8Wuxepyppq5ZQ@mail.gmail.com>
 <4FABBCE4.3050503@siemens.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 08:44:51 -0700
X-Google-Sender-Auth: RlWWoLclji0vAOMjktFaO8XJP90
Message-ID: <CA+55aFyOsPY-RNwedb3NnbKbj=iAc7L6YuSSEZYy5_Sczmqd4A@mail.gmail.com>
Subject: Re: [PATCH v2] compat: Fix RT signal mask corruption via sigprocmask
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Anthony Liguori <aliguori@us.ibm.com>, Kevin Wolf <kwolf@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 6:04 AM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> +               case SIG_BLOCK:
> +                       sigaddsetmask(&new_blocked, new_set);
> +                       break;
> +               case SIG_UNBLOCK:
> +                       sigdelsetmask(&new_blocked, new_set);
> +                       break;

Ok, I think SIG_[UN]BLOCK are now clearly right. However:

> +               case SIG_SETMASK:
> +                       new_blocked.sig[0] &=
> +                               ~((old_sigset_t)(compat_old_sigset_t)-1);
> +                       new_blocked.sig[0] |= new_set;
> +                       break;

I don't think this is clear.

The semantics for the *native* SIG_SETMASK has been to only change the
lower word of the sigset_t.

And that was actually defined in terms of "compat_sigset_word", not
"compat_old_sigset_t".

Now, they are both generally the same, and so I think your code does
the right thing, but I have to say that I really had to look closely
to make sure that yes, your code was right.

Anyway, my *gut* feel is that it would be much clearer to write the above as

    compat_sigset_word x = new_set;
    memcpy(new_blocked.sig, &x, sizeof(x));

together with a comment to the effect that sigprocmask(SIG_SETMASK..)
only changes the first word of the structure.

That said, I think your patch does look technically correct, so maybe
it's just me who thinks it is very non-obvious and hard to read.

The memcpy approach will also generate better code. This is the "mask-and-set":

        movabsq $-4294967296, %rax      #, tmp89
        andq    -32(%rbp), %rax # new_blocked.sig, tmp89
        orq     %rdx, %rax      # new_set, tmp89
        movq    %rax, -32(%rbp) # tmp89, new_blocked.sig

and this is the memcpy:

        movl    %edx, -32(%rbp) # new_set,

ie it is done as a simple 32-bit store.

I think I'll just edit your patch directly, no need to send me a new version.

                               Linus
