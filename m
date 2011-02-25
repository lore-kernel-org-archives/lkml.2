Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab1BYSzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:55:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932502Ab1BYSzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:55:16 -0500
MIME-Version: 1.0
In-Reply-To: <20110225175202.GA19059@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com>
 <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Feb 2011 10:54:24 -0800
Message-ID: <AANLkTimv6=QuK2+ye=OFCdRN_285GsNc4CnWEQf8OY26@mail.gmail.com>
Subject: Re: [PATCH 0/4 RESEND] exec: unify compat/non-compat code
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

On Fri, Feb 25, 2011 at 9:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 12/01, Milton Miller wrote:
>> >
>> > > +#ifdef CONFIG_COMPAT
>> > > +int compat_do_execve(char * filename,
>> > > + compat_uptr_t __user *argv,
>> > > + compat_uptr_t __user *envp,
>> > > + struct pt_regs * regs)
>> > > +{
>> > > + return do_execve_common(filename,
>> > > +                         (void __user*)argv, (void __user*)envp,
>> >
>> > Shouldn't these be compat_ptr(argv)?  (makes a difference on s390)

Indeed. The "compat_uptr_t __user *argv" is wrong, and it should be just

    compat_uptr_t argv;

and then every time you turn it into a pointer, it should use
"compat_ptr(argv)".

Then, since it's a pointer to an array of pointers, when you do that,
you should turn it into a pointer to "compat_uptr_t", so you actually
have this:

 - user passes "compat_uptr_t"

 - the kernel can turn that into "compat_uptr_t __user *" by doing

       compat_uptr_t __user *pptr;
       pptr = compat_ptr(argv);

 - the kernel needs to fetch the individual entries with

       compat_uptr_t cuptr = get_user(pptr);

 - the kernel can then turn _those_ into the actual pointers to the string with

       const char __user *str = compat_ptr(cuptr);

so you need two levels of compat_ptr() conversion.

> So, once again, this should not (and can not) be compat_ptr(argv) afaics.

It can be, and probably should. But the low-level s390 wrapper
function may have done one of the levels already. It probably
shouldn't, and we _should_ do the "compat_ptr()" thing a the generic C
level. That's what we do with all the other pointers, after all.

                          Linus
