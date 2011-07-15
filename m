Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117Ab1GOJHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 05:07:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:58016 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982Ab1GOJHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:07:45 -0400
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: MailingLists <haishan.bai@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E1FFC7B.4000209@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310718056.2586.275.camel@twins>  <4E1FFC7B.4000209@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 19:07:15 +1000
Message-ID: <1310720835.4968.311.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 16:38 +0800, MailingLists wrote:
> A page could be set to read only by the kernel (supervisor in the
> powerpc
> literature) on the e500, and that's what the kernel do. Set
> SW(supervisor
> write) bit in the TLB entry to grant write permission to the kernel on
> a
> page.
> 
> And further the SW bit is set according to the DIRTY flag of the PTE,
> PTE.DIRTY is set in the do_page_fault(), the futex_lock_pi() disabled
> page fault, the PTE.DIRTY never can be set, so do the SW bit,
> unbreakable
> COW occurred, infinite loop followed. 

That would be it ... the SW dirty and young tracking relies on faults to
fixup things in handle_pte_fault(). If the "disable page fault" thingy
happens before we get there, then we have a pretty nasty bug. Note that
this will hit more than just e500 (and in fact any architecture that
relies on SW to do dirty and young tracking).

Cheers,
Ben.

