Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0FOPMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:12:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0FOPME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:12:04 -0400
Message-ID: <4C17983F.8020405@redhat.com>
Date: Tue, 15 Jun 2010 17:11:59 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] pci: Don't enable aspm before drivers have had a chance
 to veto it
References: <1276113907-22432-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1276113907-22432-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 10:05 PM, Matthew Garrett wrote:
> The aspm code will currently set the configured aspm policy before drivers
> have had an opportunity to indicate that their hardware doesn't support it.
> Unfortunately, putting some hardware in L0 or L1 can result in the hardware
> no longer responding to any requests, even after aspm is disabled. It makes
> more sense to leave aspm policy at the BIOS defaults at initial setup time,
> reconfiguring it after pci_enable_device() is called. This allows the
> driver to blacklist individual devices beforehand.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>
> Cleaned up slightly to remove the hacky aspm_policy changing.
>
>  drivers/pci/pcie/aspm.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index be53d98..7122281 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -588,11 +588,23 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
>  	 * update through pcie_aspm_cap_init().
>  	 */
>  	pcie_aspm_cap_init(link, blacklist);
> -	pcie_config_aspm_path(link);
>  
>  	/* Setup initial Clock PM state */
>  	pcie_clkpm_cap_init(link, blacklist);
> -	pcie_set_clkpm(link, policy_to_clkpm_state(link));
> +
> +	/*
> +	 * At this stage drivers haven't had an opportunity to change the
> +	 * link policy setting. Enabling ASPM on broken hardware can cripple
> +	 * it even before the driver has had a chance to disable ASPM, so
> +	 * default to a safe level right now. If we're enabling ASPM beyond
> +	 * the BIOS's expectation, we'll do so once pci_enable_device() is
> +	 * called.
> +	 */
> +	if (aspm_policy != POLICY_POWERSAVE) {
> +		pcie_config_aspm_path(link);
> +		pcie_set_clkpm(link, policy_to_clkpm_state(link));
> +	}
>   
Matthew, isn't it so that the POLICY_DEFAULT will pass the above test
and possibly switch the ASPM on?

tomas

> +
>  unlock:
>  	mutex_unlock(&aspm_lock);
>  out:
>   

