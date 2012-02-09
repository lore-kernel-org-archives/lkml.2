Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2BIM4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:56:44 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44670 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab2BIM4n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:56:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120208142513.4db2493a.akpm@linux-foundation.org>
References: <20120207141155.GA16184@elgon.mountain>
	<4F323388.7040902@kernel.dk>
	<20120208142513.4db2493a.akpm@linux-foundation.org>
Date: Thu, 9 Feb 2012 14:56:42 +0200
X-Google-Sender-Auth: ROcMSNZRPIXVUuKa0JSGEOtz5PQ
Message-ID: <CAOJsxLGMOfzgHYKrgo42sB26PQw9YZR8TGTbpkeWNZpY4FPOTg@mail.gmail.com>
Subject: Re: integer overflows in kernel/relay.c
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 12:25 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 08 Feb 2012 09:34:16 +0100
> Jens Axboe <axboe@kernel.dk> wrote:
>
>> On 02/07/2012 03:11 PM, Dan Carpenter wrote:
>> > My static checker is warning about integer overflows in kernel/relay.c
>> >
>> > relay_create_buf()
>> >    170
>> >    171          buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
>> >                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> > This can only overflow on 32bit systems.
>>
>> Correct
>
> This is a relatively common problem.  Converting a kzalloc() call to
> kcalloc() fixes it.  But we do not have a non-zeroing version of
> kcalloc().
>
> Please, someone complete this patch and send it to me!
>
>
> --- a/include/linux/slab.h~a
> +++ a/include/linux/slab.h
> @@ -240,11 +240,16 @@ size_t ksize(const void *);
>  * for general use, and so are not documented here. For a full list of
>  * potential flags, always refer to linux/gfp.h.
>  */
> -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> +static inline void *wtf_do_i_call_this(size_t n, size_t size, gfp_t flags)

I'd call it kmalloc_array().

>  {
>        if (size != 0 && n > ULONG_MAX / size)
>                return NULL;
> -       return __kmalloc(n * size, flags | __GFP_ZERO);
> +       return __kmalloc(n * size, flags);
> +}
