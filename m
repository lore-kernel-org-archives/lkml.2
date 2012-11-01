Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218Ab2KATxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:53:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36094 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2KATxD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Thu, 1 Nov 2012 15:53:03 -0400
Message-Id: <5092D31C020000780008EB6B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 01 Nov 2012 19:53:00 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <rostedt@goodmis.org>, <sqazi@google.com>
Cc: <peterz@infradead.org>, <tglx@linutronix.de>,
        <torvalds@linux-foundation.org>, <hpa@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH] x86: Don't clobber top of pt_regs in
 nested NMI
References: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
 <1351731872.4004.112.camel@gandalf.local.home>
In-Reply-To: <1351731872.4004.112.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Steven Rostedt <rostedt@goodmis.org> 11/01/12 2:04 AM >>>
>On Mon, 2012-10-01 at 17:29 -0700, Salman Qazi wrote:
>> @@ -1826,12 +1832,15 @@ repeat_nmi:
>>       * is benign for the non-repeat case, where 1 was pushed just above
>>       * to this very stack slot).
>>       */
>> -    movq $1, 5*8(%rsp)
>> +    movq $1, 10*8(%rsp)
>>  
>>      /* Make another copy, this one may be modified by nested NMIs */
>> +    addq $(10*8), %rsp
>
>This breaks the CFI magic.
>
>>      .rept 5
>> -    pushq_cfi 4*8(%rsp)
>> +    pushq_cfi -6*8(%rsp)
>>      .endr
>> +    subq $(5*8), %rsp
>
>So does this.
>
>This needs to be annotated correctly before I can push it out. But the
>good news is, I stressed tested this change, and it all works out.
>
>Jan, can you help out here?

There doesn't appear to be anything special about these adjustments, so I
don't see what help would be required here - it ought to be the normal use
of CFI_ADJUST_CFA_OFFSET that needs adding.

Jan

