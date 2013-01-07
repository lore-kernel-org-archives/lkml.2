Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3AGP1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:27:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27664 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3AGP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:27:05 -0500
Date: Mon, 7 Jan 2013 10:26:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130107152622.GD3219@phenom.dumpdata.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-27-git-send-email-yinghai@kernel.org>
 <CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
 <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
 <CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
 <CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 02:10:25PM -0800, Yinghai Lu wrote:
> On Fri, Jan 4, 2013 at 1:02 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> > Pani'cing the system doesn't sound like a good option to me in this
> > case. This change to disable swiotlb is made for kdump. However, with
> > this change several system fail to boot, unless crashkernel_low=72M is
> > specified.
> 
> this patchset is new feature to put second kdump kernel above 4G.
> 
> >
> > I would the say the right approach to solve this would be to not
> > change the current pci_swiotlb_detect_override() behavior and treat
> > swiotlb =1 upon entry equivalent to swiotlb_force set.
> 
> that will make intel system have to take crashkernel_low=72M too.
> otherwise intel system will get panic during swiotlb allocation.

Two things:

 1). You need to wrap the 'is_enough_..' in CONFIG_KEXEC, which means
    that the function needs to go in a header file.
 2). The check for 1MB is suspect. Why only 1MB? You mentioned it is
     b/c of crashkernel_low=72M (which I am not seeing in v3.8 kernel-parameters.txt?
     Is that part of your mega-patchset?). Anyhow, there seems to be a disconnect -
     what if the user supplied crashkernel_low=27M? Perhaps the 'is_enough'
     should also parse the bootparams to double-check that there is enough
     low-mem space? But then if the kernel grows then 72M might not be enough -
     you might need 82M with 3.9.

     Perhaps a better way for this is to do:
	1). Change 'is_enough' to check only for 4MB.
	2). When booting as kexec, the SWIOTLB would only use 4MB instead of 64MB?

     Or, we could also use the post-late SWIOTLB initialization similiary to how it was
     done on ia64. This would mean that the AMD VI code would just call the
     .. something like this - NOT tested or even compile tested:

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c1c74e0..e7fa8f7 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3173,6 +3173,24 @@ int __init amd_iommu_init_dma_ops(void)
 	if (unhandled && max_pfn > MAX_DMA32_PFN) {
 		/* There are unhandled devices - initialize swiotlb for them */
 		swiotlb = 1;
+		/* Late (so no bootmem allocator) usage and only if the early SWIOTLB
+ 		 * hadn't been allocated (which can happen on kexec kernels booted
+ 		 * above 4GB). */
+		if (!swiotlb_nr_tbl()) {
+			int retry = 3;
+			int mb_size = 64;
+			int rc = 0;
+retry_me:
+			if (retry < 0)
+				panic("We tried setting %dMB for SWIOTLB but got -ENOMEM", mb_size << 1);
+			rc = swiotlb_late_init_with_default_size(mb_size * (1<<20));
+			if (rc) {
+				retry --;
+				mb_size >> 1;
+				goto retry_me;
+			}
+ 			dma_ops = &swiotlb_dma_ops;
+		}
 	}
 
 	amd_iommu_stats_init();

And then the early SWIOTLB initialization for 64MB can fail and we are still OK.
> 
> Thanks
> 
> Yinghai
