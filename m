Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965314Ab0COQGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:06:55 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42460 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965216Ab0COQGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rwzg8UN5U1vC4vkK8ky6ce4YYTO9gHF+ale0RR0eiJes6b4F9uHLVuiQDZwcM49kWl
         7GX3ZfvWmK+gYkkW6wXA5PaoApwkSzPkZs73mk4A+PtB+8CA/HVv4gB4c1V+JWlgY7Ar
         zX3BlQT7wzxcFChYguc44apqmB44HckcnLbNA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003151044590.8729@localhost>
References: <alpine.LFD.2.00.1003151044590.8729@localhost>
Date: Mon, 15 Mar 2010 18:06:51 +0200
Message-ID: <413a6a951003150906ve38d1dy95ed07f026accf09@mail.gmail.com>
Subject: Re: kfifo has temporarily invalid in pointer?
From: Daniel Baluta <daniel.baluta@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Mon, Mar 15, 2010 at 4:58 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
>  (i am not trying to be annoyingly obsessive about the kernel kfifo,
> i am merely succeeding.)
:P
>  what appears to be a bit of an oddity WRT kfifo:  since a kfifo is
> defined with a fixed buffer size, it obviously enqueues and dequeues
> in a circular fashion.  so, the code to add some data to a kfifo (from
> kernel/kfifo.c):
>
> =====
> unsigned int kfifo_in(struct kfifo *fifo, const void *from,
>                                unsigned int len)
> {
>        len = min(kfifo_avail(fifo), len);
>
>        __kfifo_in_data(fifo, from, len, 0);
>        __kfifo_add_in(fifo, len);
>        return len;
> }
> =====
>
>  fair enough -- that first routine adds the data itself, while the
> second one correspondingly bumps up the pointer, which could
> conceivably wrap around to follow the data, correct?  but from
> include/linux.kfifo.h:len = min(kfifo_avail(fifo), len);

Wrong :). If you notice len is truncated using:
len = min(kfifo_avail(fifo), len);

>
> =====
> static inline void __kfifo_add_in(struct kfifo *fifo,
>                                unsigned int off)
> {
>        smp_wmb();
>        fifo->in += off;
> }
So,  fifo->in + min(kfifo_avail(fifo), len) < fifo->size, every time.

thanks,
Daniel.
