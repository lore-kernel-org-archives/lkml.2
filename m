Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0D0M6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:58:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab0D0M6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:58:39 -0400
Message-ID: <4BD6DF7C.1090203@redhat.com>
Date: Tue, 27 Apr 2010 15:58:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> This patch introduces two fields in vcpu_arch for x86:
>
> 	* fault_address
> 	* fault_error_code
>
> This will be used to correctly propagate page faults back
> into the guest when we could have either an ordinary page
> fault or a nested page fault. In the case of a nested page
> fault the fault-address is different from the original
> address that should be walked. So we need to keep track
> about the real fault-address.
> We could also remove the current path of the error_code to
> the fault. But this change is too invasive and outside the
> scope of this patch set. It will be changed and tested
> seperatly.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    3 +++
>   arch/x86/kvm/paging_tmpl.h      |    4 ++++
>   2 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d9dfc8c..8426870 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -298,6 +298,9 @@ struct kvm_vcpu_arch {
>   	/* Used for two dimensional paging emulation */
>   	struct kvm_mmu nested_mmu;
>
> +	unsigned long fault_address;
>    

Probably a problem on i386.  How does npt handle faults when the guest 
is using pae paging and the host (in our case the guest...) isn't?  I 
see it uses exit_info_2 for the address, which is a u64.

So we probably need to upgrade gva_t to a u64.  Please send this as a 
separate patch, and test on i386 hosts.

> +	int fault_error_code;
>    

unsigned.

Maybe put the two in a struct, easier to pass around.


-- 
error compiling committee.c: too many arguments to function

