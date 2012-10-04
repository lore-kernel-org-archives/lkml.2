Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab2JDRnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:43:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49811 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab2JDRnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:43:17 -0400
Date: Thu, 4 Oct 2012 12:41:15 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Peter.Huewe@infineon.com,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Message-ID: <20121004174114.GA6520@ennui.austin.ibm.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
 <20121001173908.GA22342@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001173908.GA22342@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100417-2398-0000-0000-00000BDACB1A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00179598; UDB=6.00040675; UTC=2012-10-04
 17:43:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Curiously the current code does call TPM_SaveState on suspend, but
> relies on the BIOS to do TPM_Startup(ST_STATE) on resume, why the
> asymmetry?

  This is based on the PC Client Implementation for BIOS spec in the
TCG. On suspend, the OS is responsible for the save state and then on
resume the BIOS should call startup.

> Anyhow, I think the thing would be something like this. I have no
> means to test TPM suspend, so I'll just post this as a note here. It
> will apply over v2 of my patch.
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index b13ad77..7a8136a 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1336,10 +1336,23 @@ EXPORT_SYMBOL_GPL(tpm_pm_suspend);
>  int tpm_pm_resume(struct device *dev)
>  {
>         struct tpm_chip *chip = dev_get_drvdata(dev);
> +       struct tpm_cmd_t tpm_cmd;
> 
>         if (chip == NULL)
>                 return -ENODEV;
> 
> +       tpm_cmd.header.in = tpm_getcap_header;
> +       tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> +       tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> +       tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> +       rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
> +       if (rc == TPM_ERR_INVALID_POSTINIT) {
> +               /* The BIOS did not restart the TPM, execute a startup
> +                  command. */
> +               dev_info(chip->dev, "Issuing TPM_STARTUP");
> +               tpm_startup(chip, TPM_ST_STATE);
> +       }
> +

  I'd rather see us just track the state and do the right thing here. If
we don't get invalid postinit if we call tpm_startup during
tpm_tis_init/tpm_tis_i2c_init, then set a flag we switch on here.

  Peter, you mentioned you have some embedded setups, would you be able
to test?

Thanks,
Kent

>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_resume);
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

