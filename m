Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2D0V1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:27:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13710 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab2D0V1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:27:37 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=szhx8aRwONgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D67S0rkNl-27A0lcCLwA:9 a=c7-O5rpMhBeuY3nvB00A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335562054.28106.239.camel@gandalf.stny.rr.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and
 -mfentry?
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 27 Apr 2012 17:27:34 -0400
In-Reply-To: <4F9B0B9B.9020909@linux.intel.com>
References: <1335552399.28106.228.camel@gandalf.stny.rr.com>
	  <20120427202701.GA5949@merkur.ravnborg.org>
	  <4F9B020B.9050205@linux.intel.com>
	 <1335560259.28106.234.camel@gandalf.stny.rr.com>
	 <4F9B0B9B.9020909@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 14:11 -0700, H. Peter Anvin wrote:
> On 04/27/2012 01:57 PM, Steven Rostedt wrote:
> >>
> >> Except it is the wrong thing.  This is not the only user of frame
> >> pointer.  What I think you mean is remove the dependency in Kconfig, but
> >> force the frame pointer enabled if -mfentry is not supported.
> > 
> > You mean option 3?
> > 
> > 3) Add frame pointers silently if gcc fails to build with gcc -pg.
> > 
> 
> Yes, your option 3.
> 

Actually, I just noticed this in the Makefile:

ifdef CONFIG_FRAME_POINTER
KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
else
# Some targets (ARM with Thumb2, for example), can't be built with frame
# pointers.  For those, we don't have FUNCTION_TRACER automatically
# select FRAME_POINTER.  However, FUNCTION_TRACER adds -pg, and this is
# incompatible with -fomit-frame-pointer with current GCC, so we don't use
# -fomit-frame-pointer with FUNCTION_TRACER.
ifndef CONFIG_FUNCTION_TRACER
KBUILD_CFLAGS   += -fomit-frame-pointer
endif
endif


Because of ARM thumb2, -fomit-frame-pointer is not added if
CONFIG_FRAME_POINTER is not set and FUNCTION_TRACER is. As it is fine to
just use '-pg', which gcc will add frame pointers if needed, and it is
only a problem if both -pg and -fomit-frame-pointer is set. We only need
to remove the select without doing anything else.

If -mfentry is added with -pg, and -fno-omit-frame-pointer is not set,
gcc will not add frame pointers by default.

So it seems that gcc took care of this problem for me :-)

I'll go and make a patch that simply removes the select.

Sorry for the noise ;-)

-- Steve


