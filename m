Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2DAPxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 11:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab2DAPxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 11:53:15 -0400
Message-ID: <4F7879E6.8020103@redhat.com>
Date: Sun, 01 Apr 2012 18:53:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/13] KVM: MMU: get expected spte out of mmu-lock
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A97.6030308@linux.vnet.ibm.com>
In-Reply-To: <4F742A97.6030308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:25 AM, Xiao Guangrong wrote:
> It depends on PTE_LIST_WRITE_PROTECT bit in rmap which let us quickly know
> whether the page is writable out of mmu-lock
>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |   17 +++++++++++++----
>  arch/x86/kvm/paging_tmpl.h |    2 +-
>  2 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 3887a07..c029185 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1148,6 +1148,12 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
>
>  	*rmapp |= PTE_LIST_WRITE_PROTECT;
>
> +	/*
> +	 * Setting PTE_LIST_WRITE_PROTECT bit before doing page
> +	 * write-protect.
> +	 */
> +	smp_mb();
> +

wmb only needed.

Would it be better to store this bit in all the sptes instead?  We're
touching them in any case.  More work to clear them, but
un-write-protecting a page is beneficial anyway as it can save a fault.


-- 
error compiling committee.c: too many arguments to function

