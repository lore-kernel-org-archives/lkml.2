Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab2ERAmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:42:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62883 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab2ERAmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:42:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwyem9KoPMhYkE-vcaUDqgP9g7arHbmD-mMHMSKXaRBOw@mail.gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
 <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com>
 <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com>
 <4FB59474.2020505@zytor.com> <CA+55aFwyem9KoPMhYkE-vcaUDqgP9g7arHbmD-mMHMSKXaRBOw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 17:41:42 -0700
X-Google-Sender-Auth: U-Z8aorS9cjB9dzmC9fFNDHXK_Q
Message-ID: <CA+55aFx4sEQT=U4DBULeo9=3piOx_pQUws92ovKV5bKsu3hQQQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Daney <ddaney.cavm@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 5:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That's why I think it's unfixable. It started out broken, and I
> presume that 32-bit user land on a 64-bit MIPS/PPC thing either do not
> work, or there's some compat crap (like special user-land headers)
> fixing things up. Or they just don't use that buggered msqid64_ds
> thing at all.

Btw, even if it's unfixable, that doesn't necessarily mean that we
can't make it *prettier*.

For example, instead of this horrible crap:

          __kernel_time_t msg_stime;      /* last msgsnd time */
  #if __BITS_PER_LONG != 64
          unsigned long   __unused1;
  #endif

which is just nasty, we *could* have something much cleaner like this:

  #define align_64_entry(type,name) \
              union { type name; __u64 __align_##name; }

and then just use

           align_64_entry(__kernel_time_t msg_stime);

without any preprocessor #if/#ifdef crap anywhere.

It would keep the current state for the (apparently broken) case of
64-bit kernel and 32-bit user space with big-endian architectures, but
it would *also* just magically work if __kernel_time_t is 64-bit
despite "long" being 32-bit.

So it would fix the x32 case, as far as I can tell.

Note: totally untested. Maybe there's some reason why my anonymous
union trick wouldn't work.

                    Linus
