Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585Ab2KAUhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:37:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8225 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141Ab2KAUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:37:23 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EaluEUCYuSkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=U_9UZLlTPtUA:10 a=HJ28OZ2oNHYdhXhNRA4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351802241.4004.115.camel@gandalf.local.home>
Subject: Re: [PATCH] [PATCH] x86: Don't clobber top of pt_regs in nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Beulich <jbeulich@suse.com>
Cc: sqazi@google.com, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Nov 2012 16:37:21 -0400
In-Reply-To: <5092D31C020000780008EB6B@nat28.tlf.novell.com>
References: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
	 <1351731872.4004.112.camel@gandalf.local.home>
	 <5092D31C020000780008EB6B@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 19:53 +0000, Jan Beulich wrote:
> >>> Steven Rostedt <rostedt@goodmis.org> 11/01/12 2:04 AM >>>
> >On Mon, 2012-10-01 at 17:29 -0700, Salman Qazi wrote:
> >> @@ -1826,12 +1832,15 @@ repeat_nmi:
> >>       * is benign for the non-repeat case, where 1 was pushed just above
> >>       * to this very stack slot).
> >>       */
> >> -    movq $1, 5*8(%rsp)
> >> +    movq $1, 10*8(%rsp)
> >>  
> >>      /* Make another copy, this one may be modified by nested NMIs */
> >> +    addq $(10*8), %rsp
> >
> >This breaks the CFI magic.
> >
> >>      .rept 5
> >> -    pushq_cfi 4*8(%rsp)
> >> +    pushq_cfi -6*8(%rsp)
> >>      .endr
> >> +    subq $(5*8), %rsp
> >
> >So does this.
> >
> >This needs to be annotated correctly before I can push it out. But the
> >good news is, I stressed tested this change, and it all works out.
> >
> >Jan, can you help out here?
> 
> There doesn't appear to be anything special about these adjustments, so I
> don't see what help would be required here - it ought to be the normal use
> of CFI_ADJUST_CFA_OFFSET that needs adding.

Even the simple CFI adjustments look like magic to me :-)  OK, I'll
update the patch and send it out. I'll Cc you in case I screw up even
the most simple case ;-)

-- Steve


