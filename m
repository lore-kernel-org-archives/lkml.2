Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab2DYA4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:56:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39893 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab2DYAzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:55:44 -0400
Date: Tue, 24 Apr 2012 17:54:32 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Ryan Wang <openspace.wang@gmail.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: 3.4-rc3 compile failed on IBM Power6
Message-ID: <20120425005432.GA14663@linux.vnet.ibm.com>
References: <CAPxxNQmfkJLPHq0BvzxOnLFO-e0FRmaF1VqLhP-jMqF-ziM2tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPxxNQmfkJLPHq0BvzxOnLFO-e0FRmaF1VqLhP-jMqF-ziM2tA@mail.gmail.com>
X-Operating-System: Linux 3.2.0-23-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042500-6148-0000-0000-0000054BA784
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

Thanks for the report!

On 25.04.2012 [08:22:19 +0800], Ryan Wang wrote:
> # gcc --version
> gcc (GCC) 4.4.6 20110731 (Red Hat 4.4.6-3)
> Copyright (C) 2010 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> platform    : pSeries
> model        : IBM,9117-MMA
> machine        : CHRP IBM,9117-MMA

<snip>

>   CC      arch/powerpc/platforms/pseries/iommu.o
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c: In function
> ?query_ddw?:
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:823: error:
> implicit declaration of function ?pci_dev_to_eeh_dev?
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:823: warning:
> assignment makes pointer from integer without a cast
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:824: error:
> dereferencing pointer to incomplete type
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:825: error:
> dereferencing pointer to incomplete type
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:826: error:
> dereferencing pointer to incomplete type
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:827: error:
> dereferencing pointer to incomplete type
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c: In function
> ?create_ddw?:
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:852: warning:
> assignment makes pointer from integer without a cast
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:853: error:
> dereferencing pointer to incomplete type
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:854: error:
> dereferencing pointer to incomplete type
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:855: error:
> dereferencing pointer to incomplete type
> /usr/src/kernels/linux/arch/powerpc/platforms/pseries/iommu.c:856: error:
> dereferencing pointer to incomplete type
> make[3]: *** [arch/powerpc/platforms/pseries/iommu.o] Error 1
> make[2]: *** [arch/powerpc/platforms/pseries] Error 2
> make[1]: *** [arch/powerpc/platforms] Error 2
> make: *** [sub-make] Error 2

Do you have CONFIG_EEH set in your .config? I'm guessing not, and that
causes pci.h to not define pci_dev_to_eeh_dev().

Gavin, I think this is broken by your
39baadbf36cee3ede5fdb8a34006d9109e5e2570. Probably need a wrapper for
pci_dev_to_eeh_dev() when !CONFIG_EEH?

Actually, looking at it more, eeh_dev, which is protected by CONFIG_EEH
in arch/powerpc/include/asm/eeh.h won't be defined in such situations
and is the type of the return from pci_dev_to_eeh_dev(). So that's going
to be broken completely if !CONFIG_EEH as above.

So maybe the callers should be EEH-unaware (as they were before) and the
callee becomes of the EEH variety (at compile-time) if CONFIG_EEH is
set?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

