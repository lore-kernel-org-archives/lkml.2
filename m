Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2JVVS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:18:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab2JVVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:18:55 -0400
Date: Mon, 22 Oct 2012 14:18:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Subject: Re: [PATCH resend] genalloc: stop crashing the system when
 destroying a pool
Message-Id: <20121022141854.33f5fcf4.akpm@linux-foundation.org>
In-Reply-To: <1350820392-25815-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1350820392-25815-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2012 09:52:59 -0200
Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com> wrote:

> A gen_pool_chunk uses a bitmap to find what addresses ranges it has
> allocated and bugs when we destroy the pool and a chunk has some bits
> set.
> 
> There is a problem when it allocates the bitmap. It allocates only the
> number of bytes needed for the bits that represent the size it's
> allocating. That is, if it needs 16 bits, it will allocate only 2 bytes,
> if it needs 31 bits, it will allocate 4 bytes.
> 
> However, the bitops functions uses long types. And when the gen_pool_add
> allocates a bitmap, it only clears the bytes it has allocated. So, it's
> possible that we have a long word with the contents 0xffffffffffffffff,
> and only the first (most significant) bytes are cleared by memset.
> However, the destroy function is going to test for the least significant
> bits, which will not be clear as expected.
> 

When fixing a bug, please do fully describe that bug.  The oops trace
would be nice, but can be avoided if a suitable description is included.

Does the BUG() happen in gen_pool_destroy(), or in gen_pool_free()?  In
either case, from your description it sound like the function which is
going BUG() is the site which needs fixing because it is checking for
non-zero bits outside the correct range?

