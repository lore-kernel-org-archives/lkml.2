Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1IBS3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:29:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60496 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576Ab1IBS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:29:03 -0400
X-Sasl-enc: uXTsAgVQW4396zSwh7rpGHe7l3aJl4dg+FTaB0xSRL8V 1314988142
Date: Fri, 2 Sep 2011 11:18:26 -0700
From: Greg KH <greg@kroah.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Luben Tuikov <ltuikov@yahoo.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb-devel@lists.sourceforge.net>,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating
 autosense
Message-ID: <20110902181826.GA29848@kroah.com>
References: <CAM9Y=f6eSgxsbrO11d0ux72NJip14xGQDeX84VWb9uiBtEVsjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9Y=f6eSgxsbrO11d0ux72NJip14xGQDeX84VWb9uiBtEVsjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 02:24:36PM +0800, Daniel J Blueman wrote:
> Hi Luben, Greg, Matthew,
> 
> Any plan for reviewing and accepting this patch [1] yet? I'm still
> seeing the symptoms on USB 3 SATA bridges with linux-3.0+.

I needed an ack from Matthew before I could take it.

Matthew?


> --- [1]
> 
> http://www.kerneltrap.com/mailarchive/linux-kernel/2010/11/11/4644097/thread
> 
> This patch solves two things:
> 1) Enables autosense emulation code to correctly
> interpret descriptor format sense data, and
> 2) Fixes a bug whereby the autosense emulation
> code would overwrite descriptor format sense data
> with SENSE KEY HARDWARE ERROR in fixed format, to
> incorrectly look like this:
> 
> Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  Sense Key :
> Recovered Error [current] [descriptor]
> Oct 21 14:11:07 localhost kernel: Descriptor sense data with sense
> descriptors (in hex):
> Oct 21 14:11:07 localhost kernel:        72 01 04 1d 00 00 00 0e 09 0c
> 00 00 00 00 00 00
> Oct 21 14:11:07 localhost kernel:        00 4f 00 c2 00 50
> Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  ASC=0x4 ASCQ=0x1d
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/usb/storage/transport.c |   34 +++++++++++++++++++---------------
>  1 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
> index 64ec073..cb04664 100644
> --- a/drivers/usb/storage/transport.c
> +++ b/drivers/usb/storage/transport.c
> @@ -691,6 +691,9 @@ void usb_stor_invoke_transport(struct scsi_cmnd
> *srb, struct us_data *us)
>  		int temp_result;
>  		struct scsi_eh_save ses;
>  		int sense_size = US_SENSE_SIZE;
> +		struct scsi_sense_hdr sshdr;
> +		const u8 *scdd;
> +		u8 fm_ili;
> 
>  		/* device supports and needs bigger sense buffer */
>  		if (us->fflags & US_FL_SANE_SENSE)
> @@ -774,32 +777,30 @@ Retry_Sense:
>  			srb->sense_buffer[7] = (US_SENSE_SIZE - 8);
>  		}
> 
> +		scsi_normalize_sense(srb->sense_buffer, SCSI_SENSE_BUFFERSIZE,
> +				     &sshdr);
> +
>  		US_DEBUGP("-- Result from auto-sense is %d\n", temp_result);
>  		US_DEBUGP("-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
> -			  srb->sense_buffer[0],
> -			  srb->sense_buffer[2] & 0xf,
> -			  srb->sense_buffer[12],
> -			  srb->sense_buffer[13]);
> +			  sshdr.response_code, sshdr.sense_key,
> +			  sshdr.asc, sshdr.ascq);
>  #ifdef CONFIG_USB_STORAGE_DEBUG
> -		usb_stor_show_sense(
> -			  srb->sense_buffer[2] & 0xf,
> -			  srb->sense_buffer[12],
> -			  srb->sense_buffer[13]);
> +		usb_stor_show_sense(sshdr.sense_key, sshdr.asc, sshdr.ascq);
>  #endif
> 
>  		/* set the result so the higher layers expect this data */
>  		srb->result = SAM_STAT_CHECK_CONDITION;
> 
> +		scdd = scsi_sense_desc_find(srb->sense_buffer,
> +					    SCSI_SENSE_BUFFERSIZE, 4);
> +		fm_ili = (scdd ? scdd[3] : srb->sense_buffer[2]) & 0xA0;
> +
>  		/* We often get empty sense data.  This could indicate that
>  		 * everything worked or that there was an unspecified
>  		 * problem.  We have to decide which.
>  		 */
> -		if (	/* Filemark 0, ignore EOM, ILI 0, no sense */
> -				(srb->sense_buffer[2] & 0xaf) == 0 &&
> -			/* No ASC or ASCQ */
> -				srb->sense_buffer[12] == 0 &&
> -				srb->sense_buffer[13] == 0) {
> -
> +		if (sshdr.sense_key == 0 && sshdr.asc == 0 && sshdr.ascq == 0 &&
> +		    fm_ili == 0) {
>  			/* If things are really okay, then let's show that.
>  			 * Zero out the sense buffer so the higher layers
>  			 * won't realize we did an unsolicited auto-sense.
> @@ -814,7 +815,10 @@ Retry_Sense:
>  			 */
>  			} else {
>  				srb->result = DID_ERROR << 16;
> -				srb->sense_buffer[2] = HARDWARE_ERROR;
> +				if ((sshdr.response_code & 0x72) == 0x72)
> +					srb->sense_buffer[1] = HARDWARE_ERROR;
> +				else
> +					srb->sense_buffer[2] = HARDWARE_ERROR;
>  			}
>  		}
>  	}
> -- 
> Daniel J Blueman
