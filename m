Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409Ab0JGM3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 08:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760386Ab0JGM3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 08:29:45 -0400
Message-ID: <4CADBD13.4040609@redhat.com>
Date: Thu, 07 Oct 2010 14:29:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 03/12] Retry fault before vmentry
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-4-git-send-email-gleb@redhat.com>
In-Reply-To: <1286207794-16120-4-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> When page is swapped in it is mapped into guest memory only after guest
> tries to access it again and generate another fault. To save this fault
> we can map it immediately since we know that guest is going to access
> the page. Do it only when tdp is enabled for now. Shadow paging case is
> more complicated. CR[034] and EFER registers should be switched before
> doing mapping and then switched back.

With non-pv apf, I don't think we can do shadow paging.  The guest isn't 
aware of the apf, so as far as it is concerned it is allowed to kill the 
process and replace it with something else:

   guest process x: apf
   kvm: timer intr
   guest kernel: context switch
   very fast guest admin: pkill -9 x
   guest kernel: destroy x's cr3
   guest kernel: reuse x's cr3 for new process y
   kvm: retry fault, instantiating x's page in y's page table

Even with tdp, we have the same case for nnpt (just s/kernel/hypervisor/ 
and s/process/guest/).  What we really need is to only instantiate the 
page for direct maps, which are independent of the guest.

Could be done like this:

- at apf time, walk shadow mmu
- if !sp->role.direct, abort
- take reference to sp
- on apf completion, instantiate spte in sp

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

