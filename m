Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2FTJDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:03:05 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:48131 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2FTJDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:03:03 -0400
Date: Wed, 20 Jun 2012 18:02:54 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
Message-Id: <20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4FE1825B.1030402@linux.vnet.ibm.com>
References: <4FE1822D.8010002@linux.vnet.ibm.com>
	<4FE1825B.1030402@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 15:57:15 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Introduce a common function to abstract spte write-protect to
> cleanup the code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

...

> +/* Return true if the spte is dropped. */
> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
> +{
> +	u64 spte = *sptep;
> +
> +	if (!is_writable_pte(spte))
> +		return false;
> +
> +	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

...

> @@ -3902,16 +3915,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
>  			      !is_last_spte(pt[i], sp->role.level))
>  				continue;
> 
> -			if (is_large_pte(pt[i])) {
> -				drop_spte(kvm, &pt[i]);
> -				--kvm->stat.lpages;
> -				continue;
> -			}
> -
> -			/* avoid RMW */
> -			if (is_writable_pte(pt[i]))
> -				mmu_spte_update(&pt[i],
> -						pt[i] & ~PT_WRITABLE_MASK);
> +			spte_write_protect(kvm, &pt[i], &flush);

Adding rmap_printk() here seems wrong.

If you think it is not a problem, please explain why you think so in
the changelog.

Thanks,
	Takuya
