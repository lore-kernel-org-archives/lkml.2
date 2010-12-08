Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0LHQod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:44:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0LHQob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:44:31 -0500
Date: Wed, 8 Dec 2010 11:44:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Update MCP55 quirk to not affect non HyperTransport
 variants
Message-ID: <20101208164423.GH31703@redhat.com>
References: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 09:47:48AM -0500, Neil Horman wrote:
> I wrote this quirk awhile ago to properly setup MCP55 chips on hypertransport
> busses so that interrupts reached whatever cpu happend to boot the kdump kernel.
> while that works well, it was recently shown to me that a a non-hypertransport
> variant of the MCP55 exists, and on those system the register that this quirk
> manipulates causes hangs if you write to it.  Since the quirk was only meant to
> handle errors found on MCP55 chips that have a HT interface, this patch adds a
> filter to make sure the chip is an HT capable before making the needed register
> adjustment.  This lets the broken MCP55s work with kdump while not breaking the
> non-HT variants.
> 

So Neil, with non hypertransport MCP55s, interrupts are delivered to
all the cpus and seond kernel still boots?

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> Resolves https://bugzilla.kernel.org/show_bug.cgi?id=23952
> 
> Tested successfully by the reporter and myself.
> 
> Reported-by: Mathieu Bérard <mathieu@mberard.eu>
> CC: linux-pci@vger.kernel.org
> CC: kexec@lists.infradead.org
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  drivers/pci/quirks.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 6f9350c..313c0bd 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2329,6 +2329,9 @@ static void __devinit nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
>  {
>  	u32 cfg;
>  
> +	if (!pci_find_capability(dev, PCI_CAP_ID_HT))
> +		return;
> +
>  	pci_read_config_dword(dev, 0x74, &cfg);
>  
>  	if (cfg & ((1 << 2) | (1 << 15))) {
> -- 
> 1.7.2.3
