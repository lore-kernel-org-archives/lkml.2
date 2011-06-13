Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1FMKIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:08:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60300 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1FMKIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c02DjdyoijvTIgrwLTNkp0boq3tQwV/OewVwak3p1xw7RuUPga3t05SITHbrwLgUyX
         dhlTdPUc4wyH4k3tcBlLVMU8QVoFrP+UL5pp55871sc5fmN21fgN0YDej8Fscn5Jwdpc
         k0cisRhZHHsoofy1hkduNaC2FFEQqOZsZCVzc=
Date: Mon, 13 Jun 2011 11:08:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-fbdev@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] fb.h: ARM uses __raw_{read/write}
Message-ID: <20110613100819.GA26914@1n450.cable.virginmedia.net>
References: <201106101731.08578.hartleys@visionengravers.com>
 <20110613040003.GA29731@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613040003.GA29731@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 01:00:04PM +0900, Paul Mundt wrote:
> On Fri, Jun 10, 2011 at 05:31:08PM -0700, H Hartley Sweeten wrote:
> > ARM provides __raw_{read/write}* functions for memory access. These
> > should be used instead of the default '(*(volatile' stuff to make sure the
> > memory accesses are typesafe (void __iomem *).
> > 
> > This also fixes a number of sparse warning like:
> > 
> >   warning: cast removes address space of expression
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > Cc: Russell King <linux@arm.linux.org.uk>
> 
> I'm not sure what semantics are desirable for ARM here, so I'll wait for
> Russell to reply.
> 
> This wrapping will basically mean that the fb_read/write ops are using
> __raw_xxx variants while the memset and memcpy wrappers will be using the
> regular read/write[bwl] routines which contain __iormb() calls. Given
> that ioread/write and friends all wrap in to the normal versions with the
> barriers, I would suppose that this is the default behaviour that is
> desired, as opposed to wrapping in to the __raw_xxx variants directly.

The intention for the __iormb/__iowmb calls is in relation to DMA
transfers where a buffer in normal RAM is filled in with data and the
transfer started by a writel() to a device. We need to make sure that
the normal RAM writing completes before the writel().

The change proposed by Hartley wouldn't make much difference from the
current volatile accesses (__raw_* accessors are implemented as volatile
on ARM).

I think the memcpy_(from|to)io could be optimised on ARM to only add a
barrier before or after he copying loop.

-- 
Catalin
