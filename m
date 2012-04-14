Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2DNHvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 03:51:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61674 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2DNHvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 03:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <201204140843.08671.l.lunak@suse.cz>
References: <201204132124.21294.l.lunak@suse.cz> <201204140118.51534.l.lunak@suse.cz>
 <CA+55aFzWiaXYSwO7eGt_V6oUZGWkp_v1hv9xc6KAiFnrzumxXA@mail.gmail.com> <201204140843.08671.l.lunak@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 00:51:32 -0700
X-Google-Sender-Auth: 3mxdxPxcYhDOgf-OI1pAB4H5_EE
Message-ID: <CA+55aFwCY0jkFGAzOP5SFb8THQts7BDb_ivChT7K6LvVn6OqoQ@mail.gmail.com>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
To: Lubos Lunak <l.lunak@suse.cz>
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 11:43 PM, Lubos Lunak <l.lunak@suse.cz> wrote:
>>
>> And it really *is* a lie. The C++ type system isn't even "stronger",
>
> $ cat b.c
> void foo()
>    {
>    int* a;
>    void* b;
>    char c;
>    a = b = &c;
>    }
> $ gcc -Wall b.c -c
> $ g++ -Wall b.c -c
> b.c: In function ‘void foo()’:
> b.c:6:14: error: invalid conversion from ‘void*’ to ‘int*’

You're missing the point. Yes, the C++ type system is different, and
"void *" doesn't convert without a warning.

But "(void *)0" isn't just any "void *". It's NULL. It's special.
Except the C++ people didn't get the memo, and in fact, they argued
themselves blue in the face about not getting the memo.

And a C++ person who says that "(vodi *)0" is just any "void *" is a
*fucking*moron*, because by exactly the same argument, "0" is just any
"int". Yet in C++, if you do

   int * a = 0;

you don't get the warning.

See? There is absolutely *zero* excuse for the idiotic traditional C++
brain damage of saying "NULL cannot be '(void *)0', because 'void *'
will warn".

Anybody who says that is lying. Because it is the *exact* same logic
as "NULL cannot be '0', because 'int' will warn".

See my point? It's not actually the type that is the important thing.
It's the *constant". But using a plain "0" constant was always a
mistake because of the confusion with the normal and common integer
zero constant that is used all over.

The C people actually understood and realized that it was a mistake,
and they fixed it. Sure, C compilers still (for legacy reasons) allow
plain 0 for NULL, but that is pure backwards compatibility, and I
think it's sad and wrong. But at least C standards people realized
that the legacy model was stupid, and everybody accepts that NULL is
much better off as being "(void *)0".

The C++ people? They are morons, and they never got it, and in fact
they spent much of their limited mental effort arguing against it.

They should just have made "(void *)0" be NULL. As it is, everybody
finally realized that NULL really can't be "0" after all, at which
point the C++ people were too embarrassed to admit that they had been
wrong all along, so the compiler people started making up special
"__null" things. For no really good reason, except that the C++ people
had spent so much time trying convince themselves that their stupid
model was right.

The whole "it's a stronger type system, so NULL has to be 0" is pure
and utter garbage. It's wrong. It's stupid.

In reality, the C++ type system is actually often *weaker* with 'void
*' even outside of the special case of NULL (and NULL really *is* a
special case - it is the *constant* 0. It's not the "integer 0" or
anything like that, and even K&R understood that). The C++ problems
wrt "void *" just result in more explicit casting. And then the
explicit casting actually makes for a *weaker* typesystem than the C
model which just says "ok, 'void *' doesn't need casts". Because now
you have a type override expliticly written in that software that
actually throws all type safety away entirely.

So "Yes, C++ will warn about things that C does not warn about". But
that doesn't make the type system stronger. It just makes C++
apologists claim it is stronger, even though in practice it forces
people to add casts that actually make it weaker.

Yeah, I'm not a fan of C++. It's a cruddy language.

                       Linus
