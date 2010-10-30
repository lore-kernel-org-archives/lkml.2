Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0J3TRJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:17:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab0J3TRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:17:07 -0400
Subject: Re: [PATCH v2] powerpc: kvm: powerpc: fix information leak to userland
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1288464922-8812-1-git-send-email-segooon@gmail.com>
Date: Sat, 30 Oct 2010 12:16:57 -0700
Cc: kernel-janitors@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1480CDBF-0A4A-49EC-AF4C-CED1D63BB911@suse.de>
References: <1288464922-8812-1-git-send-email-segooon@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30.10.2010, at 11:55, Vasiliy Kulikov wrote:

> Structure kvm_ppc_pvinfo is copied to userland with "flags" and "pad"
> fields unitialized.  It leads to leaking of contents of kernel stack
> memory.  We have to initialize them to zero.
> 
> In patch v1 Jan Kiszka suggested to fill reserved fields with zeros
> instead of memset'ting the whole struct.  It makes sense as these
> fields are explicitly marked as padding.  No more fields need zeroing.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
> arch/powerpc/kvm/powerpc.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 2f87a16..5962336 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -604,6 +604,8 @@ static int kvm_vm_ioctl_get_pvinfo(struct kvm_ppc_pvinfo *pvinfo)
> 	pvinfo->hcall[1] = inst_ori | (KVM_SC_MAGIC_R0 & inst_imm_mask);
> 	pvinfo->hcall[2] = inst_sc;
> 	pvinfo->hcall[3] = inst_nop;
> +	pvinfo->flags = 0;
> +	memset(&pvinfo->pad, 0, sizeof(pvinfo->pad));

This should only be memset(pvinfo->pad), no? It's an array after all which automatically translates to a pointer when referenced.

Alex

