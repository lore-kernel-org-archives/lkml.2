Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1GFRqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:46:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357Ab1GFRqw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu>
References: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jul 2011 10:40:44 -0700
Message-ID: <CA+55aFzeB6qtbpd_A0DaqprAyDLcETgN71eyUCkSTjwC_5Wgyg@mail.gmail.com>
Subject: Re: [PATCH] fs: fix lock initialization
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 3:33 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> locks_alloc_lock() assumed that the allocated struct file_lock is
> already initialized to zero members.  This is only true for the first
> allocation of the structure, after reuse some of the members will have
> random values.

Ugh. Code that depends on SLAB initializers is broken.

The reason for those initializers are traditionally "better cache
behavior" where you don't need to initialize everything at allocation
time, but the whole concept is almost invariably a disaster. This is a
prime example of it.

I also doubt the cache value - what happens is that you tend to touch
_part_ of the cachelines instead of just clearing the whole thing,
which is quite often not at all more efficient. And even when you are
able to avoid touching a cacheline entirely, most of the time it just
moves the cache miss cost elsewhere to the user.

There are some valid uses of initializers (eg code that depends on RCU
freeing and very much is about not re-initializing a lock), but they
really are about those kinds special cases. We should try to encourage
people to limit initializers to *only* those kinds of things.

Thanks for noticing,

               Linus
