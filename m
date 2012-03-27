Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2C0Q6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:58:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46927 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2C0Q6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:58:04 -0400
Message-ID: <4F71F198.4080405@canonical.com>
Date: Tue, 27 Mar 2012 17:58:00 +0100
From: Colin Ian King <colin.king@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ASPM: Fix pcie devices with non-pcie children
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1332857861-11562-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/12 15:17, Matthew Garrett wrote:
> Commit 4949be16822e92a18ea0cc1616319926628092ee changed the behaviour of
> pcie_aspm_sanity_check() to always return 0 if aspm is disabled, in order
> to avoid cases where we changed ASPM state on pre-PCIe 1.1 devices. This
> skipped the secondary function of pcie_aspm_sanity_check which was to avoid
> us enabling ASPM on devices that had non-PCIe children, causing us to hit
> a BUG_ON later on. Move the aspm_disabled check so we continue to honour
> that scenario.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/pci/pcie/aspm.c |   13 ++++++++++---
>   1 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 86111d9..41e367b 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -521,9 +521,6 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
>   	int pos;
>   	u32 reg32;
>
> -	if (aspm_disabled)
> -		return 0;
> -
>   	/*
>   	 * Some functions in a slot might not all be PCIe functions,
>   	 * very strange. Disable ASPM for the whole slot
> @@ -532,6 +529,16 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
>   		pos = pci_pcie_cap(child);
>   		if (!pos)
>   			return -EINVAL;
> +
> +		/*
> +		 * If ASPM is disabled then we're not going to change
> +		 * the BIOS state. It's safe to continue even if it's a
> +		 * pre-1.1 device
> +		 */
> +
> +		if (aspm_disabled)
> +			continue;
> +
>   		/*
>   		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
>   		 * RBER bit to determine if a function is 1.1 version device

We got a user who's now verified this fixes the BUG_ON() during boot,
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/961482/comments/51

.. so this does the trick. Thanks Matthew.
