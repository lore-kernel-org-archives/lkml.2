Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058Ab2JDOW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:22:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60988 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965014Ab2JDOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:22:26 -0400
Date: Thu, 4 Oct 2012 10:10:59 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>, yuvalmin@broadcom.com,
        bhutchings@solarflare.com, gregory.v.rose@intel.com,
        davem@davemloft.net--no-chain-reply-to
Subject: Re: [PATCH 1/5] PCI: Add pci_dev_type
Message-ID: <20121004141058.GI9158@phenom.dumpdata.com>
References: <506C3B11.9010009@redhat.com>
 <1349286695-26713-1-git-send-email-yinghai@kernel.org>
 <1349286695-26713-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349286695-26713-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 10:51:31AM -0700, Yinghai Lu wrote:
> need to use it for visiable attribute control in syfsfs for pci_dev.

Please use 'ispell' before sending your patches.


Also please explain why do you want this? If I do
'git annotate' on that file (say six months from now when I've forgotten
a lot) and try to lookup what 'is_visible' attribute is, I get
this one line explanation. Worst, the explanation does not
say *why* we need it - or the *purpose* behind it. Or if there
are patches that are going to utilize it.

The Documentation/SubmittingPatches says:

	2) Describe your changes.

	Describe the technical detail of the change(s) your patch includes.

	Be as specific as possible.  The WORST descriptions possible include
	things like "update driver X", "bug fix for driver X", or "this patch
	includes updates for subsystem X.  Please apply."

	The maintainer will thank you if you write your patch description in a
	form which can be easily pulled into Linux's source code management
	system, git, as a "commit log".  See #15, below.

	If your description starts to get long, that's a sign that you probably
	need to split up your patch.  See #3, next.

	When you submit or resubmit a patch or patch series, include the
	complete patch description and justification for it.  Don't just
	say that this is version N of the patch (series).  Don't expect the
	patch merger to refer back to earlier patch versions or referenced
	URLs to find the patch description and put that into the patch.
	I.e., the patch (series) and its description should be self-contained.
	This benefits both the patch merger(s) and reviewers.  Some reviewers
	probably didn't even receive earlier versions of the patch.

	If the patch fixes a logged bug entry, refer to that bug entry by
	number and URL.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/pci-sysfs.c |   24 ++++++++++++++++++++++++
>  drivers/pci/pci.h       |    1 +
>  drivers/pci/probe.c     |    1 +
>  3 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 02d107b..3d160aa 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1411,3 +1411,27 @@ static int __init pci_sysfs_init(void)
>  }
>  
>  late_initcall(pci_sysfs_init);
> +
> +static struct attribute *pci_dev_dev_attrs[] = {
> +	NULL,
> +};
> +
> +static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
> +						struct attribute *a, int n)
> +{
> +	return a->mode;
> +}
> +
> +static struct attribute_group pci_dev_attr_group = {
> +	.attrs = pci_dev_dev_attrs,
> +	.is_visible = pci_dev_attrs_are_visible,
> +};
> +
> +static const struct attribute_group *pci_dev_attr_groups[] = {
> +	&pci_dev_attr_group,
> +	NULL,
> +};
> +
> +struct device_type pci_dev_type = {
> +	.groups = pci_dev_attr_groups,
> +};
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index bacbcba..6f6cd14 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -157,6 +157,7 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
>  }
>  extern struct device_attribute pci_dev_attrs[];
>  extern struct device_attribute pcibus_dev_attrs[];
> +extern struct device_type pci_dev_type;
>  #ifdef CONFIG_HOTPLUG
>  extern struct bus_attribute pci_bus_attrs[];
>  #else
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index ec909af..0312f1c48 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -975,6 +975,7 @@ int pci_setup_device(struct pci_dev *dev)
>  	dev->sysdata = dev->bus->sysdata;
>  	dev->dev.parent = dev->bus->bridge;
>  	dev->dev.bus = &pci_bus_type;
> +	dev->dev.type = &pci_dev_type;
>  	dev->hdr_type = hdr_type & 0x7f;
>  	dev->multifunction = !!(hdr_type & 0x80);
>  	dev->error_state = pci_channel_io_normal;
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
