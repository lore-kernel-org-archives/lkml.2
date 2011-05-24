Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab1EXWdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:33:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57457 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab1EXWdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:33:15 -0400
Message-ID: <4DDC31DF.5010303@zytor.com>
Date: Tue, 24 May 2011 15:31:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan>
In-Reply-To: <1306269105.21443.20.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 01:31 PM, Dan Rosenberg wrote:
> This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> which the kernel is decompressed at boot as a security feature that
> deters exploit attempts relying on knowledge of the location of kernel
> internals.  The default values of the kptr_restrict and dmesg_restrict
> sysctls are set to (1) when this is enabled, since hiding kernel
> pointers is necessary to preserve the secrecy of the randomized base
> address.
> 
> This feature also uses a fixed mapping to move the IDT (if not already
> done as a fix for the F00F bug), to avoid exposing the location of
> kernel internals relative to the original IDT.  This has the additional
> security benefit of marking the new virtual address of the IDT
> read-only.

As written, I think this is unsafe, simply because the kernel has no
idea what memory is actually safe to relocate into, and your code
doesn't actually make any attempt at doing so.

The fact that you change CONFIG_PHYSICAL_ALIGN is particularly
devastating, and will introduce boot failures on real systems.

For this to be acceptable, you need to at the very least:

1. Verify the in the address map passed to the kernel where it is safe
   to locate the kernel;
2. Not introduce a performance regression (we avoid locating in the
   bottom 16 MiB for performance reasons, except on very small systems);
3. Make sure not to break kdump.

Arguably this is really something that would be *much* better done in
the bootloader, but given that the dominant boot loader for Linux is
Grub, I don't expect that anything will ever happen until the cows come
home :(

	-hpa
