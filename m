Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab0FJSsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:48:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58048 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0FJSsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:48:40 -0400
Date: Thu, 10 Jun 2010 20:48:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Brian Gordon <legerde@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Aerospace and linux
Message-ID: <20100610184838.GI19561@basil.fritz.box>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com> <877hm64ui4.fsf@basil.nowhere.org> <AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 12:38:10PM -0600, Brian Gordon wrote:
> > It's also a serious consideration for standard servers.
> Yes. Good point.
> 
> > On server class systems with ECC memory hardware does that.
> 
> > Normally server class hardware handles this and the kernel then reports
> > memory errors (e.g. through mcelog or through EDAC)
> 
> Agreed.  EDAC is a good and sane solution and most companies do this.

Sorry, but you mean ECC? 

IMHO EDAC Is not a good solution for error reporting (however I'm biased
because I work on a better one)

> Some do not due to naivity or cost reduction.   EDAC doesn't cover
> processor registers and I have fairly good solutions on how to deal
> with that in tiny "home-grown" tasking systems.

mcelog covers OS visible processor registers on x86 systems.

If your hardware doesn't support it it's hard for the general
case, although special cases are always possible.
> 
> > Lower end systems which are optimized for cost generally ignore the
> > problem though and any flipped bit in memory will result
> > in a crash (if you're lucky) or silent data corruption (if you're unlucky)
> 
> Right!  And this is the area that I am interested in.  Some people
> insist on lowering the cost of the hardware without considering these
> issues.  One thing I want to do is to be as diligent as possible (even
> in these low cost situations) and do the best job I can in spite of
> the low cost hardware.

AFAIK there's no support for this in a standard Linux kernel.

That is some architectures do scrubbing in software,
but the basic ECC implementation is still hardware.

In general I suspect you'll need some application specific
strategy, if your hardware doesn't help you in this. 

Having good hardware definitely helps, software is generally
not happy if it cannot trust its memory enough.

It's a bit like a human with no reliable air supply.

That is the existing memory error handling mechanisms (like hwpoison)
assume events are reliably detected and are relatively rare.

> 
> So, some pages of RAM are going to be read-only and the data in those
> pages came from some source (file system?).   Can anyone describe a
> high level strategy to occasionaly provide some coverage of this data?

Just for block data there's some support for checksumming
e.g, block integrity (needs special support in the device)
or file systems (e.g. btrfs)

However they all normally assume memory is reliable and
are more focussed on errors coming from storage.

> 
> So far I have thought about page descriptors adding an MD5 hash
> whenever they are read-only and first being "loaded/mapped?" and then
> a background daemon could occasionaly verify.  

In theory btrfs or block integrity could be probably extended
to regularly re check page cache. It would not be trivial

But to really catch errors before use you would need to recheck on 
every access, and that's hard (or rather extremly slow) in some cases 
(e.g. mmap)

And this still wouldn't help with r/w memory. Normally on most
workloads r/o (that is clean) memory is the only a small fraction of the 
active memory. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
