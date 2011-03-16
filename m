Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1CPS6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:58:03 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60489 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611Ab1CPS57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:57:59 -0400
X-Sasl-enc: SNH+Z0FVxxTx9IXbT0hj7n2edRJVVhEQmhnBWgs9GgC5 1300301878
Date: Wed, 16 Mar 2011 15:57:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: disable alsa volume
 mixer for SL410/SL510
Message-ID: <20110316185755.GC7918@khazad-dum.debian.net>
References: <1300181106-20219-1-git-send-email-keng-yu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300181106-20219-1-git-send-email-keng-yu.lin@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Keng-Yu Lin wrote:
> The mute key on SL410/SL510 only works when the alsa volume mixer
> is not enabled. This patch makes the alsa volume mixer disabled
> on the matched SL410/SL510 EC versions.

I'd like more data on this.  Is this some sort of weird interaction with
userspace, or does the firmware actually changes behaviour when we
enable the MUTE HKEY event in the event mask?

>  #define TPACPI_VOL_Q_MUTEONLY	0x0001	/* Mute-only control available */
>  #define TPACPI_VOL_Q_LEVEL	0x0002  /* Volume control available */
> +#define TPACPI_VOL_Q_IGNORE	0x0003  /* No Volume control available */

Change the comment to /* Blacklist volume control */, please. And name
it TPACPI_VOL_Q_BLACKLIST.

> @@ -6921,20 +6924,21 @@ static int __init volume_init(struct ibm_init_struct *iibm)
>  	if (volume_capabilities >= TPACPI_VOL_CAP_MAX)
>  		return -EINVAL;
>  
> +	quirks = tpacpi_check_quirks(volume_quirk_table,
> +				     ARRAY_SIZE(volume_quirk_table));
> +
>  	/*
>  	 * The ALSA mixer is our primary interface.
>  	 * When disabled, don't install the subdriver at all
>  	 */
> -	if (!alsa_enable) {
> +	if (!alsa_enable || quirks & TPACPI_VOL_Q_IGNORE) {
>  		vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
>  			    "ALSA mixer disabled by parameter, "
>  			    "not loading volume subdriver...\n");
> +		alsa_enable = 0; /* reflect the quirk status in sysfs */
>  		return 1;
>  	}
>  
> -	quirks = tpacpi_check_quirks(volume_quirk_table,
> -				     ARRAY_SIZE(volume_quirk_table));
> -
>  	switch (volume_capabilities) {
>  	case TPACPI_VOL_CAP_AUTO:
>  		if (quirks & TPACPI_VOL_Q_MUTEONLY)

Do not overload error messages like that.  It will now spill an
incorrect message when the quirk list blacklists the volume control.

Unfortunately, we're constrained by the unextensible alsa module command
line ABI, so something more sensible (implementing "auto") is not
available.

Instead, please do it like this:

1.  Do not move the quirks test or error message up.

2.  After the quirk check, do this:

if (quirks & TPACPI_VOL_Q_IGNORE) {
	dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
		   "ALSA mixer blacklisted for this model, not loading
volume subdriver...\n");
	return 1;
}

Note that it is a "dbg_printk", and NOT a "vdbg_printk".

I'd much rather have something that allows the user to override the
blacklisting, though.  But it cannot be done through alsa_enable.  Maybe
you could be persuaded to add support for a "force_volume" parameter?

If you do add support for "force_volume", please make it an unsigned int
(not bool), use 0 for no, and 1 for yes, and leave the other values
undefined.  And add it to the documentation in
Documentation/laptops/thinkpad-acpi.txt.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
