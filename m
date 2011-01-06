Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1AFPS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:18:29 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:58736 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1AFPS2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Thu, 6 Jan 2011 10:18:28 -0500
Message-Id: <4D25EB4B020000780002ABF7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 06 Jan 2011 15:18:19 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: "H. Peter Anvin" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Stephane Eranian" <eranian@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Soeren Sandmann Pedersen" <sandmann@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq
	 entry
References: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
 <1294325513-14276-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1294325513-14276-2-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.11 at 15:51, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> From the x86_64 low level interrupt handlers, the frame pointer is
> saved in pt_regs in the wrong place, in the offset of rbx.
> 
> rbx is not part of the irq partial saved registers, so it's not
> critical, but later code that uses get_irq_regs() to get the
> interrupted frame pointer instead get a stale rbx value, causing
> unwinding code to fail miserably.

Code using get_irq_regs() can't rely on the not explicitly
saved registers' fields of pt_regs anyway; you now fix this
for %rbp, but someone else might look at a different
register and want that to be saved too. You just shouldn't,
and the fact that %rbp happens to be saved at all shouldn't
be taken to mean you can access it via the provided
pt_regs pointer. This saving of %rbp could go away or be
done in a different way at any point.

> @@ -808,6 +813,8 @@ ret_from_intr:
>  	TRACE_IRQS_OFF
>  	decl PER_CPU_VAR(irq_count)
>  	leaveq
> +	/* we did not save rbx, restore only from ARGOFFSET */
> +	addq $8, %rsp
>  	CFI_RESTORE		rbp
>  	CFI_DEF_CFA_REGISTER	rsp
>  	CFI_ADJUST_CFA_OFFSET	-8

*If* the patch was to be taken anyway, I would strongly suggest
getting this mis-insertion fixed first: CFI annotations belong to the
immediately preceding instruction, and hence you must not insert
new instructions between an existing one and its annotation.

Furthermore, an adjustment to %rsp (when it serves as the frame
pointer as is the case here, though would be better visible if the
added instruction was at the right place) needs to be annotated
itself.

Jan

