Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2JVJQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2JVJQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:16:20 -0400
Date: Mon, 22 Oct 2012 11:16:15 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
Message-ID: <20121022091615.GG29310@redhat.com>
References: <5081033C.4060503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5081033C.4060503@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 03:37:32PM +0800, Xiao Guangrong wrote:
> After commit b3356bf0dbb349 (KVM: emulator: optimize "rep ins" handling),
> the pieces of io data can be collected and write them to the guest memory
> or MMIO together.
> 
> Unfortunately, kvm splits the mmio access into 8 bytes and store them to
> vcpu->mmio_fragments. If the guest uses "rep ins" to move large data, it
> will cause vcpu->mmio_fragments overflow
> 
> The bug can be exposed by isapc (-M isapc):
> 
> [23154.818733] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ ......]
> [23154.858083] Call Trace:
> [23154.859874]  [<ffffffffa04f0e17>] kvm_get_cr8+0x1d/0x28 [kvm]
> [23154.861677]  [<ffffffffa04fa6d4>] kvm_arch_vcpu_ioctl_run+0xcda/0xe45 [kvm]
> [23154.863604]  [<ffffffffa04f5a1a>] ? kvm_arch_vcpu_load+0x17b/0x180 [kvm]
> 
> 
> Actually, we can use one mmio_fragment to store a large mmio access for the
> mmio access is always continuous then split it when we pass the mmio-exit-info
> to userspace. After that, we only need two entries to store mmio info for
> the cross-mmio pages access
> 
I wonder can we put the data into coalesced mmio buffer instead of
exiting for each 8 bytes? Is it worth the complexity?

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c       |  127 +++++++++++++++++++++++++++++-----------------
>  include/linux/kvm_host.h |   16 +-----
>  2 files changed, 84 insertions(+), 59 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8b90dd5..41ceb51 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3779,9 +3779,6 @@ static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
>  static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
>  			   void *val, int bytes)
>  {
> -	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
> -
> -	memcpy(vcpu->run->mmio.data, frag->data, frag->len);
>  	return X86EMUL_CONTINUE;
>  }
> 
> @@ -3799,6 +3796,64 @@ static const struct read_write_emulator_ops write_emultor = {
>  	.write = true,
>  };
> 
> +static bool get_current_mmio_info(struct kvm_vcpu *vcpu, gpa_t *gpa,
> +				  unsigned *len, void **data)
> +{
> +	struct kvm_mmio_fragment *frag;
> +	int cur = vcpu->mmio_cur_fragment;
> +
> +	if (cur >= vcpu->mmio_nr_fragments)
> +		return false;
> +
> +	frag = &vcpu->mmio_fragments[cur];
> +	if (frag->pos >= frag->len) {
> +		if (++vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments)
> +			return false;
> +		frag++;
> +	}
> +
> +	*gpa = frag->gpa + frag->pos;
> +	*data = frag->data + frag->pos;
> +	*len = min(8u, frag->len - frag->pos);
> +	return true;
> +}
> +
> +static void complete_current_mmio(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmio_fragment *frag;
> +	gpa_t gpa;
> +	unsigned len;
> +	void *data;
> +
> +	get_current_mmio_info(vcpu, &gpa, &len, &data);
> +
> +	if (!vcpu->mmio_is_write)
> +		memcpy(data, vcpu->run->mmio.data, len);
> +
> +	/* Increase frag->pos to switch to the next mmio. */
> +	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
> +	frag->pos += len;
> +}
> +
> +static bool vcpu_fill_mmio_exit_info(struct kvm_vcpu *vcpu)
> +{
> +	gpa_t gpa;
> +	unsigned len;
> +	void *data;
> +
> +	if (!get_current_mmio_info(vcpu, &gpa, &len, &data))
> +		return false;
> +
> +	vcpu->run->mmio.len = len;
> +	vcpu->run->mmio.is_write = vcpu->mmio_is_write;
> +	vcpu->run->exit_reason = KVM_EXIT_MMIO;
> +	vcpu->run->mmio.phys_addr = gpa;
> +
> +	if (vcpu->mmio_is_write)
> +		memcpy(vcpu->run->mmio.data, data, len);
> +	return true;
> +}
> +
>  static int emulator_read_write_onepage(unsigned long addr, void *val,
>  				       unsigned int bytes,
>  				       struct x86_exception *exception,
> @@ -3834,18 +3889,12 @@ mmio:
>  	bytes -= handled;
>  	val += handled;
> 
> -	while (bytes) {
> -		unsigned now = min(bytes, 8U);
> -
> -		frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
> -		frag->gpa = gpa;
> -		frag->data = val;
> -		frag->len = now;
> -
> -		gpa += now;
> -		val += now;
> -		bytes -= now;
> -	}
> +	WARN_ON(vcpu->mmio_nr_fragments >= KVM_MAX_MMIO_FRAGMENTS);
> +	frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
> +	frag->pos = 0;
> +	frag->gpa = gpa;
> +	frag->data = val;
> +	frag->len = bytes;
>  	return X86EMUL_CONTINUE;
>  }
> 
> @@ -3855,7 +3904,6 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
>  			const struct read_write_emulator_ops *ops)
>  {
>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> -	gpa_t gpa;
>  	int rc;
> 
>  	if (ops->read_write_prepare &&
> @@ -3887,17 +3935,13 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
>  	if (!vcpu->mmio_nr_fragments)
>  		return rc;
> 
> -	gpa = vcpu->mmio_fragments[0].gpa;
> -
>  	vcpu->mmio_needed = 1;
>  	vcpu->mmio_cur_fragment = 0;
> +	vcpu->mmio_is_write = ops->write;
> 
> -	vcpu->run->mmio.len = vcpu->mmio_fragments[0].len;
> -	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
> -	vcpu->run->exit_reason = KVM_EXIT_MMIO;
> -	vcpu->run->mmio.phys_addr = gpa;
> -
> -	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
> +	vcpu_fill_mmio_exit_info(vcpu);
> +	return ops->read_write_exit_mmio(vcpu, vcpu->mmio_fragments[0].gpa,
> +					 val, bytes);
>  }
> 
>  static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
> @@ -5524,43 +5568,34 @@ static int complete_emulated_pio(struct kvm_vcpu *vcpu)
>   *
>   * read:
>   *   for each fragment
> - *     write gpa, len
> - *     exit
> - *     copy data
> + *      for each mmio piece in the fragment
> + *        write gpa, len
> + *        exit
> + *        copy data
>   *   execute insn
>   *
>   * write:
>   *   for each fragment
> - *      write gpa, len
> - *      copy data
> - *      exit
> + *      for each mmio piece in the fragment
> + *         write gpa, len
> + *         copy data
> + *   exit
>   */
>  static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
> -	struct kvm_mmio_fragment *frag;
> -
>  	BUG_ON(!vcpu->mmio_needed);
> 
> -	/* Complete previous fragment */
> -	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
> -	if (!vcpu->mmio_is_write)
> -		memcpy(frag->data, run->mmio.data, frag->len);
> -	if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
> +	complete_current_mmio(vcpu);
> +
> +	/* Initiate next fragment */
> +	if (!vcpu_fill_mmio_exit_info(vcpu)) {
>  		vcpu->mmio_needed = 0;
>  		if (vcpu->mmio_is_write)
>  			return 1;
>  		vcpu->mmio_read_completed = 1;
>  		return complete_emulated_io(vcpu);
>  	}
> -	/* Initiate next fragment */
> -	++frag;
> -	run->exit_reason = KVM_EXIT_MMIO;
> -	run->mmio.phys_addr = frag->gpa;
> -	if (vcpu->mmio_is_write)
> -		memcpy(run->mmio.data, frag->data, frag->len);
> -	run->mmio.len = frag->len;
> -	run->mmio.is_write = vcpu->mmio_is_write;
> +
>  	vcpu->arch.complete_userspace_io = complete_emulated_mmio;
>  	return 0;
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e235068..f6c3c2f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -42,19 +42,8 @@
>   */
>  #define KVM_MEMSLOT_INVALID	(1UL << 16)
> 
> -/*
> - * If we support unaligned MMIO, at most one fragment will be split into two:
> - */
> -#ifdef KVM_UNALIGNED_MMIO
> -#  define KVM_EXTRA_MMIO_FRAGMENTS 1
> -#else
> -#  define KVM_EXTRA_MMIO_FRAGMENTS 0
> -#endif
> -
> -#define KVM_USER_MMIO_SIZE 8
> -
> -#define KVM_MAX_MMIO_FRAGMENTS \
> -	(KVM_MMIO_SIZE / KVM_USER_MMIO_SIZE + KVM_EXTRA_MMIO_FRAGMENTS)
> +/* Two fragments for cross MMIO pages. */
> +#define KVM_MAX_MMIO_FRAGMENTS	2
> 
>  /*
>   * For the normal pfn, the highest 12 bits should be zero,
> @@ -203,6 +192,7 @@ struct kvm_mmio_fragment {
>  	gpa_t gpa;
>  	void *data;
>  	unsigned len;
> +	unsigned pos;
>  };
> 
>  struct kvm_vcpu {
> -- 
> 1.7.7.6

--
			Gleb.
