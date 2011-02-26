Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1BZP4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:56:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab1BZP4I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:56:08 -0500
MIME-Version: 1.0
In-Reply-To: <20110226123731.GC4416@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com>
 <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com>
 <20110225175314.GD19059@redhat.com> <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com>
 <20110226123731.GC4416@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Feb 2011 07:55:44 -0800
Message-ID: <AANLkTinFVCR_znYtyVuJcjFQq_fgMp+ozbSz54UKzvQ_@mail.gmail.com>
Subject: Re: [PATCH 3/5] exec: unify compat_do_execve() code
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 4:37 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>
>>   typedef union {
>>      compat_uptr_t compat;
>>      const char __user *native;
>>    } conditional_user_ptr_t;
>
> Personally I don't really like this union, to me "void __user*" looks
> better, but I won't insist.

Umm. "void __user *" may look simpler/better, but it's WRONG.

Using "const char __user *const __user *" is correct - but only for
the non-compat case.

And using "void __user *" may result in compiling code, but it will
have lost all actual information about the type. We don't do that in
the kernel if we can avoid it, because "void *" basically does no type
checking. Sure, sometimes it's the only thing we can do, but _if_ we
have a type, we should use it.

And that "union" really is the true type. You are passing a user
pointer down that can be either of those members.

So if you think it looks ugly, then you shouldn't do that "conditional
compat argument at run-time at all". Because the real ugliness of the
type comes not from the type, but from the fact that you pass a
pointer that can contain two different things.


> Once again, to me "void __user*" looks better (just simpler). In this
> case get_arg_ptr() becomes (without const/__user for the clarity)

No.

I simply won't apply that. It's WRONG. It's wrong because you've
dropped all the type information.

With the right union,

>        void *get_arg_ptr(void **argv, int argc, bool compat)
>        {
>                char *ptr;
>
>        #ifdef CONFIG_COMPAT
>                if (unlikely(compat)) {
>                        compat_uptr_t *a = argv;
>                        compat_uptr_t p;
>
>                        if (get_user(p, a + argc))
>                                return ERR_PTR(-EFAULT);
>
>                        return compat_ptr(p);
>                }
>        #endif
>
>                if (get_user(ptr, &argv. + argc))
>                        return ERR_PTR(-EFAULT);
>
>                return ptr;
>        }
>
> Otherwise, get_arg_ptr() should return conditional_user_ptr_t as well,

No it shouldn't. The get_arg_ptr() should always just return the
actual pointer. It will have _resolved_ the ambiguity! That's what the
"compat_ptr()" thing does in the return case inside teh CONFIG_COMPAT.

So the correct way to do this is something like the following (yeah,
maybe I got the syntax wrong, I didn't test this, I just wrote it in
my MUA):

       void *get_arg_ptr(const union compat_ptr_union __user *argv,
int argc, bool compat)
       {
               char *ptr;

        #ifdef CONFIG_COMPAT
               if (unlikely(compat)) {
                       compat_uptr_t p;

                       if (get_user(p, &argv->compat + argc))
                               return ERR_PTR(-EFAULT);

                       return compat_ptr(p);
               }
        #endif

               if (get_user(ptr, &argv->noncompat +argc))
                       return ERR_PTR(-EFAULT);

               return ptr;
       }

and notice how it gets the types right, and it even has one line LESS
than your version, exactly because it gets the types right and doesn't
need that implied cast in your

     compat_uptr_t *a = argv;

(in fact, I think your version needs an _explicit_ cast in order to
not get a warning: you can't just cast "void **" to something else).

See? The advantage of the union is that the types are correct, which
means that the casts are unnecessary.

The advantage of the union is also that you see what is going on, and
it's clear from the function prototype that this doesn't just take a
random user pointer, it takes a user pointer to something that can be
two different types.

See? Correct typing is important.

                            Linus
