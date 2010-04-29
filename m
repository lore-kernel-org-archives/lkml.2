Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab0D3S1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933087Ab0D3RWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:22:09 -0400
Message-ID: <4BD9D35C.5090403@redhat.com>
Date: Thu, 29 Apr 2010 21:43:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
References: <4BD8228D.7090708@cn.fujitsu.com> <20100429180955.GA17909@amt.cnet>
In-Reply-To: <20100429180955.GA17909@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2010 09:09 PM, Marcelo Tosatti wrote:
>
> You missed quadrant on 4mb large page emulation with shadow (see updated
> patch below).

Good catch.

> Also for some reason i can't understand the assumption
> does not hold for large sptes with TDP, so reverted for now.
>    

It's unrelated to TDP, same issue with shadow.  I think the calculation 
is correct.  For example the 4th spte for a level=2 page will yield 
gfn=4*512.

> @@ -393,6 +393,27 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
>   	kfree(rd);
>   }
>
> +static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
> +{
> +	gfn_t gfn;
> +
> +	if (!sp->role.direct)
> +		return sp->gfns[index];
> +
> +	gfn = sp->gfn + index * (1<<  (sp->role.level - 1) * PT64_LEVEL_BITS);
> +	gfn += sp->role.quadrant<<  PT64_LEVEL_BITS;
>    

PT64_LEVEL_BITS * level

> +
> +	return gfn;
> +}
> +
>
>    


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

