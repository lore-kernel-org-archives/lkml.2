Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1FUXFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:05:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015Ab1FUXFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:05:51 -0400
Date: Tue, 21 Jun 2011 16:05:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Arun Sharma <asharma@fb.com>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 6/6] Blackfin: SMP: convert to common
 asm-generic/atomic.h
Message-Id: <20110621160528.7c92cff0.akpm@linux-foundation.org>
In-Reply-To: <1308347614-402-7-git-send-email-vapier@gentoo.org>
References: <1308347614-402-1-git-send-email-vapier@gentoo.org>
	<1308347614-402-7-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 17:53:34 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> Now that common code supports SMP systems, switch our SMP atomic logic
> over to it to avoid code duplication.

There were some rejects on this one, I think because lines 2, 3 and 4
had non-ascii crap in them and because your patch was expecting
inclusions of asm-generic/atomic-long.h and asm-generic/atomic64.h,
which were removed.

I ended up with the below but I don't know if it works.

/*
 * Copyright 2004-2011 Analog Devices Inc.
_*
_* Licensed under the GPL-2 or later.
_*/

#ifndef __ARCH_BLACKFIN_ATOMIC__
#define __ARCH_BLACKFIN_ATOMIC__

#ifdef CONFIG_SMP

#include <linux/linkage.h>

asmlinkage int __raw_uncached_fetch_asm(const volatile int *ptr);
asmlinkage int __raw_atomic_update_asm(volatile int *ptr, int value);
asmlinkage int __raw_atomic_clear_asm(volatile int *ptr, int value);
asmlinkage int __raw_atomic_set_asm(volatile int *ptr, int value);
asmlinkage int __raw_atomic_xor_asm(volatile int *ptr, int value);
asmlinkage int __raw_atomic_test_asm(const volatile int *ptr, int value);

#define atomic_read(v) __raw_uncached_fetch_asm(&(v)->counter)

#define atomic_add_return(i, v) __raw_atomic_update_asm(&(v)->counter, i)
#define atomic_sub_return(i, v) __raw_atomic_update_asm(&(v)->counter, -(i))
#define atomic_clear_mask(m, v) __raw_atomic_clear_asm(&(v)->counter, m)
#define atomic_set_mask(m, v)   __raw_atomic_set_asm(&(v)->counter, m)

#endif

#include <asm-generic/atomic.h>

#endif
