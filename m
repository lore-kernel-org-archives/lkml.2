Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0GAW7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:59:13 -0400
Received: from shutemov.name ([188.40.19.243]:58737 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0GAW7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:59:12 -0400
Date: Fri, 2 Jul 2010 01:59:11 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King <rmk@arm.linux.org.uk>, g@shutemov.name
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anfei Zhou <anfei.zhou@gmail.com>
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
 pre-ARMv6
Message-ID: <20100701225911.GC10481@shutemov.name>
References: <20100701175144.GA2116@kroah.com>
 <20100701173212.785441106@clark.site>
 <20100701221420.GA10481@shutemov.name>
 <20100701221728.GA12187@suse.de>
 <20100701222541.GB10481@shutemov.name>
 <20100701224837.GA27389@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701224837.GA27389@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 11:48:37PM +0100, Russell King wrote:
> On Fri, Jul 02, 2010 at 01:25:41AM +0300, Kirill A. Shutemov wrote:
> > On Thu, Jul 01, 2010 at 03:17:28PM -0700, Greg KH wrote:
> > > We (well, I) like to keep the commit log identical to what is upstream
> > > just to make things easier all around.  Otherwise people start asking
> > > for spelling fixes, clarifications, and all sorts of other stuff (like
> > > this.)
> > 
> > Ok, fair enough.
> > 
> > I asked for it because I was confused by this commit message while
> > investigate (the same) problem on ARMv7 CPU.
> 
> You shouldn't get anywhere near this on ARMv7, because we know the cause
> of the prefetch abort on those CPUs.
> 
> On pre-ARMv6 CPUs, we always treat all prefetch aborts as a translation
> faults.  The problem which this commit addresses occurs when userspace
> tries to execute code above TASK_SIZE - we're sent into a loop of prefetch
> aborts (because we are unable to determine that it is a permission fault.)
> 
> ARMv6 and ARMv7 CPUs have an instruction fault status register, which
> tells us why the abort happened.  On these CPUs, permission faults go
> nowhere near the translation fault handler.

I know it. I was involved in writing this code.
 
> One possibility is that for some reason you're using the legacy prefetch
> abort code or pre-IFSR code, which will always tell the kernel that its
> a translation fault - and in this case, this patch would improve the
> situation.  What kernel version are you using?

2.6.32

> The commit message is accurate for the kernel version to which it was
> originally applied.

Simple testcase:

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	int fd;
	void (*p)(void);

	fd = open("/dev/urandom", O_RDONLY);
	read(0, &p, sizeof(p));
	printf("p: %p\n", p);
	p();
	return 0;
}

If you run this test in loop on kernel without the patch you'll finally
get hung instead SIGSEGV.

It seems the patch fixes more than it was written for. :)

-- 
 Kirill A. Shutemov
