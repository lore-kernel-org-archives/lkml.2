Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1HOOio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:38:44 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:23629 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753279Ab1HOOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:38:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FNnSv5kVM1mwIXkLSABOZJ0d93ps3hgKJ82R0S_44CD8wId
 EubWaDz8FKhOBz4k7OqkcYbE20CejCoo.lY90QeSIMv6EEzsEZ2wQnzWIoWY
 sa8XcdhdC7YdL6n74cn7jv5Nx_bLRwY96S2xT37BQDZWMQ0rKjCFiYR4K4S2
 .LK_8DWLKnABCJ14spUbSRQgHJvGF26Ibh8l9BOBGgD6q.B55TPv4ta7pT0t
 rnuEhQW1.sVRSTguUgsU.QTKj0DJYm.J7_LoasQ0vM6WozBV91lwPve3oQlB
 bFfaWVYfAow_SmmWINvJvmcNDvkAuzbTKFF2XQeQYrA8wnlIv98q64exj20k
 GK.VrYi5ftat5H7NVYv9Ux4.ybOXu0ulGWaKdIQNyxqz5NoLPR4uJO_3nh8q
 JkbK0_WSjvihb2dqk9N9rHQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 15 Aug 2011 09:38:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Iliyan Malchev <malchev@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slub: name kmalloc slabs at creation time
In-Reply-To: <1312839071-18064-1-git-send-email-malchev@google.com>
Message-ID: <alpine.DEB.2.00.1108150934590.24941@router.home>
References: <1312839071-18064-1-git-send-email-malchev@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011, Iliyan Malchev wrote:

> This patch reserves a small static array to hold the names of the kmalloc
> slabs, and uses a small helper function __uitoa (unsigned integer to ascii) to
> format names as appropriately

simple_strtoull etc is not satisfactory?

> +/* Convert a positive integer to its decimal string representation, starting at
> + * the end of the buffer and going backwards, not exceeding maxlen characters.
> + */
> +static __init char *__pos_int_to_string(unsigned int value, char* string,
> +					int maxindex, int maxlen)
> +{
> +	int i = maxindex - 1;
> +	string[maxindex] = 0;
> +	for (; value && i && maxlen; i--, maxlen--, value /= 10)
> +		string[i] = '0' + (value % 10);
> +	return string + i + 1;
> +}

Please use the standard string operations of the kernel.

> @@ -3652,8 +3671,15 @@ void __init kmem_cache_init(void)
>  		caches++;
>  	}
>
> +	name_start = kmalloc_cache_names;
>  	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
> -		kmalloc_caches[i] = create_kmalloc_cache("kmalloc", 1 << i, 0);
> +		char *name = __pos_int_to_string(1 << i, name_start,
> +					KMALLOC_NAME_MAX - 1,
> +					KMALLOC_NAME_SUFFIX_MAX);
> +		name -= 8;

8 is what? The length of "kmalloc-" right?

