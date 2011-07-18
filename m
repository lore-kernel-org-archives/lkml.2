Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1GRHhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:37:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:39718 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab1GRHhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 03:37:05 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E23E02C.8090401@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop>  <4E23D728.7090406@gmail.com>
	 <1310972462.25044.292.camel@pasglop>  <4E23E02C.8090401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 17:36:31 +1000
Message-ID: <1310974591.25044.298.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 15:26 +0800, Shan Hai wrote:
> 
> I am sorry I hadn't tried your newer patch, I tried it but it still 
> could not work in my test environment, I will dig into and tell you
> why that failed later.

Ok, please let me know what you find !

> Yep, I know holding lots of ifdef's everywhere is not so good,
> but if we have some other way(I don't know how till now) to
> figure out the arch has the need to fixup up the write permission
> we could eradicate the ugly ifdef's here.
> 
> I think the handle_mm_fault could do all dirty/young tracking,
> because the purpose of making follow_page return NULL to
> its caller is that want to the handle_mm_fault to be called
> on write permission protection fault.

I see your point. Rather than factoring the fixup code out, we could
force gup to call handle_mm_fault()... that makes sense.

However, I don't think we should special case archs. There's plenty of
cases where we don't care about this fixup even on archs that do SW
tracking of dirty and young. For example when gup is using for
subsequent DMA.

Only the (rare ?) cases where it's used as a mean to fixup a failing
"atomic" user access are relevant.

So I believe we should still pass an explicit flag to __get_user_pages()
as I propose to activate that behaviour.

At this point, since we have isolated the special case callers, I think
we are pretty much in a situation where there's no point trying to
optimize the x86 case more, it's a fairly slow path anyway, and so no
ifdef should be needed (and x86 already #define out the TLB flush for
spurious faults in handle_pte_fault today).

We don't even need to change follow_page()... we just don't call it the
first time around.

I'll cook up another patch later but first we need to find out why the
one you have doesn't work. There might be another problem lurking (or I
just made a stupid mistake).

BTW. Can you give me some details about how you reproduce the problem ?
I should setup something on a booke machine here to verify things.

Cheers,
Ben.

