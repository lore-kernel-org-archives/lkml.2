Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306Ab2AFKWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:22:11 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:10053 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200Ab2AFKWH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 6 Jan 2012 05:22:07 -0500
Message-Id: <4F06C101020000780006AC32@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jan 2012 08:38:09 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <jbarnes@virtuousgeek.org>
Subject: Re: [Xen-devel] [PATCH 4/5] xen/pciback: Expand the warning
 message to include domain id.
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
 <1325724403-29642-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1325724403-29642-5-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.01.12 at 01:46, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> When a PCI device is transferred to another domain and it is still
> in usage (from the internal perspective), mention which other
> domain is using it to aid in debugging.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xen-pciback/xenbus.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
> index 474d52e..fa130bd 100644
> --- a/drivers/xen/xen-pciback/xenbus.c
> +++ b/drivers/xen/xen-pciback/xenbus.c
> @@ -243,8 +243,10 @@ static int xen_pcibk_export_device(struct 
> xen_pcibk_device *pdev,
>  	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
>  	if (xen_register_device_domain_owner(dev,
>  					     pdev->xdev->otherend_id) != 0) {
> -		dev_err(&dev->dev, "device has been assigned to another " \
> -			"domain! Over-writting the ownership, but beware.\n");
> +		int other_domain = xen_find_device_domain_owner(dev);
> +		dev_err(&dev->dev, "device has been assigned to %d " \
> +			"domain! Over-writting the ownership, but beware.\n",
> +			other_domain);

As you're touching this anyway, how about fixing the other minor
issues with it too? E.g.

		dev_err(&dev->dev, "Device appears to be assigned to dom%d!"
			" Overwriting the ownership, but beware.\n",
			xen_find_device_domain_owner(dev));

(a native English speaker may want to comment the "but beware"
part - it reads odd for me).

Jan

>  		xen_unregister_device_domain_owner(dev);
>  		xen_register_device_domain_owner(dev, pdev->xdev->otherend_id);
>  	}
> -- 
> 1.7.7.4
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com 
> http://lists.xensource.com/xen-devel 



