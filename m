Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0DOA3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 20:29:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:41790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab0DOA3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 20:29:41 -0400
Message-ID: <4BC65E7C.5080203@kernel.org>
Date: Thu, 15 Apr 2010 09:31:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.34-rc3 Disable R_OK (Early ACK) on SII 3726/4726
 PMP
References: <m2gda824cf31004131746o15be77b1n7af6fac42ce25280@mail.gmail.com>
In-Reply-To: <m2gda824cf31004131746o15be77b1n7af6fac42ce25280@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 00:28:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/14/2010 09:46 AM, Grant Grundler wrote:
> In 2009, While running "cache read" performance test of drives behind
> SII PMP we encountered a "all 5 drives" timeout on more than 30% of the
> machines under test.  This patch reduces the rate by a factor of about 70.
> Low enough that we didn't care to further investigate the issue.

Interesting.

> Performance impact with any sort of "normal" use was ~2%+ CPU and less
> than 1% throughput degradation.  Worst case impact (cached read) was
> 6% IOPS reduction. This is with NCQ off (q=1) but I believe FIS based
> switching enabled in the SATA driver.

Given the general flakiness of the device, I'm more than willing to
pay some overhead for stability and the performance hit seems pretty
small.

> @@ -260,12 +262,28 @@ static int sata_pmp_configure(struct ata_device
> *dev, int print_info)
>                 goto fail;
>         }
> 
> +       /* For Sil3726, disable sending Early R_OK */
> +       if (vendor == 0x1095 && devid == 0x3726) {

Isn't this also applicable to 4723 and 4726?

> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 700c5b9..18fc208 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -386,6 +386,7 @@ enum {
>         SATA_PMP_GSCR_ERROR_EN  = 33,
>         SATA_PMP_GSCR_FEAT      = 64,
>         SATA_PMP_GSCR_FEAT_EN   = 96,
> +       SATA_PMP_GSCR_SII_POL   = 129,  /* VENDOR : Silicon Image 3726/4726 */

Can you plesae define it inside libata-pmp.c?  ata.h only contains
stuff defined by the ATA standard.

Other than the above nitpicks,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
