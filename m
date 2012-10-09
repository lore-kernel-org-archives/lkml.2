Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2JISUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:20:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2JISUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:20:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH 5/9] ARM: Xen: fix initial build problems:
Date: Tue, 9 Oct 2012 18:19:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <201210091539.46274.arnd@arndb.de> <1349799035.21847.222.camel@zakaz.uk.xensource.com>
In-Reply-To: <1349799035.21847.222.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091819.34310.arnd@arndb.de>
X-Provags-ID: V02:K0:npXf8fVpImnJ1kySbqNOiwZiZgnNQDHa+u/cVdVwT7H
 Gs6djRiK1bvnKytiWm8Lm+x8AcUYF6H3Qd9OFcSKqacjIJVBR4
 /XbpoyX2s8231kNHi5M+QFDtYL24IEpaw627Q9zJ4TZwk1UpJP
 1b1FJBgLEiwU1GooIEduJIg9r0kV+lEKAbs76ENoFdHGME89R7
 +j0xZ2AOkRy4m3FZosy1p075ND3AQ+ApTLSUX7cOUnpeE2JuDv
 ZjIOt11DKdwPYthzSFr/oSg52pgVZHa1M3DUp26BbeR6PE8Th2
 C5wC8Fzarlldibrq1/mntAq6JVHmNBd0TQnC+fFW8Z1RljyI3l
 SOFGZCEHMHymEjXagWvU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012, Ian Campbell wrote:
> On Tue, 2012-10-09 at 16:39 +0100, Arnd Bergmann wrote:
> > On Tuesday 09 October 2012, Ian Campbell wrote:
> > > > * The tmem hypercall is not available on ARM
> > > > 
> > > > * ARMv6 does not support cmpxchg on 16-bit words that are used in the
> > > 
> > > missing the end of this sentence?
> > 
> > Right, I meant to say 
> > 
> > * ARMv6 does not support cmpxchg on 16-bit words that are used in the
> >   Xen grant table code, so we must ensure that Xen support is only built
> >   on ARMv7-only kernels not combined ARMv6/v7 kernels.
> > 
> > This should be fixed differently in the future.
> 
> Is this is a build time failure because gcc/gas/etc refuses to generate
> these instructions if it is configured for v6?
> 
> I ask because if it is only a runtime issue then we can reason that if
> we are running Xen specific grant table code, then we must be running on
> Xen and therefore must necessarily be running on a v7 (because Xen only
> support v7+virt extensions) even if the kernel happens to be capable of
> running on v6 too.

The underlying reason of course is that ARMv6 doesn't have those
instructions. The symptom you see is a link error because gcc emits
a reference to the (intentionally missing) __bad_cmpxchg() function
from

static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
                                      unsigned long new, int size)
{
        unsigned long oldval, res;

        switch (size) {
#ifndef CONFIG_CPU_V6   /* min ARCH >= ARMv6K */
        case 1:
		...
                break;
        case 2:
		...
                break;
#endif
        case 4:
		...
                break;
        default:
                __bad_cmpxchg(ptr, size);
                oldval = 0;
        }
        return oldval;
}

The possible solutions I can see for this are:

* change the grant table format to use 32 bits for the flags on ARM
* change the code to always cmpxchg the entire 32 bit word including the flags.
* implement your own cmpxchg wrapper that may be implemented using a spinlock
  rather than cmpxchg if ARMv6 is enabled.

	Arnd
