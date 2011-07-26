Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1GZM1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:27:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1GZM1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:27:15 -0400
Date: Tue, 26 Jul 2011 15:27:10 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: fast emulate repeat string write
 instructions
Message-ID: <20110726122710.GM4404@redhat.com>
References: <4E2EA3DB.7040403@cn.fujitsu.com>
 <4E2EA476.9070607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2EA476.9070607@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 07:26:46PM +0800, Xiao Guangrong wrote:
> We usually use repeat string instructions to clear the page, for example,
By "we" do you mean Linux guest?

> we call memset to clear a page table, stosb is used in this function, and 
> repeated for 1024 times, that means we should occupy mmu lock for 1024 times
> and walking shadow page cache for 1024 times, it is terrible
> 
> In fact, if it is the repeat string instructions emulated and it is not a
> IO/MMIO access, we can zap all the corresponding shadow pages and return to the
> guest, then the mapping can became writable and directly write the page
> 
So this patch does two independent things as far as I can see. First it
stops reentering guest if rep instruction is done on memory and second
it drops shadow pages if access to shadowed page table is rep. Why not
separate those in different patches?  BTW not entering guest periodically
increases interrupt latencies. Why not zap shadow, make page writable
and reenter the guest instead of emulation, it should be much faster (do we
care to optimize for old cpus by complicating the code anyway?).

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_emulate.h |    1 +
>  arch/x86/include/asm/kvm_host.h    |    2 +-
>  arch/x86/kvm/emulate.c             |    5 +++--
>  arch/x86/kvm/mmu.c                 |    4 ++--
>  arch/x86/kvm/paging_tmpl.h         |    3 ++-
>  arch/x86/kvm/x86.c                 |    9 +++++++--
>  6 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> index 6040d11..7e5c4d5 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -244,6 +244,7 @@ struct x86_emulate_ctxt {
>  	bool guest_mode; /* guest running a nested guest */
>  	bool perm_ok; /* do not check permissions if true */
>  	bool only_vendor_specific_insn;
> +	bool pio_mmio_emulate; /* it is the pio/mmio access if true */
>  
>  	bool have_exception;
>  	struct x86_exception exception;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c00ec28..95f55a9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -752,7 +752,7 @@ int fx_init(struct kvm_vcpu *vcpu);
>  void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
>  void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  		       const u8 *new, int bytes,
> -		       bool guest_initiated);
> +		       bool guest_initiated, bool repeat_write);
>  int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
>  void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
>  int kvm_mmu_load(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 6f08bc9..36fbac6 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4009,8 +4009,9 @@ writeback:
>  			 * Re-enter guest when pio read ahead buffer is empty
>  			 * or, if it is not used, after each 1024 iteration.
>  			 */
> -			if ((r->end != 0 || ctxt->regs[VCPU_REGS_RCX] & 0x3ff) &&
> -			    (r->end == 0 || r->end != r->pos)) {
> +			if ((r->end != 0 || ctxt->regs[VCPU_REGS_RCX] & 0x3ff)
> +			      && (r->end == 0 || r->end != r->pos) &&
> +			      ctxt->pio_mmio_emulate) {
>  				/*
>  				 * Reset read cache. Usually happens before
>  				 * decode, but since instruction is restarted
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 587695b..5193de8 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3541,7 +3541,7 @@ static int get_free_pte_list_desc_nr(struct kvm_vcpu *vcpu)
>  
>  void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  		       const u8 *new, int bytes,
> -		       bool guest_initiated)
> +		       bool guest_initiated, bool repeat_write)
>  {
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	union kvm_mmu_page_role mask = { .word = 0 };
> @@ -3622,7 +3622,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  		pte_size = sp->role.cr4_pae ? 8 : 4;
>  		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
>  		misaligned |= bytes < 4;
> -		if (misaligned || flooded) {
> +		if (misaligned || flooded || repeat_write) {
>  			/*
>  			 * Misaligned accesses are too much trouble to fix
>  			 * up; also, they usually indicate a page is not used
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 507e2b8..02daac5 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -710,7 +710,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>  
>  	if (mmu_topup_memory_caches(vcpu))
>  		return;
> -	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
> +	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t),
> +			  false, false);
>  }
>  
>  static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5543f99..6fb9001 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4058,7 +4058,8 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
>  	if (ret < 0)
>  		return 0;
> -	kvm_mmu_pte_write(vcpu, gpa, val, bytes, 1);
> +	kvm_mmu_pte_write(vcpu, gpa, val, bytes, true,
> +			  vcpu->arch.emulate_ctxt.rep_prefix);
>  	return 1;
>  }
>  
> @@ -4161,6 +4162,8 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
>  		return X86EMUL_CONTINUE;
>  
>  mmio:
> +	vcpu->arch.emulate_ctxt.pio_mmio_emulate = true;
> +
>  	/*
>  	 * Is this MMIO handled locally?
>  	 */
> @@ -4295,7 +4298,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
>  	if (!exchanged)
>  		return X86EMUL_CMPXCHG_FAILED;
>  
> -	kvm_mmu_pte_write(vcpu, gpa, new, bytes, 1);
> +	kvm_mmu_pte_write(vcpu, gpa, new, bytes, true, false);
>  
>  	return X86EMUL_CONTINUE;
>  
> @@ -4326,6 +4329,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
>  {
>  	trace_kvm_pio(!in, port, size, count);
>  
> +	vcpu->arch.emulate_ctxt.pio_mmio_emulate = true;
>  	vcpu->arch.pio.port = port;
>  	vcpu->arch.pio.in = in;
>  	vcpu->arch.pio.count  = count;
> @@ -4817,6 +4821,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  		ctxt->interruptibility = 0;
>  		ctxt->have_exception = false;
>  		ctxt->perm_ok = false;
> +		ctxt->pio_mmio_emulate = false;
>  
>  		ctxt->only_vendor_specific_insn
>  			= emulation_type & EMULTYPE_TRAP_UD;
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
