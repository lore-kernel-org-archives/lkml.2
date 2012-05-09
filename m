Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962Ab2EIUIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037Ab2EIUH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:07:58 -0400
Date: Wed, 9 May 2012 23:07:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bitops: add _local bitops
Message-ID: <20120509200735.GA22743@redhat.com>
References: <20120509134528.GA18044@redhat.com>
 <20120509121940.459e93ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509121940.459e93ba.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 12:19:40PM -0700, Andrew Morton wrote:
> On Wed, 9 May 2012 16:45:29 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > kvm needs to update some hypervisor variables atomically
> > in a sense that the operation can't be interrupted
> > in the middle. However the hypervisor always runs
> > on the same CPU so it does not need any memory
> > barrier or lock prefix.
> 
> Well.  It adds more complexity, makes the kernel harder to understand
> and maintain and introduces more opportunities for developers to add
> bugs.  So from that point of view, the best way of handling this patch
> is to delete it.
> 
> Presumably the patch offers some benefit to offest all those costs. 
> But you didn't tell us what that benefit is, so we cannot make
> a decision.
> 
> IOW: numbers, please.  Convincing ones, for realistic test cases.

I can try but in practice it's not an optimization.
What kvm needs is a guarantee that a memory update will be done in a
single instruction.

> Secondly: can KVM just use __set_bit() and friends?  I suspect those
> interfaces happen to meet your requirements.  At least on architectures
> you care about.

Sigh. I started with this, but then Avi Kivity said that he's worried
about someone changing __test_and_clear_bit on x86
such that the change won't be atomic (single instruction) anymore.
So I put inline asm into kvm.c. This drew comment from Peter
that maintaining separate asm code in kvm.c adds too much
maintainance overhead so I should implement _local, add
asm-generic fallback and put it all in generic code.

In practice ATM any of the above will work. We probably don't even need
to add barrier() calls since what we do afterwards is apic access which
has an optimization barrier anyway.  But I'm fine with adding them in
there just in case if that's what people want.

However, since we've come full circle, I'd like to have a discussion
on what, exactly, is acceptable to all maintainers.
Avi, Andrew, Peter, could you please comment?

-- 
MST
