Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab1FWMYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:24:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:56126 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346Ab1FWMYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:24:01 -0400
Subject: Re: [PATCH] STAGING: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=windows-1252
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110623120234.GA22524@linux-mips.org>
Date: Thu, 23 Jun 2011 07:10:29 -0500
Cc: Martyn Welch <martyn.welch@ge.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-am33-list@redhat.com,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8B77EED3-D197-4AB9-9594-278DB7002D6D@kernel.crashing.org>
References: <20110623114536.GA14011@linux-mips.org> <4E032940.5010205@ge.com> <20110623120234.GA22524@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 23, 2011, at 7:02 AM, Ralf Baechle wrote:

> On Thu, Jun 23, 2011 at 12:53:36PM +0100, Martyn Welch wrote:
> 
>> On 23/06/11 12:45, Ralf Baechle wrote:
>>> On architectures that don't define PAGE_KERNEL_NOCACHE, the Comedi driver turns
>>> into tragedy:
>>> 
>>>  CC [M]  drivers/staging/comedi/drivers.o
>>> drivers/staging/comedi/drivers.c: In function ‘comedi_buf_alloc’:
>>> drivers/staging/comedi/drivers.c:505:41: error: ‘PAGE_KERNEL_NOCACHE’ undeclared (first use in this function)
>>> drivers/staging/comedi/drivers.c:505:41: note: each undeclared identifier is rep orted only once for each function it appears in
>>> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
>>> 
>>> Restrict the driver to only those architectures that define PAGE_KERNEL_NOCACHE.
>>> 
>>> PAGE_KERNEL_NOCACHE is a kludge - some system architectures such as SGI IP27
>>> are even uable to offer uncached operation - at least in the way an unwitting
>>> driver might assume.  I haven't looked in details how the driver is using
>>> the area vmaped with PAGE_KERNEL_NOCACHE but maybe doing it XFS-style using
>>> cached memory and the flush_kernel_vmap_range / invalidate_kernel_vmap_range
>>> APIs in conjunction with the DMA API is a practical alternative.
>>> 
>>> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>>> 
>>> drivers/staging/comedi/Kconfig |    1 +
>>> 1 files changed, 1 insertions(+), 0 deletions(-)
>>> 
>>> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
>>> index 1502d80..bccdc12 100644
>>> --- a/drivers/staging/comedi/Kconfig
>>> +++ b/drivers/staging/comedi/Kconfig
>>> @@ -2,6 +2,7 @@ config COMEDI
>>> 	tristate "Data acquisition support (comedi)"
>>> 	default N
>>> 	depends on m
>>> +	depends on BROKEN || FRV || M32R || MN10300 || SUPERH || TILE || X86
>> 
>> I'm sure I got comedi to compile on a 32-bit PPC board not that long ago. Has
>> something changed, or is this just not an exhaustive list?
> 
> (Adding the PPC folks to cc.)
> 
> A "git grep -w PAGE_KERNEL_NOCACHE arch/powerpc/" doesn't find anything so
> I don't think the driver will build there.  I don't have a PPC toolchain
> to verify that.

I can verify it fails on PPC as well:

drivers/staging/comedi/drivers.c: In function 'comedi_buf_alloc':
drivers/staging/comedi/drivers.c:505:37: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
drivers/staging/comedi/drivers.c:505:37: note: each undeclared identifier is reported only once for each function it appears in

However, we do have a #define for PAGE_KERNEL_NC.

- k