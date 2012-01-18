Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2ARUtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:49:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab2ARUtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <7f1e961d.f528.134efaf8348.Coremail.dragonylffly@163.com>
References: <7f1e961d.f528.134efaf8348.Coremail.dragonylffly@163.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jan 2012 12:49:17 -0800
X-Google-Sender-Auth: KKyDwpLdCxMlPlIEAr-sPd8Oo-A
Message-ID: <CA+55aFx7CV8wpDLfCr-pVVRxRyYgd2QdRXJSmp+UgrjSHyB1eA@mail.gmail.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
To: dragonylffly <dragonylffly@163.com>
Cc: tyhicks@canonical.com, john.johansen@canonical.com,
        dustin.kirkland@gazzang.com, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm.

There are *two* cases where we do that "total_remaining_bytes"
calculation. The same bug seems to exist both in ecryptfs_read() and
ecryptfs_write().

Possibly only the ecryptfs_write() one leads to an endless loop, but
the read one looks suspicious too.

Also, what protects things against this just being one nasty DoS
attack - even if the code is fixed to not be an endless loop, it looks
like a trivial "truncate()" can be used to generate a *practically*
infinite write stream. At the very least, this should be KILLABLE. Or
did I mis-read the code?

Tyler, Dustin, others - comments? This looks nasty.

                     Linus.

2012/1/17 dragonylffly <dragonylffly@163.com>:
> Hi,
>   There is an infinite loop bug in eCryptfs, to make it present,
> just truncate to generate a huge file (>= 4G) on a 32-bit machine under
> the plain text foleder mounted with eCryptfs, a simple command
> 'truncate -s 4G dummy' is enough. Note: 4GB is smaller than 4G,
> therefore the following command 'truncate -s 4GB dummy' will not
> trigger this bug. The bug comes from a data overflow, the patch below fixes
> it.
>
> Cheers,
> Li Wang
>
> ---
>
> signed-off-by: Li Wang <liwang@nudt.edu.cn>
>                Yunchuan Wen (wenyunchuan@kylinos.com.cn)
>
> --- read_write.c.orig 2012-01-18 10:39:26.000000000 +0800
> +++ read_write.c 2012-01-18 19:48:41.484196221 +0800
> @@ -130,7 +130,7 @@
>    pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
>    size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
>    size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
> -  size_t total_remaining_bytes = ((offset + size) - pos);
> +  loff_t total_remaining_bytes = ((offset + size) - pos);
>
>    if (num_bytes > total_remaining_bytes)
>     num_bytes = total_remaining_bytes;
>
>
>
