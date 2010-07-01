Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0GAG6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 02:58:13 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:42810 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab0GAG6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 02:58:11 -0400
Date: Wed, 30 Jun 2010 23:58:11 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       "Wang, Yong Y" <yong.y.wang@intel.com>, qi.wang@intel.com,
       joel.clark@intel.com, andrew.chih.howe.khor@intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Packet hub driver of Topcliff PCH
Message-ID: <20100701065811.GM29166@hexapodia.org>
References: <4C204B0D.2030201@dsn.okisemi.com> <4C2C2423.4060705@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2C2423.4060705@dsn.okisemi.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 02:14:11PM +0900, Masayuki Ohtak wrote:
> Hi Andy and Randy
> 
> I have modified for your comments.
> Please confirm below.

Your style is looking better, and the additional documentation is much
appreciated.

I still have concerns about the userland interface design.  It still
seems to me that the MAC interface should be used by something in
drivers/net and there's no reason to expose the SROM in /dev unless it
contains more than just the MAC address.


A few more style issues I saw on a quick scan through -- this was not a
comprehensive review:


> +static long pch_phub_ioctl(struct file *file, unsigned int cmd,
> +			   unsigned long arg)
[snip]
> +		ret_value = copy_to_user(varg,
> +					 mac_addr, sizeof(mac_addr));

Reformat this to fit on one line:
+		ret_value = copy_to_user(varg, mac_addr, sizeof(mac_addr));


[snip]
> +	case IOCTL_PHUB_WRITE_MAC_ADDR:
> +		ret_value = copy_from_user(mac_addr, varg, sizeof(mac_addr));
> +
> +		if (ret_value)

Here we need to break:

+               {
> +			ret_value = -EFAULT;
+                       break;
+               }

because if copy_from_user failed ...

> +		for (i = 0; i < 6; i++)
> +			pch_phub_write_gbe_mac_addr(i, mac_addr[i]);

... we would pass garbage to pch_phub_write_gbe_mac_addr.

[snip]
> +		dev_dbg(&pdev->dev,
> +				"\npch_phub_probe : pci_enable_device FAILED");

Prefix \n is not correct.  This should be

+		dev_dbg(&pdev->dev, "pch_phub_probe: pci_enable_device FAILED");

In general dev_dbg format strings should fit on one 80-char line.  If
your format strings are longer than that, it's a clue you're doing
something wrong.  For example:

> +	dev_dbg(&pdev->dev, "pch_phub_probe : "
> +			"pci_enable_device returns %d\n", ret);

+	dev_dbg(&pdev->dev, "pch_phub_probe: pci_enable_device returns %d\n",
+		 ret);

> +	ret = pci_request_regions(pdev, MODULE_NAME);
> +	if (ret) {
> +		dev_dbg(&pdev->dev,
> +				"pch_phub_probe : pci_request_regions FAILED");

If you have a dev_dbg, please print ret.  It may give an important clue.

[snip a bunch more I don't have time to review right now]

Thanks,
-andy
