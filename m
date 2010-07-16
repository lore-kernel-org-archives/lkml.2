Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966230Ab0GPWMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:12:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:41196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0GPWMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:12:49 -0400
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C3E9F6E.1030508@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost>	<4C2B9DAC.1030806@intel.com>
	 <1277928125.18854.0.camel@localhost>	<4C2BBACF.3080405@intel.com>
	 <1277965264.18854.16.camel@localhost>	<4C2C3B07.7050200@intel.com>
	 <1277968336.4945.3.camel@localhost>	<4C2C4319.6090906@intel.com>
	 <1277972137.12558.2.camel@localhost>	<4C2CCE67.6070600@intel.com>
	 <AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	 <AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	 <1278324973.16975.68.camel@localhost>
	 <AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	 <1278463901.20082.34.camel@dwillia2-linux>
	 <1278474039.31393.8.camel@localhost>	<4C34BDCD.9080607@intel.com>
	 <AANLkTild7PCKygpPAJRo2G237CY8wJyveM9_Glx8qmoK@mail.gmail.com>
	 <4C379462.1020704@intel.com> <1278720554.9522.18.camel@localhost>
	 <4C3E9F6E.1030508@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 23:12:05 +0100
Message-ID: <1279318325.27733.21.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-3.fc13.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 22:41 -0700, Dan Williams wrote:
> +       for_each_drhd_unit(drhd)
> +               for (i = 0; i < drhd->devices_cnt; i++) {
> +                       /* we know that the this device's iommu is at
> +                        * offset 0xa000 from vtbar
> +                        */
> +                       if (drhd->devices[i] == pdev &&
> +                           drhd->reg_base_addr - vtbar != 0xa000) {
> +                               WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
> +                                               "BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device\n");
> +                               pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
> +                               return;
> +                       }
> +               }
> +} 

Ah, that's the problem. Sorry, should have noticed this before. Since
this is the catch-all IOMMU, the device isn't explicitly listed.

You want 'drhd = dmar_find_matched_drhd_unit(pdev);' and then compare
vtbar with the reg_base_addr of that one.

-- 
dwmw2

