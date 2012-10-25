Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505Ab2JYP4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:56:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41072 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab2JYP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:56:05 -0400
Date: Thu, 25 Oct 2012 17:56:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] handle error path in edac_mc_sysfs_init()
Message-ID: <20121025155606.GF308@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Denis Kirjanov <kirjanov@gmail.com>, dougthompson@xmission.com,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1351179778-6591-1-git-send-email-kirjanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351179778-6591-1-git-send-email-kirjanov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 07:42:58PM +0400, Denis Kirjanov wrote:
> Handle errors on edac_mc_sysfs_init()'s error path
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> ---
>  drivers/edac/edac_mc_sysfs.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index ed0bc07..ea34ece 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -1124,11 +1124,16 @@ int __init edac_mc_sysfs_init(void)
>  	edac_subsys = edac_get_sysfs_subsys();
>  	if (edac_subsys == NULL) {
>  		edac_dbg(1, "no edac_subsys\n");
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto out;
>  	}
>  
>  	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
> -
> +	if (!mci_pdev) {
> +		err = -ENOMEM;
> +		goto out_put_sysfs;
> +	}
> +		
>  	mci_pdev->bus = edac_subsys;
>  	mci_pdev->type = &mc_attr_type;
>  	device_initialize(mci_pdev);
> @@ -1141,6 +1146,11 @@ int __init edac_mc_sysfs_init(void)
>  	edac_dbg(0, "device %s created\n", dev_name(mci_pdev));

Thanks for doing this.

However, from looking at this function further, it is still f*cked up -
the error path after device_add needs handling too, i.e. adding another
label:

 out_device_add:
 	kfree(mci_pdev);

> +out_put_sysfs:
> +	edac_put_sysfs_subsys();
> +out:
> +	return err;

to which you can goto to after device_add fails.

Would you be willing to fix that too, while you're at it? Btw, I can
totally understand if you say no - I'll take care of it myself instead
then :-).

Thanks.

-- 
Regards/Gruss,
Boris.
