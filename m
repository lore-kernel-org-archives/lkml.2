Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0DYJqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab0DYJqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:46:35 -0400
Message-ID: <4BD40F6D.3090002@redhat.com>
Date: Sun, 25 Apr 2010 12:46:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/10] KVM MMU: fix for calculating gpa in invlpg code
References: <4BD3E306.4020202@cn.fujitsu.com> <4BD3E870.60000@cn.fujitsu.com>
In-Reply-To: <4BD3E870.60000@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 10:00 AM, Xiao Guangrong wrote:
> If the guest is 32-bit, we should use 'quadrant' to adjust gpa
> offset
>
> Changlog v2:
> - when level is PT_DIRECTORY_LEVEL, the 'offset' should be
>    'role.quadrant<<  8', thanks Avi for point it out
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/paging_tmpl.h |   13 +++++++++++--
>   1 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index d0cc07e..83cc72f 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -478,9 +478,18 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>   		    ((level == PT_DIRECTORY_LEVEL&&  is_large_pte(*sptep))) ||
>   		    ((level == PT_PDPE_LEVEL&&  is_large_pte(*sptep)))) {
>   			struct kvm_mmu_page *sp = page_header(__pa(sptep));
> -
> +			int offset = 0;
> +
> +			if (PTTYPE == 32) {
> +				if (level == PT_DIRECTORY_LEVEL)
> +					offset = PAGE_SHIFT - 4;
> +				else
> +					offset = PT64_LEVEL_BITS;
> +				offset = sp->role.quadrant<<  offset;
> +			}
>    

The calculation is really

   shift = (PT32_LEVEL_BITS - PT64_LEVEL_BITS) * level;

(and please don't use a variable called offset to hold a shift count)


-- 
error compiling committee.c: too many arguments to function

