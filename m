Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2AXUVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:21:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56374 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab2AXUVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:21:07 -0500
MIME-Version: 1.0
In-Reply-To: <1326686570-19303-2-git-send-email-maxim.uvarov@oracle.com>
References: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com> <1326686570-19303-2-git-send-email-maxim.uvarov@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jan 2012 12:20:46 -0800
X-Google-Sender-Auth: 2_IfWGbRqwCgXTJTt9D39WNSoyI
Message-ID: <CA+55aFxzfCxwYUcRbSyf+U7nr5GPjH4Qfine_TcY6Oxj8WQrWw@mail.gmail.com>
Subject: Re: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
To: Maxim Uvarov <maxim.uvarov@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wim@iguana.be,
        stable@vger.kernel.org, Thomas.Mingarelli@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I don't know who is supposed to be handling this (Wim?), but the
patch itself looks suspicious.

On Sun, Jan 15, 2012 at 8:02 PM, Maxim Uvarov <maxim.uvarov@oracle.com> wrote:
> -       set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
> +       set_memory_x((unsigned long)bios32_entrypoint & PAGE_MASK, 2);

If it wasn't page-aligned to begin with, then maybe it needs three pages now?

> -                               set_memory_x((unsigned long)cru_rom_addr, cru_length);
> +                               set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK, cru_length >> PAGE_SHIFT);

Same here. If we align the start address down, we should fix up the
length. And should we not align the number of pages up?

In general, a "start/length" conversion to a "page/nr" model needs to be roughly

   len += start & ~PAGE_MASK;
   start &= PAGE_MASK;
   nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;

to do things right. But I don't know where those magic numbers come
from. Maybe the "2" is already due to the code possibly traversing a
page boundary, and has already been fixed up. Somebody who knows the
driver and the requirements should take a look at this.

                      Linus
