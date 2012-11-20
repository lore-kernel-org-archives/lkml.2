Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2KTRH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:07:29 -0500
Received: from relay3.sgi.com ([192.48.152.1]:51688 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752970Ab2KTRH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:07:27 -0500
Date: Tue, 20 Nov 2012 11:07:25 -0600
From: Russ Anderson <rja@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dimitri Sivanich <sivanich@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121120170723.GC11150@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20121117151611.GB16900@elgon.mountain> <20121120004834.GE5060@sgi.com> <20121120042855.GE6186@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120042855.GE6186@mwanda>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:28:56AM +0300, Dan Carpenter wrote:
> On Mon, Nov 19, 2012 at 06:48:34PM -0600, Russ Anderson wrote:
> > On Sat, Nov 17, 2012 at 06:16:11PM +0300, Dan Carpenter wrote:
> > > This is a static checker fix.  The problem is that we store the bits
> > > from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
> > > shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
> > > them.
> > 
> > Is this the complete patch?  phys_apicid is an int, but gets
> > cast as unsigned long.  Doesn't phys_apicid also have to be
> > changed to unsigned long?  And why ulong instead of uint (on x86_64)?
> 
> Uint is 32bit across all arches in linux and unix, according to
> wikipedia.

But long isn't 32bit across all arches.

http://software.intel.com/en-us/articles/size-of-long-integer-type-on-different-architecture-and-os

>             The wakeup_secondary_cpu() function pointer takes an int
> so I couldn't change the parameter.

Yes.  The real problem is much of the apicid code is based 
on signed int (ie parameters in struct apic).  Not sure why
they chose to make it signed, but since they did that decision
ripples through the rest of the code.  Changing it to unsigned
means changing struct apic, which likewise will ripple through
the rest of the code.  That is a much bigger change than
your patch deals with.

> > I agree with changing signed to unsigned where appropriate, but
> > this looks like a partial fix.  Am I missing something?
> > 
> 
> I do feel a little embarrassed that I didn't use "unsigned long"
> consistently.  I just used ulong to make the line a bit shorter, but
> I could redo it with "unsigned long" if you want.

The issue isn't "ulong" vs "unsigned long".  The issue
is int is 32 bit and long is 64 bit on x86_64.  Your 
patch is casting the value as an "unsigned long" (64 bit
on x86_64) into an int (32 bit).  I don't think that
was your intent.

This does highlight the problematic nature of "long" being
different size on different architectures.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
