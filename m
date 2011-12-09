Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1LIVs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 16:48:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1LIVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 16:48:55 -0500
Date: Fri, 9 Dec 2011 13:48:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@lst.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2] ipc: provide generic compat versions of IPC syscalls
Message-Id: <20111209134852.f5b5bcbc.akpm@linux-foundation.org>
In-Reply-To: <201112091903.pB9J39pd031553@farm-0002.internal.tilera.com>
References: <201112091536.pB9Fa5f7002738@farm-0002.internal.tilera.com>
	<201112091602.31325.arnd@arndb.de>
	<201112091903.pB9J39pd031553@farm-0002.internal.tilera.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011 10:29:07 -0500
Chris Metcalf <cmetcalf@tilera.com> wrote:

> When using the "compat" APIs, architectures will generally want to
> be able to make direct syscalls to msgsnd(), shmctl(), etc., and
> in the kernel we would want them to be handled directly by
> compat_sys_xxx() functions, as is true for other compat syscalls.
> 
> However, for historical reasons, several of the existing compat IPC
> syscalls do not do this.  semctl() expects a pointer to the fourth
> argument, instead of the fourth argument itself.  msgsnd(), msgrcv()
> and shmat() expect arguments in different order.
> 
> This change adds an __ARCH_WANT_OLD_COMPAT_IPC define that can be
> set in <asm/compat.h> to preserve this behavior for ports that use it
> (x86, sparc, powerpc, s390, and mips).  No actual semantics are changed
> for those architectures, and there is only a minimal amount of code
> refactoring in ipc/compat.c.
> 
> Newer architectures like tile (and perhaps future architectures such
> as arm64 and unicore64) should not supply this define, and thus can
> avoid having any IPC-specific code at all in their architecture-specific
> compat layer.  In the same vein, if this define is omitted, IPC_64 mode
> is assumed, since that's what the <asm-generic> headers expect.
> 
> The workaround code in "tile" for msgsnd() and msgrcv() is removed
> with this change; it also fixes the bug that shmat() and semctl() were
> not being properly handled.

What would we need to do to get all architectures using the new
interfaces, and remove __ARCH_WANT_OLD_COMPAT_IPC?

Regarding the implementation: rather than patching the header
files, it would be more conventional (and arguably better) to add

	select ARCH_WANT_OLD_COMPAT_IPC

to arch/*/Kconfig, then use CONFIG_ARCH_WANT_OLD_COMPAT_IPC.
