Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2JMORM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:17:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2JMORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:17:08 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=94BoaM5cy3oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=JrLRxvAvNwkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=_A5TAQVKAAAA:8 a=gu6fZOg2AAAA:8 a=1nQ6uBj-7QzIdyjOKOUA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=t__e_55n4pAA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350137826.24256.110.camel@gandalf.local.home>
Subject: Re: [PATCH 16/25] parisc: Use Kbuild infrastructure to handle
 asm-generic headers
From: Steven Rostedt <rostedt@goodmis.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Date: Sat, 13 Oct 2012 10:17:06 -0400
In-Reply-To: <1350131814.2485.46.camel@dabdike.int.hansenpartnership.com>
References: <20121013022632.024527228@goodmis.org>
	 <20121013022954.722147403@goodmis.org>
	 <1350131814.2485.46.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-13 at 13:36 +0100, James Bottomley wrote:
> On Fri, 2012-10-12 at 22:26 -0400, Steven Rostedt wrote:
> > plain text document attachment
> > (0016-parisc-Use-Kbuild-infrastructure-to-handle-asm-gener.patch)
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Use Kbuild infrastructure to handle the asm-generic headers
> > and remove the wrapper headers that call them.
> > 
> > This only affects headers that do nothing but include the generic
> > equivalent. It does not touch any header that does a little more.
> > 
> > Cc: linux-kbuild@vger.kernel.org
> > Cc: linux-parisc@vger.kernel.org
> > Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> > Cc: Helge Deller <deller@gmx.de>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Actually, we're already evaluating a patch like this:
> 
> http://marc.info/?l=linux-kernel&m=134883983019018
> 
> When I compare the two, I notice you missed a few (segment.h, vga.h,
> hw_irq.h, mutex.h), so you probably want to adjust your scripts.
> 

Scripts? Naw I did this by hand:

cd arch/parisc/include/asm
vim `grep -l asm-generic *.h`

And in another terminal added the changes needed to Kbuild. I did this
by hand because it would have taken me the same time to verify scripts
to do it. By doing it by hand, I was less likely to add something that I
shouldn't have.

As Arnd mentioned, I didn't do a compare to check if what is in the
header is identical to the asm-generic version. That was going to be
"take 2". As this was just removing the simple cases of either:

foo.h:
#include <asm-generic/foo.h>

or

foo.h:
#ifndef _ASM_PARISC_FOO_H
#define _ASM_PARISC_FOO_H
#include <asm-generic/foo.h>
#endif

As for the ones I missed:

mutex.h has:

#include <asm-generic/mutex-dec.h>

which did not match mutex.h, so I ignored it. It would be removed in
"take 2" because it's identical to asm-generic/mutex.h.

segment.h:
#ifndef __PARISC_SEGMENT_H
#define __PARISC_SEGMENT_H

/* Only here because we have some old header files that expect it.. */

#endif


It missed the 'grep -l asm-generic' part.

vga.h and hw_irq.h are also empty (no asm-generic added). segment.h and
hw_irq.h are also empty in asm-generic, so they could be removed in take
2 as well. vga.h has some defines, but probably wouldn't affect parisc.

I don't care if you take this patch or not. As long as the old method of
adding a stub file to include asm-generic/foo.h is removed. This patch
set was caused by my frustration of looking at how to add a new
asm-generic file and coming up with the wrong implementation, and I want
to make sure that this doesn't happen again with another developer.

-- Steve


