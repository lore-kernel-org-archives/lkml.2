Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0GIPvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:51:45 -0400
Received: from claw.goop.org ([74.207.240.146]:33599 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab0GIPvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:51:42 -0400
Message-ID: <4C37458B.8040408@goop.org>
Date: Fri, 09 Jul 2010 08:51:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmu notifier calls in apply_to_page_range()
References: <4C373AEC.6000502@goop.org> <20100709151211.GE13493@random.random>
In-Reply-To: <20100709151211.GE13493@random.random>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 08:12 AM, Andrea Arcangeli wrote:
> On Fri, Jul 09, 2010 at 08:06:20AM -0700, Jeremy Fitzhardinge wrote:
>   
>> I just noticed that the original mmu notifier change (cddb8a5c14a) adds
>> calls to mmu_notifier_invalidate_range_start/end to
>> apply_to_page_range().  This doesn't seem correct to me, since
>> apply_to_page_range can perform arbitrary operations to the range of
>> pages, not just invalidation of the pages.  It seems to me that the
>> appropriate mmu notifiers should be called either around the call to
>> apply_to_page_range(), or from within the callback function.
>>
>> Andrea, what's the rationale for mmu_notifier_invalidate_range_start/end
>> here?
>>     
> As long as the secondary mappings are teardown in range_start and
> allowed to be established again only after range_end, all
> modifications will be picked up by the secondary mmu. Imagine
> secondary mmu like a tlb, that you only invalidate, then it'll be
> refilled later (after range_end).
>   

Yes, but apply_to_page_range isn't necessarily making changes which
requires that teardown/refill.  The most common user is vmalloc, which
is just using a side-effect of apply_to_page_range to make sure that all
the intermediate levels of the pagetable are allocated over the
vmalloced range.  I think all the other users of it are within Xen code.
In particular, we're using it in the gntdev driver, which also uses mmu
notifiers to keep grant mappings in sync with process mappings, so the
recursive mmu notifier call is causing problems.

It seems to me that apply_to_page_range should be agnostic to its use,
and its up to its callers to do any appropriate mmu notifier work. 
Would you be happy with a patch to remove those calls?

Thanks,
    J
