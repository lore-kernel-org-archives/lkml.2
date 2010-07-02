Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0GBRp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:45:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0GBRpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:45:20 -0400
Date: Fri, 2 Jul 2010 14:42:43 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH v2] KVM: IOAPIC: only access APIC registers one dword at
 a time
Message-ID: <20100702174243.GB27069@amt.cnet>
References: <4C2D6D4B.5060309@cn.fujitsu.com>
 <4C2D95EA.6080209@np.css.fujitsu.com>
 <4C2D975A.2050704@cn.fujitsu.com>
 <4C2D9C8C.8060401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2D9C8C.8060401@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 04:00:12PM +0800, Xiao Guangrong wrote:
> The IOAPIC spec says:
> 
> When accessing these registers, accesses must be done one dword at a time.
> For example, software should never access byte 2 from the Data register before
> accessing bytes 0 and 1. The hardware will not attempt to recover from a bad
> programming model in this case.
> 
> So, this patch removes other width access
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  virt/kvm/ioapic.c |   20 +++++++-------------
>  1 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 1149c60..6610d11 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -288,6 +288,11 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>  	ioapic_debug("addr %lx\n", (unsigned long)addr);
>  	ASSERT(!(addr & 0xf));	/* check alignment */
>  
> +	if (len != 4) {
> +		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
> +		return 0;
> +	}
> +

Just remove the printks please, as guests can flood hosts dmesg.

