Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab2JWUyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:54:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55537 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab2JWUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <20121023194233.GA23588@aepfle.de>
References: <20121023194233.GA23588@aepfle.de>
Date: Tue, 23 Oct 2012 13:54:31 -0700
X-Google-Sender-Auth: ax2AS7EEQG0ptnOJgR-LP6yjthk
Message-ID: <CAE9FiQV-FF9F7P6s3kMBjuyR3jWZ_VFERt83UVZmc7P37gLeTA@mail.gmail.com>
Subject: Re: when to switch from early_ioremap to ioremap
From: Yinghai Lu <yinghai@kernel.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 12:42 PM, Olaf Hering <olaf@aepfle.de> wrote:
>
> To obtain an address to a PFN in init_hypervisor_platform (called from
> arch/x86/kernel/setup.c:setup_arch) I use early_ioremap. Later the
> address to that PFN needs to be obtained with ioremap, and early_iounmap
> needs to be called on the first address.
>
> When is the time to obtain and use the new pointer, and to release to
> old pointer? Right now I do that in the pci-device setup code, which
> happens to work. Unfortunately early_ioremap is not mentioned in
> Documentation/, hence the question.

usually early_ioremap is used in this way:
map it and check it and unmap it. and some time you could back up it
before unmap.

you should only use early_iomap and early_memmap during SYSTEM_BOOTING

and check_early_ioremap_leak in late_initcall will check if all early
one get unmapped.

for 32bit, there is more requirement: you can not cross init_memory_mapping.
    early_ioremap_page_table_range_init/early_ioremap_reset will be
called in init_memory_mapping.

Also early_ioremap has slot limitation: 4. and you should not hold one
slot too long, otherwise other users could
have problem to reach the limit.

Yinghai
