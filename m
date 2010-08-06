Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab0HFKns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:43:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047Ab0HFKnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:43:45 -0400
Message-ID: <4C5BE75F.1050105@suse.de>
Date: Fri, 06 Aug 2010 12:43:43 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] scsi: megaraid_sas - Add input parameter for max_sectors
References: <4B6A08C587958942AA3002690DD4F8C3D080455E@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3D09274AC@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3DBD67FAE@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3DBD67FAE@cosmail02.lsi.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yang, Bo wrote:
> RESUBMIT requested by James Bottomley:
> 
> Driver add the input parameters support for max_sectors for our gen2 chip.  Customer can
> Set the max_sectors support to 1MB for gen2 chip during the driver load.
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> ---
> drivers/scsi/megaraid/megaraid_sas.c |   74 +++++++++++++++++++++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas.h |    1
>  2 files changed, 75 insertions(+)
> 
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
> --- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 09:04:38.000000000 -0400
> +++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 09:51:56.000000000 -0400
> @@ -57,6 +57,15 @@ module_param_named(poll_mode_io, poll_mo
>  MODULE_PARM_DESC(poll_mode_io,
>  	"Complete cmds from IO path, (default=0)");
>  
> +/*
> + * Number of sectors per IO command
> + * Will be set in megasas_init_mfi if user does not provide
> + */
> +static unsigned int max_sectors;
> +module_param_named(max_sectors, max_sectors, int, 0);
> +MODULE_PARM_DESC(max_sectors,
> +	"Maximum number of sectors per IO command");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux@lsi.com");
> @@ -3566,6 +3575,32 @@ static int megasas_start_aen(struct mega
>  				    class_locale.word);
>  }
>  
> +static ssize_t
> +sysfs_max_sectors_read(struct kobject *kobj, struct bin_attribute *bin_attr,
> +			char *buf, loff_t off, size_t count)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +
> +	struct Scsi_Host *host = class_to_shost(dev);
> +
> +	struct megasas_instance *instance =
> +				(struct megasas_instance *)host->hostdata;
> +
> +	count = sprintf(buf, "%u\n", instance->max_sectors_per_req);
> +
> +	return count+1;
> +}
> +
> +static struct bin_attribute sysfs_max_sectors_attr = {
> +	.attr = {
> +		.name = "max_sectors",
> +		.mode = S_IRUSR|S_IRGRP|S_IROTH,
> +		.owner = THIS_MODULE,
> +	},
> +	.size = 7,
> +	.read = sysfs_max_sectors_read,
> +};
> +
>  /**
>   * megasas_io_attach -	Attaches this driver to SCSI mid-layer
>   * @instance:		Adapter soft state
> @@ -3573,6 +3608,7 @@ static int megasas_start_aen(struct mega
>  static int megasas_io_attach(struct megasas_instance *instance)
>  {
>  	struct Scsi_Host *host = instance->host;
> +	u32		error;
>  
>  	/*
>  	 * Export parameters required by SCSI mid-layer
> @@ -3588,6 +3624,27 @@ static int megasas_io_attach(struct mega
>  			instance->max_fw_cmds - MEGASAS_INT_CMDS;
>  	host->this_id = instance->init_id;
>  	host->sg_tablesize = instance->max_num_sge;
> +	/*
> +	 * Check if the module parameter value for max_sectors can be used
> +	 */
> +	if (max_sectors && max_sectors < instance->max_sectors_per_req)
> +		instance->max_sectors_per_req = max_sectors;
> +	else {
> +		if (max_sectors) {
> +			if (((instance->pdev->device ==
> +				PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
> +				(instance->pdev->device ==
> +				PCI_DEVICE_ID_LSI_SAS0079GEN2)) &&
> +				(max_sectors <= MEGASAS_MAX_SECTORS)) {
> +				instance->max_sectors_per_req = max_sectors;
> +			} else {
> +			printk(KERN_INFO "megasas: max_sectors should be > 0"
> +				"and <= %d (or < 1MB for GEN2 controller)\n",
> +				instance->max_sectors_per_req);
> +			}
> +		}
> +	}
> +
>  	host->max_sectors = instance->max_sectors_per_req;
>  	host->cmd_per_lun = 128;
>  	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
> @@ -3604,10 +3661,27 @@ static int megasas_io_attach(struct mega
>  	}
>  
>  	/*
> +	 * Create sysfs entries for module paramaters
> +	 */
> +	error = sysfs_create_bin_file(&instance->host->shost_dev.kobj,
> +			&sysfs_max_sectors_attr);
> +
Errm. sysfs_create_bin_file? 
Do you expect a user to paste binary values in there?
Please use the standard interface here.
sysfs_create_bin_file should only be used for 'real' binary values,
like raw f/w commands.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
