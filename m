Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2AWStu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:49:50 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60141 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753220Ab2AWStt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:49:49 -0500
Message-ID: <1327344573.6447.5.camel@joe2Laptop>
Subject: Re: [PATCH] r8169: Randomise invalid MAC addresses
From: Joe Perches <joe@perches.com>
To: "Torne (Richard Coles)" <torne@google.com>
Cc: nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2012 10:49:33 -0800
In-Reply-To: <1327343540-30348-1-git-send-email-torne@google.com>
References: <1327343540-30348-1-git-send-email-torne@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 18:32 +0000, Torne (Richard Coles) wrote:
> From: "Torne (Richard Coles)" <torne@google.com>
> 
> If the default MAC address stored in the card is invalid, replace it
> with a random address and complain about it.
[]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
[]
> @@ -4103,6 +4103,14 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	/* Get MAC address */
>  	for (i = 0; i < ETH_ALEN; i++)
>  		dev->dev_addr[i] = RTL_R8(MAC0 + i);
> +
> +	if (!is_valid_ether_addr(dev->dev_addr)) {
> +		/* Report it and use a random ethernet address instead */
> +		netdev_err(dev, "Invalid MAC address: %pM\n", dev->dev_addr);
> +		random_ether_addr(dev->dev_addr);
> +		netdev_info(dev, "Using random MAC address: %pM\n",
> +			    dev->dev_addr);

Perhaps this should be on 1 line.
If KERN_level filtering is higher then KERN_INFO,
the new MAC will not be shown.

	if (!is_valid_ether_addr(dev->dev_addr)) {
		u8 mac[ETH_ALEN];
		random_ether_addr(mac);
		netdev_err(dev, "Hardware has invalid mac address %pM, using %pM\n",
			   dev->dev_addr, mac);
		memcpy(dev->dev_addr, mac, ETH_ALEN);
	}


