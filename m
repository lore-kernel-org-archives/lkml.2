Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2DPO2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:28:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab2DPO2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:28:48 -0400
Message-ID: <4F8C2C90.6030703@redhat.com>
Date: Mon, 16 Apr 2012 17:28:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/16] KVM: MMU: return bool in __rmap_write_protect
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FBC1.5010907@linux.vnet.ibm.com> <20120414110031.38450bebfe712215f01d529f@gmail.com> <4F8AB02A.9020601@redhat.com> <20120416231455.f978b3ac9fb995cfce2853ae@gmail.com>
In-Reply-To: <20120416231455.f978b3ac9fb995cfce2853ae@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 05:14 PM, Takuya Yoshikawa wrote:
> On Sun, 15 Apr 2012 14:25:30 +0300
> Avi Kivity <avi@redhat.com> wrote:
>
> > > > @@ -1689,7 +1690,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
> > > > 
> > > >  	kvm_mmu_pages_init(parent, &parents, &pages);
> > > >  	while (mmu_unsync_walk(parent, &pages)) {
> > > > -		int protected = 0;
> > > > +		bool protected = false;
> > > > 
> > > >  		for_each_sp(pages, sp, parents, i)
> > > >  			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);
> > >
> > > Isn't this the reason we prefer int to bool?
> > >
> > > Not sure people like to use |= with boolean.
> > >
> > 
> > Why not?
> > 
>
> The code "bitwise OR assignment" is assuming the internal representations
> of true and false: true=1, false=0.

No, it doesn't.  |= converts the result back to bool.

In fact it's better than

   int x;
   ...
   x |= some_value() & MASK;

   since MASK might be of type longer than int, and the result can be
truncated.  With bool |=, it cannot.

Disassembly of section .text:

0000000000000000 <f>:

static bool x;

void f(long y)
{
    x |= y;
   0:   0f b6 05 00 00 00 00    movzbl 0x0(%rip),%eax        # 7 <f+0x7>
                        3: R_X86_64_PC32        .bss-0x4
   7:   48 09 c7                or     %rax,%rdi
   a:   0f 95 05 00 00 00 00    setne  0x0(%rip)        # 11 <f+0x11>
                        d: R_X86_64_PC32        .bss-0x4
}
  11:   c3                      retq  

The corresponding code with 'int x' would just store the truncated
result back into x.


> I might have seen some point if it had been
> 	protected = protected || rmap_...
>
>
> But the real question is whether there is any point in re-writing completely
> correct C code: there are tons of int like this in the kernel code.
>
> __rmap_write_protect() was introduced recently, so if this conversion is
> really worthwhile, I should have been told to use bool at that time, no?

It's up to developer and maintainer preference.  I like bool since it
documents the usage and is safer, but sometimes I miss it on review.

-- 
error compiling committee.c: too many arguments to function

