Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2GILXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab2GILXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:23:53 -0400
Date: Mon, 9 Jul 2012 14:23:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
Message-ID: <20120709112346.GA23898@redhat.com>
References: <4FFA9E16.10001@linux.vnet.ibm.com>
 <4FFABD59.2070108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFABD59.2070108@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 02:15:37PM +0300, Avi Kivity wrote:
> On 07/09/2012 12:02 PM, Xiao Guangrong wrote:
> > After commit f78146b0f9230765c6315b2e14f56112513389ad:
> > 
> >  KVM: Fix page-crossing MMIO
> > 
> >     MMIO that are split across a page boundary are currently broken - the
> >     code does not expect to be aborted by the exit to userspace for the
> >     first MMIO fragment.
> > 
> >     This patch fixes the problem by generalizing the current code for handling
> >     16-byte MMIOs to handle a number of "fragments", and changes the MMIO
> >     code to create those fragments.
> > 
> >     Signed-off-by: Avi Kivity <avi@redhat.com>
> >     Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > Multiple MMIO reads can be merged into mmio_fragments, the read buffer is not
> > needed anymore
> > 
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> > ---
> >  arch/x86/include/asm/kvm_emulate.h |    1 -
> >  arch/x86/kvm/emulate.c             |   43 ++++-------------------------------
> >  arch/x86/kvm/x86.c                 |    2 -
> >  3 files changed, 5 insertions(+), 41 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> > index 1ac46c22..339d7c6 100644
> > --- a/arch/x86/include/asm/kvm_emulate.h
> > +++ b/arch/x86/include/asm/kvm_emulate.h
> > @@ -286,7 +286,6 @@ struct x86_emulate_ctxt {
> >  	struct operand *memopp;
> >  	struct fetch_cache fetch;
> >  	struct read_cache io_read;
> > -	struct read_cache mem_read;
> >  };
> > 
> 
> Suppose we have a RMW instruction.  On the first entry to
> x86_emulate_insn() we'll drop to userspace and perform the read, and the
> seconds we'll read from the cache and complete the write.
> 
> Without the read cache this cannot work.
> 
Cache is needed to emulate instructions that need more than one read
that can go to MMIO.

> kvm-unit-tests.git has a test for xchg to mmio.  Does it still work?
> 
> I agree this code has to go, but it needs to be replaced by something.
> Maybe a .valid flag in struct operand.
> 
Valid will not enough for that.

--
			Gleb.
