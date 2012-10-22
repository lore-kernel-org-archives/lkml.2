Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2JVN60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:58:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab2JVN6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:58:25 -0400
Message-ID: <508550F7.1010605@redhat.com>
Date: Mon, 22 Oct 2012 15:58:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
References: <5081033C.4060503@linux.vnet.ibm.com>
In-Reply-To: <5081033C.4060503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 09:37 AM, Xiao Guangrong wrote:
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
> to userspace.

Note, there are instructions that can access discontinuous areas.  We don't emulate them and they're unlikely to be used for mmio.

> After that, we only need two entries to store mmio info for
> the cross-mmio pages access

Patch is good, but is somewhat large for 3.7.  Maybe we can make it smaller with the following:

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

Instead of having ->pos, just adjust ->gpa, ->data, and ->len in place.  Then get_current_mmio_info would be unneeded, just the min() bit when accessing ->len.

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


And this would be unneeded, just adjust the code that does mmio_cur_fragment++:

 static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	struct kvm_mmio_fragment *frag;
+	struct kvm_mmio_fragment frag;

	BUG_ON(!vcpu->mmio_needed);

	/* Complete previous fragment */
-	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];       
+	frag = vcpu->mmio_fragments[vcpu->mmio_cur_fragment];       
+       if (frag.len <= 8) {
+		++vcpu->mmio_cur_fragment;
+	} else {
+		vcpu->mmio_fragments[vcpu->mmio_cur_fragment].len -= frag.len;
                ...





-- 
error compiling committee.c: too many arguments to function
