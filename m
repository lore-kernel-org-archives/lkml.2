Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2ICM6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:58:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44128 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756412Ab2ICM6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:58:23 -0400
Date: Mon, 3 Sep 2012 13:58:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v2 20/31] arm64: User access library function
Message-ID: <20120903125810.GB3313@mbp>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-21-git-send-email-catalin.marinas@arm.com>
 <201208151449.54834.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151449.54834.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:49:54PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +/*
> > + * Single-value transfer routines.  They automatically use the right
> > + * size if we just have the right pointer type.  Note that the functions
> > + * which read from user space (*get_*) need to take care not to leak
> > + * kernel data even if the calling code is buggy and fails to check
> > + * the return value.  This means zeroing out the destination variable
> > + * or buffer on error.  Normally this is done out of line by the
> > + * fixup code, but there are a few places where it intrudes on the
> > + * main code path.  When we only write to user space, there is no
> > + * problem.
> > + */
> > +extern long __get_user_1(void *);
> > +extern long __get_user_2(void *);
> > +extern long __get_user_4(void *);
> > +extern long __get_user_8(void *);
> > +
> > +#define __get_user_x(__r2,__p,__e,__s,__i...)				\
> > +	   asm volatile(						\
> > +		__asmeq("%0", "x0") __asmeq("%1", "x2")			\
> > +		"bl	__get_user_" #__s				\
> > +		: "=&r" (__e), "=r" (__r2)				\
> > +		: "0" (__p)						\
> > +		: __i, "cc")
> > +
> > +#define get_user(x,p)							\
> > +	({								\
> > +		register const typeof(*(p)) __user *__p asm("x0") = (p);\
> > +		register unsigned long __r2 asm("x2");			\
> > +		register long __e asm("x0");				\
> > +		switch (sizeof(*(__p))) {				\
> > +		case 1:							\
> > +			__get_user_x(__r2, __p, __e, 1, "x30");		\
> > +			break;						\
> > +		case 2:							\
> > +			__get_user_x(__r2, __p, __e, 2, "x3", "x30");	\
> > +			break;						\
> > +		case 4:							\
> > +			__get_user_x(__r2, __p, __e, 4, "x30");		\
> > +			break;						\
> > +		case 8:							\
> > +			__get_user_x(__r2, __p, __e, 8, "x30");		\
> > +			break;						\
> > +		default: __e = __get_user_bad(); break;			\
> > +		}							\
> > +		x = (typeof(*(p))) __r2;				\
> > +		__e;							\
> > +	})
> 
> It's fairly unusual to have out of line get_user/put_user functions.
> What is the reason for this, other than copying from ARM?

I changed these to inline asm. The only reason which I don't think
matters much in this case is a few KB increase in Image size.

-- 
Catalin
