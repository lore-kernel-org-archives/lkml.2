Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1KKIwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:52:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47975 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab1KKIwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:52:54 -0500
Date: Fri, 11 Nov 2011 08:52:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Nai Xia <nai.xia@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: mm: convert vma->vm_flags to 64bit
Message-ID: <20111111085239.GA12913@n2100.arm.linux.org.uk>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com> <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com> <alpine.DEB.2.00.1111092048520.27280@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111092048520.27280@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:49:58PM -0800, David Rientjes wrote:
> On Thu, 10 Nov 2011, Nai Xia wrote:
> 
> > Did this patch get merged at last, or on this way being merged, or
> > just dropped ?
> > 
> 
> I thought we were waiting to find out if it caused a problem on arm.  
> Either Russell should be able to clarify that or a couple months in 
> linux-next.

As I said last time, these flags are passed into assembly on ARM.  For
example, we pass a pointer to the VMA, and the assembly code them loads
the vma flags to check whether VM_EXEC is set, so it knows whether it
needs to flush the instruction TLB.

Making this a 64-bit quantity then means we have to deal with the host
endian issues and the position of the VM_EXEC bit inside that 64-bit
quantity.  Remembering that ARM is 32-bit, that needs additional
complexity to sort out, something like:

#ifdef __ARMEB__
#define VM_FLAGS_LOWWORD	4
#else
#define VM_FLAGS_LOWWORD	0
#endif

#if VM_EXEC >= 1<<32
#define VM_FLAG_EXEC		(VM_EXEC >> 32)
#define VM_FLAG_EXECWORD	4
#else
#define VM_FLAG_EXEC		VM_EXEC
#define VM_FLAG_EXECWORD	0
#endif

	ldr	rd, [rn, #VMA_VM_FLAGS + (VM_FLAGS_LOWWORD ^ VM_FLAG_EXECWORD)]
...
	tst	rd, #VM_FLAG_EXEC

which is not only rather horrible, but I also wonder whether VM_EXEC >> 32
will provide the right answer with a binutils targetting 32-bit.
