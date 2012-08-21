Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2HURv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:51:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57900 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab2HURv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:51:56 -0400
Date: Tue, 21 Aug 2012 18:51:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 17/31] arm64: System calls handling
Message-ID: <20120821175122.GI12708@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-18-git-send-email-catalin.marinas@arm.com>
 <201208151422.16335.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151422.16335.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:22:16PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +
> > +/* This matches struct stat64 in glibc2.1, hence the absolutely
> > + * insane amounts of padding around dev_t's.
> > + * Note: The kernel zero's the padded region because glibc might read them
> > + * in the hope that the kernel has stretched to using larger sizes.
> > + */
> > +struct stat64 {
> > +	compat_u64	st_dev;
> > +	unsigned char   __pad0[4];
> 
> The comment above struct stat64 is completely irrelevant here. I would instead
> explain why you need your own stat64 in the first place.

OK, I added a comment. It's only needed for compat.

> > +int kernel_execve(const char *filename,
> > +		  const char *const argv[],
> > +		  const char *const envp[])
> 
> Al Viro was recently talking about a generic implementation of execve.
> I can't find that now, but I think you should use that.

I've seen these but I'm waiting for the generic sys_execve and
kernel_execve to get into mainline before switch arch/arm64 to them.

> > +asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
> > +			 unsigned long prot, unsigned long flags,
> > +			 unsigned long fd, off_t off)
> > +{
> > +	if (offset_in_page(off) != 0)
> > +		return -EINVAL;
> > +
> > +	return sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
> > +}
> 
> I think
> 
> #define sys_mmap sys_mmap_pgoff 

There are slightly different semantics with the last argument of
sys_mmap() which takes a byte offset. The sys_mmap_pgoff() function
takes the offset shifted by PAGE_SHIFT (which is the same as sys_mmap2).

Looking at the other architectures, it makes sense to use a generic
sys_mmap() implementation similar to the one above (or the ia-64, seems
to be the most complete).

-- 
Catalin
