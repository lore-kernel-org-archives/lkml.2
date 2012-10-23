Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab2JWTZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:25:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51082 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2JWTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <508600ba.a7fe440a.4c19.fffff64bSMTPIN_ADDED@mx.google.com>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
	<CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
	<1350624189.14741.1.camel@wall-e>
	<alpine.LNX.2.00.1210190934010.7523@pobox.suse.cz>
	<20121022165602.41c4953e.akpm@linux-foundation.org>
	<508600ba.a7fe440a.4c19.fffff64bSMTPIN_ADDED@mx.google.com>
Date: Tue, 23 Oct 2012 21:25:46 +0200
Message-ID: <CAFLxGvyQxdfm9KUcaUSJV5g19zGa71w=a8ma0xxWVuGsrdkzMQ@mail.gmail.com>
Subject: Re: [PATCH] remove untouched code in kfifo_in
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 4:27 AM, Richard Yang
<weiyang@linux.vnet.ibm.com> wrote:
> On Mon, Oct 22, 2012 at 04:56:02PM -0700, Andrew Morton wrote:
>>On Fri, 19 Oct 2012 09:34:43 +0200 (CEST)
>>Jiri Kosina <jkosina@suse.cz> wrote:
>>
>>> On Fri, 19 Oct 2012, Stefani Seibold wrote:
>>>
>>> > > > In kfifo_in marco, one piece of code is arounded by if(0). This code in
>>> > > > introduced by Stefani Seibold <stefani@seibold.net> to suppress a compiler
>>> > > > warning. This warning is not there with the upgrade of gcc version.
>>> > > >
>>> > > > This patch just remove this code.
>>> > >
>>> > > Are you sure?
>>> > > This code fragment looks like a compiler bomb to detect type mismatch to me...
>>> >
>>> > Yes, you are great! That was the reason why i made this peace of code.
>>> > So don't remove it!
>>>
>>> As even you, the author of the code, got confused by it for a while,
>>> adding an explanatory comment seems appropriate.
>>>
>>
>>include/linux/typecheck.h?
>
> Something like this?
>
> From f20c316bf87d5db0816a01705b7869526c0b2363 Mon Sep 17 00:00:00 2001
> From: Wei Yang <weiyang@linux.vnet.ibm.com>
> Date: Wed, 17 Oct 2012 16:45:49 +0800
> Subject: [PATCH] Replace the type check code with typecheck() in kfifo_in
>
> In kfifo_in marco, one piece of code which is arounded by if(0) will check the
> type of __tmp->ptr_const and __buf. If they are different type, there will
> output a warning during compiling. This piece of code is not self explaining
> and a little bit hard to understand.
>
> Based on Andrew Morton's suggestion, this patch replace this with typecheck()
> which will be easy to understand.
> ---
>  include/linux/kfifo.h |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> index 10308c6..b48fe71 100644
> --- a/include/linux/kfifo.h
> +++ b/include/linux/kfifo.h
> @@ -512,10 +512,7 @@ __kfifo_uint_must_check_helper( \
>         unsigned long __n = (n); \
>         const size_t __recsize = sizeof(*__tmp->rectype); \
>         struct __kfifo *__kfifo = &__tmp->kfifo; \
> -       if (0) { \
> -               typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
> -               __dummy = (typeof(__buf))NULL; \
> -       } \
> +       typecheck(typeof(__tmp->ptr_const), __buf);\
>         (__recsize) ?\
>         __kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
>         __kfifo_in(__kfifo, __buf, __n); \

What about all the other open coded type checks in that file?

-- 
Thanks,
//richard
