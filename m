Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3AGTag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:30:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36331 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3AGTaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:30:35 -0500
Date: Mon, 7 Jan 2013 14:29:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130107192954.GA8829@phenom.dumpdata.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-27-git-send-email-yinghai@kernel.org>
 <CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
 <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
 <CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
 <CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
 <20130107152622.GD3219@phenom.dumpdata.com>
 <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, since IOMMU drivers can no longer assume swiotlb is allocated
> enough_mem_for_swiotlb() check fails, AMD IOMMU or another other iommu
> driver can't simply rely on changing swiotlb=1 and assuming the buffer
> is there.
> 
> As Konrad suggested,  a hook is needed, however, I think the logic to
> ensure switolb buffer belongs in swiotlb modules. How about changing
> pci_swiolb_late_init() logic to ensure swioltb late init is done
> instead of leaving it up to AMD IOMMU driver or some other driver.

Perhaps by having the 'swiotlb' be more than just on/off? It could
carry different flags, such as:

	EARLY_BOOTMEM_ON
		(if pci_swiotlb_detect_4gb or pci_swiotlb_detect_override sets it)
	EARLY_BOOTMEM_OFF
		this would replace 'swiotlb=0'
	FORCE
		replaces 'swiotlb_force'
	LATE_INIT_ON
		this new option where pci_swiotlb_late_init()
		would call the late init.

That would require some tweaking also in the IA64 code, but seems
like a step in the right direction. And we can get rid of that
'swiotlb_force' parameter.

Actually, that would also allow us to get rid of the pci_swiotlb_detect_override
and the setup_io_tlb_npages function could now just set swiotlb |= SWIOTLB_FORCE;

