Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab2A3SYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:24:42 -0500
Received: from goliath.siemens.de ([192.35.17.28]:28579 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2A3SYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:24:41 -0500
Message-ID: <4F26E063.5020207@siemens.com>
Date: Mon, 30 Jan 2012 19:24:35 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: Fix assigned device MSI-X entry setting leak
References: <20120130180540.17524.62489.stgit@bling.home>
In-Reply-To: <20120130180540.17524.62489.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-30 19:06, Alex Williamson wrote:
> We need to prioritize our matching when setting MSI-X vector
> entries.  Unused entries should only be used if we don't find
> an exact match or else we risk duplicating entries.  This was
> causing an ENOSPC return when trying to mask and unmask MSI-X
> vectors based on guest MSI-X table updates.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> ---
> 
> The faulting sequence went something like:
> 
> Start:
> [0] entry 0, vector A
> [1] entry 1, vector B
> [2] entry 2, vector C
> 
> Set entry 1 to 0:
> [0] entry 0, vector A
> [1] entry 1->1, vector B->0
> [2] entry 2, vector C
> 
> Set entry 2 to 0:
> [0] entry 0, vector A
> [1] entry 1->2, vector 0->0 <- incorrectly matched
> [2] entry 2, vector C
> 
> Set entry 2 to C:
> [0] entry 0, vector A
> [1] entry 2->2, vector 0->C <- incorrectly matched again
> [2] entry 2, vector C
> 
> Set entry 1 to B:
> [0] entry 0, vector A
> [1] entry 2, vector C
> [2] entry 2, vector C
> -ENOSPC
> 
> Userspace will need to test for this bug (or do we want to set
> a feature flag?).

The latter is much simpler. We did it before.

> 
>  virt/kvm/assigned-dev.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index 758e3b3..798a090 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -728,7 +728,7 @@ msix_nr_out:
>  static int kvm_vm_ioctl_set_msix_entry(struct kvm *kvm,
>  				       struct kvm_assigned_msix_entry *entry)
>  {
> -	int r = 0, i;
> +	int r = 0, i, unused = -1;
>  	struct kvm_assigned_dev_kernel *adev;
>  
>  	mutex_lock(&kvm->lock);
> @@ -741,17 +741,26 @@ static int kvm_vm_ioctl_set_msix_entry(struct kvm *kvm,
>  		goto msix_entry_out;
>  	}
>  
> -	for (i = 0; i < adev->entries_nr; i++)
> -		if (adev->guest_msix_entries[i].vector == 0 ||
> -		    adev->guest_msix_entries[i].entry == entry->entry) {
> +	for (i = 0; i < adev->entries_nr; i++) {
> +		if (unused < 0 && !adev->guest_msix_entries[i].vector)
> +			unused = i;
> +
> +		if (adev->guest_msix_entries[i].entry == entry->entry) {
>  			adev->guest_msix_entries[i].entry = entry->entry;
>  			adev->guest_msix_entries[i].vector = entry->gsi;
>  			adev->host_msix_entries[i].entry = entry->entry;
>  			break;
>  		}
> +	}
> +
>  	if (i == adev->entries_nr) {
> -		r = -ENOSPC;
> -		goto msix_entry_out;
> +		if (unused < 0) {
> +			r = -ENOSPC;
> +			goto msix_entry_out;
> +		}
> +		adev->guest_msix_entries[unused].entry = entry->entry;
> +		adev->guest_msix_entries[unused].vector = entry->gsi;
> +		adev->host_msix_entries[unused].entry = entry->entry;
>  	}
>  
>  msix_entry_out:
> 

Looks good. Does it fix the masking problems?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
