Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2JMHBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 03:01:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28668 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2JMHBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 03:01:34 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-b0-507911cd5fc6
Message-id: <507911BA.3080204@samsung.com>
Date: Sat, 13 Oct 2012 16:01:14 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] sdhci: put regulator if probe fails
References: <1350089717-4050-1-git-send-email-cascardo@holoscopio.com>
In-reply-to: <1350089717-4050-1-git-send-email-cascardo@holoscopio.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jAd2zgpUBBj8PcFhc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKWNxQW3OOtmLTlLXMD40zuLkYODgkBE4kri6q7GDmB
	TDGJC/fWs3UxcnEICSxilJh4bxoThPOSUeLkoc3MIFW8AloSSy9uZwGxWQRUJR4/OcQIYrMJ
	6Ehs/3acCcQWFQiRWDL3KztEvaDEj8n3wOpFBKwlOn/sAoszC0RJ/L1+HywuLGAhsWbBcrBe
	IQE3ia7di8BqOAXcJTYf+8QMUa8jsb91GhuELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVT
	C5ILipPSc430ihNzi0vz0vWS83M3MYID8Zn0DsZVDRaHGAU4GJV4eG91VwQIsSaWFVfmHmKU
	4GBWEuHlSwcK8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1
	MAb8Ff+rHp4b/HqulfIiu2VPfvx48ubd+YTK6r85wYysB9J9OOycp97mXW/x2ogtK/oKw+pJ
	G78W+J7cfjrs8muR3O7+P7/YCt7qZ+q+PxZ96BhLbc/Hzosmt/6u2BC2/6htxdMHmzfy9u6q
	nvns3DSO+kkOMndezOix3ffqRtXO5ZYH90sLljoqsRRnJBpqMRcVJwIAQciMs0ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2012 09:55 AM, Thadeu Lima de Souza Cascardo wrote:
> When using the dummy regulator, SDHCI may fail its probing because the
> regulator does not support any voltages.
> 
> When reloading the driver, you will get a warning about a duplicate
> sysfs link.
> 
> [72211.963386] 0000:03:00.0 supply vmmc not found, using dummy regulator
> [72211.963409] ------------[ cut here ]------------
> [72211.963420] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0x99/0xad()
> [72211.963424] Hardware name:
> [72211.963429] sysfs: cannot create duplicate filename '/devices/platform/reg-dummy/regulator/regulator.0/0000:03:00.0-vmmc'
> 
> Avoid this by properly cleaning up when the probe fails calling
> regulator_put. Other fail paths get fixed as well.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/mmc/host/sdhci.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 7922adb..dd6bc26 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2992,7 +2992,8 @@ int sdhci_add_host(struct sdhci_host *host)
>  	if (mmc->ocr_avail == 0) {
>  		pr_err("%s: Hardware doesn't report any "
>  			"support voltages.\n", mmc_hostname(mmc));
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto out_vmmc;
>  	}
>  
>  	spin_lock_init(&host->lock);
> @@ -3121,6 +3122,9 @@ reset:
>  untasklet:
>  	tasklet_kill(&host->card_tasklet);
>  	tasklet_kill(&host->finish_tasklet);
> +out_vmmc:
> +	if (host->vmmc)
> +		regulator_put(host->vmmc);
If fall down to untasklet, need not to disable regulator for vmmc?

Best Regards,
Jaehoon Chung
>  
>  	return ret;
>  }
> 

