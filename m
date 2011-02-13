Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1BMOlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 09:41:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53193 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1BMOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 09:40:56 -0500
Message-ID: <4D57ED29.2030801@ru.mvista.com>
Date: Sun, 13 Feb 2011 17:39:37 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] ata: add CONFIG_SATA_HOST config option
References: <201102111433.41507.bzolnier@gmail.com>
In-Reply-To: <201102111433.41507.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-02-2011 16:33, Bartlomiej Zolnierkiewicz wrote:

> Add CONFIG_SATA_HOST config option (for selecting SATA Host
> support) to make setup easier on PATA-only systems.

> Additionally move SATA-specific code to libata-sata.c which
> allows us to save ~11.5k of the output code size (x86-64) on
> PATA-only systems for CONFIG_SATA_HOST=n:

> CONFIG_SATA_HOST=y:
>     text    data     bss     dec     hex filename
>    44283    6576      57   50916    c6e4 drivers/ata/libata-core.o
>    29054      16       2   29072    7190 drivers/ata/libata-eh.o
>    20085       0      19   20104    4e88 drivers/ata/libata-sff.o
>     8699       0       0    8699    21fb drivers/ata/libata-sata.o

> CONFIG_SATA_HOST=n:
>     text    data     bss     dec     hex filename
>    43754    6576      57   50387    c4d3 drivers/ata/libata-core.o
>    26775      16       2   26793    68a9 drivers/ata/libata-eh.o
>    20144       0      19   20163    4ec3 drivers/ata/libata-sff.o

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> Index: b/drivers/ata/libata-core.c
> ===================================================================
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
[...]
> @@ -573,34 +494,26 @@ void ata_tf_to_fis(const struct ata_task
>  	fis[19] = 0;
>  }

    Hm, what about ata_tf_to_fis()? It shouldn't be needed by non-SATA stuff, 
moreover it'should be only needed by non-SFF controllers...

> +#ifndef CONFIG_SATA_HOST
> +int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
> +		      bool spm_wakeup)
>   {
> -	tf->command	= fis[2];	/* status */
> -	tf->feature	= fis[3];	/* error */
> -
> -	tf->lbal	= fis[4];
> -	tf->lbam	= fis[5];
> -	tf->lbah	= fis[6];
> -	tf->device	= fis[7];
> -
> -	tf->hob_lbal	= fis[8];
> -	tf->hob_lbam	= fis[9];
> -	tf->hob_lbah	= fis[10];
> -
> -	tf->nsect	= fis[12];
> -	tf->hob_nsect	= fis[13];
> +	return -EOPNOTSUPP;
> +}
> +EXPORT_SYMBOL_GPL(sata_link_scr_lpm);

    Shouldn't there be empty line here?

> +int sata_std_hardreset(struct ata_link *link, unsigned int *class,
> +		       unsigned long deadline)
> +{
> +	return -EOPNOTSUPP;
> +}
> +EXPORT_SYMBOL_GPL(sata_std_hardreset);

    ... and here?

> Index: b/drivers/ata/libata-sata.c
> ===================================================================
> --- /dev/null
> +++ b/drivers/ata/libata-sata.c
> @@ -0,0 +1,1242 @@
[...]
> +int sata_set_spd(struct ata_link *link)
> +{
> +	u32 scontrol;
> +	int rc;
> +
> +	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))

    I guess checkpatch.pl protests here...

> +		return rc;
> +
> +	if (!__sata_set_spd_needed(link,&scontrol))
> +		return 0;
> +
> +	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))

    Here too...

> +		return rc;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(sata_set_spd);
[...]
> +int sata_link_debounce(struct ata_link *link, const unsigned long *params,
> +		       unsigned long deadline)
> +{
> +	unsigned long interval = params[0];
> +	unsigned long duration = params[1];
> +	unsigned long last_jiffies, t;
> +	u32 last, cur;
> +	int rc;
> +
> +	t = ata_deadline(jiffies, params[2]);
> +	if (time_before(t, deadline))
> +		deadline = t;
> +
> +	if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))

    And here too...

