Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1AFRMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:12:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44033 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1AFRMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d6zp/YTJEDbS4+6Tubj0dYGIuiCBOuvWIKit+jQ6G6PMESxQriX7l1u+e8Dyr5PAip
         6sdvyXQe5e1UgDJt26PtWe3y9Mq/RIMtbrFvQWswjAw6qSVxZFM5MRxptD70FyBHnXrs
         RdRjHUmO1jD4gkiwlKOOpMRO51j4K0YjDG9PI=
Date: Thu, 6 Jan 2011 18:12:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: "H. Peter Anvin" <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq entry
Message-ID: <20110106171231.GD2308@nowhere>
References: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
 <1294325513-14276-2-git-send-email-fweisbec@gmail.com>
 <4D25EB4B020000780002ABF7@vpn.id2.novell.com>
 <20110106154536.GA2308@nowhere>
 <4D25F79F020000780002AC20@vpn.id2.novell.com>
 <20110106162236.GB2308@nowhere>
 <4D25FE5B020000780002AC50@vpn.id2.novell.com>
 <20110106165452.GC2308@nowhere>
 <4D2602DE020000780002ACA3@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2602DE020000780002ACA3@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 04:58:54PM +0000, Jan Beulich wrote:
> >>> On 06.01.11 at 17:54, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Thu, Jan 06, 2011 at 04:39:39PM +0000, Jan Beulich wrote:
> >> >>> On 06.01.11 at 17:22, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> > On Thu, Jan 06, 2011 at 04:10:55PM +0000, Jan Beulich wrote:
> >> >> >>> On 06.01.11 at 16:45, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> >> > Before we had:
> >> >> > 
> >> >> > 
> >> >> > 	leaveq
> >> >> > 
> >> >> > 	CFI_RESTORE             rbp
> >> >> > 	CFI_DEF_CFA_REGISTER    rsp
> >> >> > 	CFI_ADJUST_CFA_OFFSET   -8
> >> >> > 
> >> >> > So CFI_RESTORE means rbp has now the value of the base frame of
> >> >> > the calling frame (the base frame pointer of the interrupted proc) ?
> >> >> 
> >> >> No - all it means is that %rbp now has its original (caller or
> >> >> interrupted procedure) value again (i.e. an unwinder should not
> >> >> try to read it from the stack [or other previously recorded
> >> >> location] anymore).
> >> >> 
> >> >> > And what follows means that rsp-8 points to the return address?
> >> >> 
> >> >> No - .cfi_def_cfa_register says which register serves as the frame
> >> >> pointer, and .cfi_adjust_cfa_offset says to adjust the offset from
> >> >> the frame pointer to the top [or bottom] of frame. At any time
> >> >> 
> >> >> 	CFA = cfa_register + cfa_offset
> >> >> 
> >> >> with CFA being what all locations on the stack are expressed
> >> >> relative to.
> >> > 
> >> > Ok.
> >> > 
> >> > So here rsp points to pt_regs::r11
> >> > 
> >> > I don't understand why locations relative to the stack must be
> >> > expressed here by taking rsp - 8 as a base.
> >> 
> >> Nothing says rsp-8. The annotations merely say to set the base
> >> register to rsp and to *adjust* the offset by -8 (after all, that's
> >> what the leaveq instruction does).
> > 
> > Ah! So CFA acts like a virtual frame base pointer right?
> 
> Correct.

Ah great. I was starting to prepare for the case you come to stab me :)

So what do you think about that:

        leaveq

        CFI_RESTORE             rbp
        CFI_DEF_CFA_REGISTER    rsp
        CFI_ADJUST_CFA_OFFSET   -8

       /* we did not save rbx, restore only from ARGOFFSET */
       addq $8, %rsp
       CFI_ADJUST_CFA_OFFSET   -16


Does that look correct to you? We increased rsp to start recovering
the regs from the right place, but the frame pointer of the current
proc must stay what it was.

Now I don't understand how this is all useful as this is not a normal
proc but an interruption. We can't get back the return address from
the CFA. Or am I missing something?
