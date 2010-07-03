Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0GCKLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 06:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab0GCKLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 06:11:23 -0400
Message-ID: <4C2F0CC1.6020808@redhat.com>
Date: Sat, 03 Jul 2010 13:11:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH v2] KVM: IOAPIC: only access APIC registers one dword
 at a time
References: <4C2D6D4B.5060309@cn.fujitsu.com> <4C2D95EA.6080209@np.css.fujitsu.com> <4C2D975A.2050704@cn.fujitsu.com> <4C2D9C8C.8060401@cn.fujitsu.com>
In-Reply-To: <4C2D9C8C.8060401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 11:00 AM, Xiao Guangrong wrote:
> The IOAPIC spec says:
>
> When accessing these registers, accesses must be done one dword at a time.
> For example, software should never access byte 2 from the Data register before
> accessing bytes 0 and 1. The hardware will not attempt to recover from a bad
> programming model in this case.
>
> So, this patch removes other width access
>
>    

The ioapic code also implements the ia64 iosapic.  I'm guessing that 
does support 64-bit accesses.  Please check the iosapic documentation.

There might be guests that use incorrect access despite the 
documentation; if real hardware supports it, it should work.  So we need 
to start with just a warning, and allow the access.  Later we can drop 
the invalid access.

> @@ -288,6 +288,11 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>   	ioapic_debug("addr %lx\n", (unsigned long)addr);
>   	ASSERT(!(addr&  0xf));	/* check alignment */
>
> +	if (len != 4) {
> +		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
> +		return 0;
> +	}
> +
>    

Guest triggered, so needs to be rate limited.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

