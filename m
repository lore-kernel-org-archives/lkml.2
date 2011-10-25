Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1JYOie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:38:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1JYOid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:38:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=r74/rwSUBYpv7RtcGAyRTZqjTSQZ7tAQmZNL6/AzQ7Uxch3Mlp0ECxx4xIhHzwygR
	8Cnst1Mdo9bJ2xXuAtaiA==
MIME-Version: 1.0
In-Reply-To: <1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com> <1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Oct 2011 08:38:10 -0600
Message-ID: <CAErSpo4Rmtd4LsXmgvb4Vn92z=u1feRyPWF=KS8ggVZvitjEnA@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add NumaChip quirk
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 2:22 AM, Daniel J Blueman
<daniel@numascale-asia.com> wrote:
> Add quirk for Numascale's NumaChip to prevent resource conflicts.
>
> v2:
>  - [Daniel] rediffed and validated against 3.1-rc10
>
> Signed-off-by: Steffen Persvold <sp@numascale.com>
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  drivers/pci/quirks.c    |   14 ++++++++++++++
>  include/linux/pci_ids.h |    4 ++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 1196f61..051b793 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2679,6 +2679,20 @@ static void __devinit quirk_hotplug_bridge(struct pci_dev *dev)
>
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_HINT, 0x0020, quirk_hotplug_bridge);
>
> +/* Clear all resources on NumaChip to avoid conflicts */
> +static void __devinit numachip_resource_fixup(struct pci_dev *pdev)
> +{
> +       int i;
> +
> +       for (i = PCI_STD_RESOURCES; i <= PCI_ROM_RESOURCE; i++)
> +               memset(&pdev->resource[i], 0, sizeof(pdev->resource[i]));
> +
> +       dev_notice(&pdev->dev, "Disabled all PCI resources for NumaChip\n");
> +}
> +
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NUMASCALE,
> +       PCI_DEVICE_ID_NUMASCALE_NUMACHIP0, numachip_resource_fixup);

This feels like a band-aid ... what's the background here?  I can see
that you're disabling PCI resources, and I can read that this avoids
conflicts, but what's the underlying cause of the conflict?

I wonder if there's a more generic problem that should be fixed
differently.  Presumably the NumaChip designers put those BARs there
for a reason, and often when we report "conflicts," it's really a clue
that we're doing something wrong in host bridge discovery or in
generic PCI.

Can you post a complete dmesg log showing the conflict?

Bjorn