> +/**
> + *	sata_link_resume - resume SATA link
> + *	@link: ATA link to resume SATA
> + *	@params: timing parameters { interval, duratinon, timeout } in msec
> + *	@deadline: deadline jiffies for the operation
> + *
> + *	Resume SATA phy @link and debounce it.
> + *
> + *	LOCKING:
> + *	Kernel thread context (may sleep)
> + *
> + *	RETURNS:
> + *	0 on success, -errno on failure.
> + */
> +int sata_link_resume(struct ata_link *link, const unsigned long *params,
> +		     unsigned long deadline)
> +{
> +	int tries = ATA_LINK_RESUME_TRIES;
> +	u32 scontrol, serror;
> +	int rc;
> +
> +	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))

    And here...

> +		return rc;
> +
> +	/*
> +	 * Writes to SControl sometimes get ignored under certain
> +	 * controllers (ata_piix SIDPR).  Make sure DET actually is
> +	 * cleared.
> +	 */
> +	do {
> +		scontrol = (scontrol & 0x0f0) | 0x300;
> +		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
> +			return rc;
> +		/*
> +		 * Some PHYs react badly if SStatus is pounded
> +		 * immediately after resuming.  Delay 200ms before
> +		 * debouncing.
> +		 */
> +		ata_msleep(link->ap, 200);
> +
> +		/* is SControl restored correctly? */
> +		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))

    And here...

> +			return rc;
> +	} while ((scontrol&  0xf0f) != 0x300&&  --tries);
> +
> +	if ((scontrol & 0xf0f) != 0x300) {
> +		ata_link_printk(link, KERN_ERR,
> +				"failed to resume link (SControl %X)\n",
> +				scontrol);
> +		return 0;
> +	}
> +
> +	if (tries<  ATA_LINK_RESUME_TRIES)
> +		ata_link_printk(link, KERN_WARNING,
> +				"link resume succeeded after %d retries\n",
> +				ATA_LINK_RESUME_TRIES - tries);
> +
> +	if ((rc = sata_link_debounce(link, params, deadline)))

    And here...

> +		return rc;
> +
> +	/* clear SError, some PHYs require this even for SRST to work */
> +	if (!(rc = sata_scr_read(link, SCR_ERROR, &serror)))

    Here too...

> +		rc = sata_scr_write(link, SCR_ERROR, serror);
> +
> +	return rc != -EINVAL ? rc : 0;
> +}
> +EXPORT_SYMBOL_GPL(sata_link_resume);
[...]
> +int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
> +			unsigned long deadline,
> +			bool *online, int (*check_ready)(struct ata_link *))
> +{
> +	u32 scontrol;
> +	int rc;
> +
> +	DPRINTK("ENTER\n");
> +
> +	if (online)
> +		*online = false;
> +
> +	if (sata_set_spd_needed(link)) {
> +		/* SATA spec says nothing about how to reconfigure
> +		 * spd.  To be on the safe side, turn off phy during
> +		 * reconfiguration.  This works for at least ICH7 AHCI
> +		 * and Sil3124.
> +		 */
> +		if ((rc = sata_scr_read(link, SCR_CONTROL,&scontrol)))
> +			goto out;
> +
> +		scontrol = (scontrol & 0x0f0) | 0x304;
> +
> +		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))

    And here...

> +			goto out;
> +
> +		sata_set_spd(link);
> +	}
> +
> +	/* issue phy wake/reset */
> +	if ((rc = sata_scr_read(link, SCR_CONTROL,&scontrol)))

    Here too...

> +		goto out;
> +
> +	scontrol = (scontrol&  0x0f0) | 0x301;
> +
> +	if ((rc = sata_scr_write_flush(link, SCR_CONTROL, scontrol)))

    And here...
    I understand that you're only moving the code. Perhaps it's worth fixing 
checkpatch.pl's complaints beforehand -- I was going to look at it...

WBR, Sergei
