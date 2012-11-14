Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2KNHEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:04:37 -0500
Received: from www84.your-server.de ([213.133.104.84]:53047 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2KNHEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:04:35 -0500
Message-ID: <1352876629.7469.3.camel@wall-e>
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
From: Stefani Seibold <stefani@seibold.net>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 14 Nov 2012 08:03:49 +0100
In-Reply-To: <20121109023221.GO18293@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
	 <20121031055916.GC29509@yliu-dev.sh.intel.com>
	 <1351665033.23165.6.camel@wall-e>
	 <20121030235210.4dfc6ef7.akpm@linux-foundation.org>
	 <20121108122409.GN18293@yliu-dev.sh.intel.com>
	 <1352378235.15351.9.camel@wall-e>
	 <20121109023221.GO18293@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 09.11.2012, 10:32 +0800 schrieb Yuanhan Liu:
> On Thu, Nov 08, 2012 at 01:37:15PM +0100, Stefani Seibold wrote:
> > Am Donnerstag, den 08.11.2012, 20:24 +0800 schrieb Yuanhan Liu:

> Yes, it is. I will try log API then.
> 
> Stefani, I found an issue while rework to current API. Say the current
> code of __kfifo_init:
>     int __kfifo_init(struct __kfifo *fifo, void *buffer,
>                     unsigned int size, size_t esize)
>     {
>         size /= esize;
> 
>         if (!is_power_of_2(size))
>                 size = rounddown_pow_of_two(size);
>         ....
>     }
> 
> Even thought I changed the API to something like:
>     int __kfifo_init(struct __kfifo *fifo, void *buffer,
>                     int size_order, size_t esize)
>     {
> 	unsigned int size = 1 << size_order;
> 
> 	size /= esize;
> 	...
>     }
> 
> See? There is still a divide and we can't make it sure that it will be
> power of 2 after that.
> 
> So, I came up 2 proposal to fix this.
> 
> 1. refactor the meaning of 'size' argument first.
> 
>    'size' means the size of pre-allocated buffer. We can refactor it to
>    meaning of 'the number of fifo elements' just like __kfifo_alloc, so
>    that we don't need do the size /= esize stuff.
> 
> 2. remove kfifo_init
> 
>    As we can't make sure that kfifo will do exactly what users asked(in
>    the way of fifo size). It would be safe and good to maintain buffer
>    and buffer size inside kfifo. So, I propose to remove it and use
>    kfifo_alloc instead.
> 
>    git grep 'kfifo_init\>' shows that we currently have 2 users only.
> 
> 
> The first way is hacky, and it doesn't make much sense to me. Since
> buffer is pre-allocated by user but not kfifo. User has to calculate
> element size and the number of elements, which is not friendly.
> 
> The second way does make more sense to me.

kfifo_init() was requested by some kernel developers, i never liked it.
If you have a better and cleaner solution than do it, otherwise kick it
away if you like.

- Stefani



