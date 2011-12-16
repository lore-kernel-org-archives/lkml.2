Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab1LPIsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:48:43 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:51662 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1LPIsm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Fri, 16 Dec 2011 03:48:42 -0500
Message-Id: <4EEB13F602000078000686D7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 16 Dec 2011 08:48:38 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Christoph Lameter" <cl@linux.com>
Cc: <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <dhowells@redhat.com>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-tip-commits@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/asm] x86: Fix and improve
 percpu_cmpxchg{8,16}b_double()
References: <4EE86D6502000078000679FE@nat28.tlf.novell.com>
 <tip-cebef5beed3de3037de85a521495897256b2c5da@git.kernel.org>
 <alpine.DEB.2.00.1112151627060.11871@router.home>
In-Reply-To: <alpine.DEB.2.00.1112151627060.11871@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.12.11 at 23:52, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 15 Dec 2011, tip-bot for Jan Beulich wrote:
>> The __dummy variable was pointless (and needlessly initialized
>> in the 2x32-bit case), given that local copies of the inputs
>> already exist.
> 
> Hmm... I had some failures if I did not specify that dummy in the
> inline asm. Does this work for all gcc versions?

You need to have the output go somewhere, but using the already
existing __o2 for this purpose is possible and sufficient.

>> The 2x64-bit variant forced the address of the first object into
>> %rsi, even though this is needed only for the call to the
>> emulation function. The real cmpxchg16b can operate on an
>> memory.
> 
> Yup. Good idea to code the load into the alternative code path to avoid
> the cmpxchg of the primary code path to be restricted to %si register.
> 
> You dropped the padding with NOPs. Are the instructions on both paths
> always the same length?

leaq and cmpxchg16b use the same operand, so their modrm
encoding (including eventual SIB and immediate) are the same.

leaq is REX+opcode+modrm...
cmpxchg16b (SEG+)REX+0x0f+opcode+modrm

so the latter is two bytes longer than the former (one byte in UP).

call being five bytes vs setz %al being 3 bytes makes it that
lea+call are one byte longer than cmpxchg16b+setz in the UP case,
but I think this is tolerable. If not, the operand of lea could be
made %rip-relative for the case where the operand is a direct
access (i.e. become %1 instead of %P1).

Jan

