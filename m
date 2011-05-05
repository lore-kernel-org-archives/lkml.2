Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1EEHCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:02:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1EEHCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:02:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] compat: fixes to allow working with tile arch
Date: Thu, 5 May 2011 09:01:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
References: <201105042004.p44K4nRJ011722@farm-0032.internal.tilera.com>
In-Reply-To: <201105042004.p44K4nRJ011722@farm-0032.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105050901.50673.arnd@arndb.de>
X-Provags-ID: V02:K0:w5H6HC8bLswpTt14MENnMJgHfSW3TGOBtm7/gxL8CZ0
 0BMJrxVnzVPKkI45hlOiPdEWWC3d4TZkWiGcu/eFxlVmkKYE+W
 4ccZpcAoRTErA9UFB/jh2tBy9jJncU5xrEeWIMbogZuwKmOyyt
 gyDAo2eik3W1vMGpxcx4IzOyHZ3oMo7Y8pSr8JUyoKKiD0SqtJ
 nwWGD/Y77twwVLAmR0QIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 May 2011, Chris Metcalf wrote:
> <linux/compat.h> doesn't currently provide enough to allow the new
> <asm-generic/unistd.h> approach to work for the compat syscall vector.
> In principle you should be able to "#define __SYSCALL(nr, call)
> [nr] = (compat_##call)," and then #include <asm/unistd.h>.  This change
> adds all the remaining compat_sys_xxx() prototypes, and also adds
> appropriate #defines for compat syscalls that can use the non-compat
> implementation.  See arch/tile/kernel/compat.c for an example.

I didn't realize this was still missing, my impression was that this
already worked when you added the tile arch tree, but apparently
I was missing something there.

Thanks for bringing it up and doing the patch for it!

> +/* Standard Linux functions that don't have "compat" versions. */
> +#define compat_sys_accept sys_accept
> +#define compat_sys_accept4 sys_accept4
> +#define compat_sys_access sys_access
> +#define compat_sys_acct sys_acct
> +#define compat_sys_add_key sys_add_key
> ...

It seems kludgy to have to add all the "regular" system calls to yet
another list, I'd prefer the default to be using the same entry point
for the regular syscall and the compat_ version, so you only need to
list the exceptions in the asm-generic/unistd.h file.

Maybe something like

#if __BITS_PER_LONG == 32 || defined(__SYSCALL_COMPAT)
#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _32)
#define __SC_COMP(_nr, _32, _64) __SYSCALL(_nr, _32)
#elif defined(__SYSCALL_COMPAT)
#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _32)
#define __SC_COMP(_nr, _32, _64) __SYSCALL(_nr, compat ## _32)
#else
#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _64)
#define __SC_COMP(_nr, _32, _64) __SYSCALL(_nr, _64)
#endif

Then you replace all __SC_3264 with __SC_COMP for the cases where
you call the compat version instead of the regular syscall in case
of 32-bit compat.

Alternatively, you could create a tristate version in addition
to the existing __SC_3264:

#ifdef __SYSCALL_COMPAT
#define __SC_COMP(_nr, _32, _64, _comp) __SC_3264(_comp, _64)
#else
#define __SC_COMP(_nr, _32, _64, _comp) __SC_3264(_32, _64)
#endif

This requires listing all entry points explicitly, but makes it easier
to grep for where the compat syscalls are actually used.

	Arnd
