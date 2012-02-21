Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2BUOoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:44:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab2BUOoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:44:15 -0500
Message-ID: <1329835436.12079.10.camel@springer.wildebeest.org>
Subject: Re: [PATCH] x86-64: Fix CFI data for common_interrupt
From: Mark Wielaard <mjw@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: "Frederic Weisbecker (commit_signer:4/25=16%)" <fweisbec@gmail.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Thomas Gleixner (maintainer:X86 ARCHITECTURE...)" 
	<tglx@linutronix.de>,
        "Andi Kleen (commit_signer:5/25=20%)" <ak@linux.intel.com>,
        "commit_signer:11/25=44%) Ingo Molnar (maintainer:X86 ARCHITECTURE..." 
	<mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "commit_signer:4/25=16%) H. Peter Anvin (maintainer:X86 "
	 "ARCHITECTURE..." <hpa@zytor.com>
Date: Tue, 21 Feb 2012 15:43:56 +0100
In-Reply-To: <4F43B78D020000780007435B@nat28.tlf.novell.com>
References: <1329833177-13030-1-git-send-email-mjw@redhat.com>
	 <4F43B78D020000780007435B@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 14:26 +0000, Jan Beulich wrote:
> >>> On 21.02.12 at 15:06, Mark Wielaard <mjw@redhat.com> wrote:
> > Commit eab9e6 "x86-64: Fix CFI data for interrupt frames" introduced
> > a DW_CFA_def_cfa_expression in the SAVE_ARGS_IRQ macro. To later define
> > the CFA using a simple register+offset rule both register and offset
> > need to be supplied. Just using CFI_DEF_CFA_REGISTER leaves the offset
> > undefined. So use CFI_DEF_CFA with reg+off explicitly at the end of
> > common_interrupt.
> 
> NAK, unless you can prove a path via which the offset will remain
> unset until hitting a CFI_DEF_CFA_REGISTER. And if you indeed
> found such a path, the entry point of the path is where the problem
> ought to be fixed.
> 
> Are you perhaps thinking that .cfi_def_cfa_register invalidates
> the offset in any way? That, to my knowledge, isn't the case, it
> just replaces the CFA register with the one specified, leaving the
> offset unchanged.

DW_CFA_def_cfa_expression invalidates the offset (and register). Used
through the interrupt macro for do_IRQ which uses the SAVE_ARGS_IRQ to
define common_interrupt. So after using DW_CFA_def_cfa_expression we get
a CFI_DEF_REGISTER and the CFI for common_interrupt looks like:

 [  6e30] FDE length=148 cie=[  6e18]
   CIE_pointer:              28184
   initial_location:         0xffffffff815e8d00 <common_interrupt>
   address_range:            0x1ba

   Program:
[...]
     advance_loc 1 to 0x69
     def_cfa_expression 6
          [   0] breg7 0
          [   2] deref
          [   3] const1u 136
          [   5] plus
     advance_loc 22 to 0x7f
     def_cfa_register r4 (rsi)
[...]

For DW_CFA_def_register DWARF4 explicitly says so: "This operation is
valid only if the current CFA rule is defined to use a register and
offset." So one needs to use CFI_DEF_CFA with both a register and an
offset here after the def_cfa_expression.

Thanks,

Mark
