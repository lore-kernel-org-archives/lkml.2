Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0DWNzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:55:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:58842 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab0DWNzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:55:18 -0400
Subject: Re: [PATCH 6/8] KVM: SVM: Report emulated SVM features to userspace
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1271932394-13968-7-git-send-email-joerg.roedel@amd.com>
Date: Fri, 23 Apr 2010 15:55:15 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <60EF3E44-A41C-418E-9B03-8C245CA50699@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-7-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.04.2010, at 12:33, Joerg Roedel wrote:

> This patch implements the reporting of the emulated SVM
> features to userspace instead of the real hardware
> capabilities. Every real hardware capability needs emulation
> in nested svm so the old behavior was broken.
> 
> Cc: stable@kernel.org

Again, please don't CC stable directly.

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
> arch/x86/kvm/svm.c |   10 ++++++++++
> 1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 0fa2035..65fc114 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3154,6 +3154,16 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> 
> static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> {
> +	switch (func) {
> +	case 0x8000000A:
> +		entry->eax = 1; /* SVM revision 1 */
> +		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
> +				   ASID emulation to nested SVM */

I completely forgot what we do now. What do we do? It shouldn't be too hard to keep a table around and just assign 8 host ASIDs to the guest. If possible lazily, so we can just flush the whole thing when we run out of entries.

It's basically the same as my VSID mapping on ppc64 actually. See arch/powerpc/kvm/book3s_64_mmu_host.c and search for "slb".

> +		entry->ecx = 0; /* Reserved */
> +		entry->edx = 0; /* Do not support any additional features */

What about nnpt? Hasn't that been accepted yet?


Alex

