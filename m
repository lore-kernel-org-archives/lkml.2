Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1GPAVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 20:21:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:36361 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1GPAVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 20:21:39 -0400
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org
In-Reply-To: <4E205D96.7010109@gmail.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
	 <4E205D96.7010109@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jul 2011 10:20:49 +1000
Message-ID: <1310775649.25044.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 11:32 -0400, Shan Hai wrote:
> 
> I agree with you, the problem could be triggered by accessing
> any user space page which has kernel read only permission
> in the page fault disabled context, the problem also affects
> architectures which depend on SW dirty/young tracking as
> stated by Benjamin in this thread.
> 
> In the e500 case, the commit 6cfd8990e27d3a491c1c605d6cbc18a46ae51fef
> removed the write permission fixup from TLB miss handlers and left it to
> generic code, so it might be right time to fixup the write permission here
> in the generic code.

But we can't. The must not modify the PTE from an interrupt context and
the "atomic" variants of user accesses can be called in such contexts.

I think the problem is that we try to actually do things other than just
"peek" at user memory (for backtraces etc...) but actually useful things
in page fault disabled contexts. That's bad and various archs mm were
designed with the assumption that this never happens.

If the futex case is seldom here, we could probably find a way to work
around in that specific case.

However, I -still- don't understand why gup didn't fixup the write
permission. gup doesn't set dirty ?

Cheers,
Ben.


