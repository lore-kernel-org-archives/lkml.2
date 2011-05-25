Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1EYQzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:55:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:30021 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab1EYQzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:55:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="1545127"
Date: Wed, 25 May 2011 09:54:36 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525165436.GA14958@tassilo.jf.intel.com>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525065451.GC429@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525065451.GC429@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 08:54:51AM +0200, Ingo Molnar wrote:
> > +	/* CPU update signature */
> > +	u32			x86_cpu_update;
> 
> This should be cpu_microcode_version instead. We already know its x86 so the 
> x86_ prefix is superfluous. 'cpu_update' is also rather ambigious and does not 
I followed the convention of the other fields in cpu_data, but I'll drop 
the prefix.

"cpu update" was the name that was suggested to me. Sorry if it's a
bit vague. Apparently calling it microcode is not politically correct.
I'll keep it for now. If you want to really change it please send
another email.

> 
> So, during the course of developing this, did it occur to you that other x86 
> CPUs should fill in this information as well?

Yes, it did in fact, but I hope someone else will do that because I have no way to test it.


> > -	/* see notes above for revision 1.07.  Apparent chip bug */

This particular code pattern has no chip bug. The CPUID is required
by the documentation! So whoever wrote it didn't read the documentation.
So yes I dropped that obviously bogus comment.

> 
> Why? If you think it's not a bug (but got documented meanwhile as the official 
It always was documented this way.

> way of updating the microcode and reading out the version) then update the 
> comments in a *separate* patch, and update the *other* reference to it as well.

I'm not sure about the other references. The documentation just
states the CPUID is needed for reading the revision.

Anyways I'll just leave the comment around for now.


> > +
> > +	seq_printf(m, "\n");
> 
> This too should say microcode version.
> 
> Also, please move the field to the logical place, next to "stepping:". The 
> argument about parsers is bogus - anyone parsing /proc/cpuinfo is not in a 
> fastpath, full stop.

The rationale was not cycles, but if someone was stupid enough
to hardcode the line number offsets while parsing. You never know with user 
space /proc parsers and assuming the worst is always the best.

I thought it was safest to add new fields at the end.

> 
> Also, the above sequence is rather suboptimal to begin with - we can and only 
> want to execute a *single* seq_printf() there.

Sorry I don't understand the comment. Anyways as you say above 
it's no fast path, so it shouldn't matter.

> Please factor out the reading of the microcode version - you have now created 
> two duplicated open-coded versions of it in cpu.c and microcode_intel.c, with 
> mismatching comments - not good.

Huh? There's only a single one now.

> it would be nice to put a check:
> 
> 		WARN_ON_ONCE(val[1] != c->x86_cpu_update);

Ok.

-Andi
