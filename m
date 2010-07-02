Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0GBHbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:31:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42460 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0GBHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:31:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4C2D95EA.6080209@np.css.fujitsu.com>
Date: Fri, 02 Jul 2010 16:31:54 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: IOAPIC: only access APIC registers one dword at
 a time
References: <4C2D6D4B.5060309@cn.fujitsu.com>
In-Reply-To: <4C2D6D4B.5060309@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Xiao Guangrong

Xiao Guangrong wrote:
> The IOAPIC spec says:
> 
> When accessing these registers, accesses must be done one dword at a time.
> For example, software should never access byte 2 from the Data register before
> accessing bytes 0 and 1. The hardware will not attempt to recover from a bad
> programming model in this case.

I could understand what you described on the above, but I don't think it is 
the best method to fix it. Could you consider a nice one?

>
> So, this patch removes other width access
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  virt/kvm/ioapic.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 1149c60..f96816f 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -306,14 +306,10 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>  	spin_unlock(&ioapic->lock);
>  
>  	switch (len) {
> -	case 8:
> -		*(u64 *) val = result;
> -		break;
> -	case 1:
> -	case 2:
>  	case 4:
> -		memcpy(val, (char *)&result, len);

Here the parameter len is not used for reading data from ioapic register, before switch case
the value of ioapic register has been read by ioapic_read_indirect().


> +		*(u32 *) val = result;
>  		break;
> +
>  	default:
>  		printk(KERN_WARNING "ioapic: wrong length %d\n", len);

And I think here is not good to print warning message. Maybe it is better to do
such kind of checking at the first of this function before ioapic_read_indirect().

>  	}
> @@ -332,7 +328,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
>  		     (void*)addr, len, val);
>  	ASSERT(!(addr & 0xf));	/* check alignment */
>  
> -	if (len == 4 || len == 8)
> +	if (len == 4)
>  		data = *(u32 *) val;
>  	else {
>  		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);

So I hope you could read the source code again. I think you can use a better method to fix it.

Best Regards,
Jin Dongming

