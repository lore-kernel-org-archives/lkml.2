Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab0FRRRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:17:05 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:48896 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933809Ab0FRRRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:17:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SCq+xxmVedP+a+BLNqzU9vkx5HklifB4SL8KtwNeZclX63pr3VvKsOd2Z6VIwMEqeBap92pNZbTowkQuI66U09uG98FB+8pkuo1AH5ZCkPNQbcPa3xa8UIy9YIX0KJqQ;
Date: Fri, 18 Jun 2010 10:15:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Don't enable aspm before drivers have had a chance
 to veto it
Message-ID: <20100618101524.10a4a9fb@virtuousgeek.org>
In-Reply-To: <1276113907-22432-1-git-send-email-mjg@redhat.com>
References: <1276113907-22432-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jun 2010 16:05:07 -0400
Matthew Garrett <mjg@redhat.com> wrote:

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
> +
>  unlock:
>  	mutex_unlock(&aspm_lock);
>  out:

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
