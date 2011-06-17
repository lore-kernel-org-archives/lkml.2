Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab1FQJzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:55:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:58626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab1FQJzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:55:36 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary physical addresses
Date: Fri, 17 Jun 2011 11:55:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu>
In-Reply-To: <20110617093032.GA19235@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106171155.32062.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 17. června 2011 11:30:32 Ingo Molnar napsal(a):
> * Petr Tesarik <ptesarik@suse.cz> wrote:
> > This patch series enhances /dev/mem, so that read and write is
> > possible at any address. The patchset includes actual
> > implementation for x86.
> 
> This series lacks a description of why this is desired.

Hi Ingo,

> My strong opinion is that it's not desired at all: /dev/mem never
> worked beyond 4G addresses so by today it has become largely obsolete
> and is on the way out really.
> 
> I'm aware of these current /dev/mem uses:
> 
>  - Xorg maps below 4G non-RAM addresses and the video BIOS
> 
>  - It used to have some debugging role but these days kexec and kgdb
>    has largely taken over that role - partly due to the 4G limit.

It is still used as a "memory source" by Dave Anderson's crash utility for 
live examination of a running system. Redhat has "overcome" the /dev/mem 
deficiencies by writing an out-of-tree re-implementation of /dev/mem, which 
uses /dev/crash instead. As it is an "unnecessary duplication of an existing 
driver", this method was rejected by the project manager here at SUSE.

The suggested alternative was to enhance (or fix) the existing driver. Without 
this patch series there is no way to access high memory. In conjunction with 
CONFIG_HIGHPTE, it makes the crash utility near to useless on anything with 
high memory, because crash can no longer translate virtual to physical 
addresses.

>  - there's some really horrible out-of-tree drivers that do mmap()s
>    via /dev/mem, those should be fixed if they want to move beyond
>    4G: their char device should be mmap()able.
> 
>  - all distro kernel's i'm aware of use CONFIG_STRICT_DEVMEM=y, which
>    restricts /dev/mem to non-RAM pages of physical memory.
>    [ With the sad inclusion of the first 1MB, which Xorg needs. ]

Well, there's one (quite unimportant) distro that doesn't compile with 
CONFIG_STRICT_DEVMEM: openSUSE (and SLES, consequently).

> Are you aware of any legitimate usecases?

See above - live crash sessions on i586 (or any other arch that has high 
memory).

> Frankly, i dont think we ever *want* to 'fix' /dev/mem to support
> addresses beyond 4G and grow messy userspace (and kernelspace) that
> somehow relies on that. Thank goodness that we never supported it ...

Let me put it differently. Do you think that an out-of-tree duplicated effort 
(the crash.ko module) offered by Redhat is somehow superior to enhancing the 
in-tree /dev/mem driver?

Regards,
Petr Tesarik
