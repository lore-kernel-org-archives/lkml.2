Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0DWLX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:23:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab0DWLXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:23:54 -0400
Message-ID: <4BD18343.3050407@redhat.com>
Date: Fri, 23 Apr 2010 14:23:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/10] KVM MMU: fix for calculating gpa in invlpg code
References: <4BCFE3D5.5070105@cn.fujitsu.com> <4BCFE8C2.9080102@cn.fujitsu.com>
In-Reply-To: <4BCFE8C2.9080102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 09:12 AM, Xiao Guangrong wrote:
> If the guest is 32-bit, we should use 'quadrant' to adjust gpa
> offset
>
>    

Good catch.  Only affects kvm_mmu_pte_write(), so I don't think this had 
ill effects other than not prefetching the correct address?

> @@ -478,9 +478,14 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>   		    ((level == PT_DIRECTORY_LEVEL&&  is_large_pte(*sptep))) ||
>   		    ((level == PT_PDPE_LEVEL&&  is_large_pte(*sptep)))) {
>   			struct kvm_mmu_page *sp = page_header(__pa(sptep));
> +			int offset = 0;
> +
> +			if (PTTYPE == 32)
> +				offset = sp->role.quadrant<<  PT64_LEVEL_BITS;;
>    

Wrong for PT_DIRECTORY_LEVEL (should be q << 8).  Also, too many 
semicolons.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

