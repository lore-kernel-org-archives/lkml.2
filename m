Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab0E0KKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0E0KKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:10:33 -0400
Message-ID: <4BFE4513.8090606@redhat.com>
Date: Thu, 27 May 2010 13:10:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: fix relaxing permission
References: <4BFC8B0D.2060106@cn.fujitsu.com> <4BFC8B8C.7010402@cn.fujitsu.com>
In-Reply-To: <4BFC8B8C.7010402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 05:46 AM, Xiao Guangrong wrote:
> There is a relaxing permission operation in set_spte():
>
> if guest's CR0.WP is not set and R/W #PF occurs in supervisor-level,
> the mapping path might set to writable, then user can allow to write.
>
> @@ -1859,8 +1859,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>
>   	spte |= (u64)pfn<<  PAGE_SHIFT;
>
> -	if ((pte_access&  ACC_WRITE_MASK)
> -	    || (write_fault&&  !is_write_protection(vcpu)&&  !user_fault)) {
> +	if (pte_access&  ACC_WRITE_MASK) {
>
>    

The host always sets cr0.wp (in shadow mode) so we can write protect 
page tables.  So when the guest clears cr0.wp, we emulate a gpte with 
gpte.w=0 and gpte.u=1 in two ways:

- spte.w=1, spte.u=0: this will allow the guest kernel to write but trap 
on guest user access
- spte.w=0, spte.u=1: allows guest user access but traps on guest kernel 
writes

If the guest attempts an access that is currently disallowed, we switch 
to the other spte encoding.

-- 
error compiling committee.c: too many arguments to function

