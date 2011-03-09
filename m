Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1CIQHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:07:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41901 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756843Ab1CIQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:07:14 -0500
Date: Wed, 9 Mar 2011 11:07:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <roger.quadros@nokia.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: gadget: storage: Add fsg_get_toc helper
In-Reply-To: <1299673300-16726-2-git-send-email-roger.quadros@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1103091057190.1965-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011, Roger Quadros wrote:

> fsg_get_toc can be used by both storage gadgets to build a CD-ROM
> Table of Contents which can be used as data for READ_TOC command.
> Currently fsg_get_toc supports two TOC formats, i.e.
> format 0: Formatted TOC and format 2: Raw TOC.
> 
> Raw TOC is required for CD-ROM emulation to work with Mac OS-X.
> 
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
> ---
>  drivers/usb/gadget/storage_common.c |   79 +++++++++++++++++++++++++++++++++++
>  1 files changed, 79 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index b015561..ffad1d9 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -655,6 +655,85 @@ static void store_cdrom_address(u8 *dest, int msf, u32 addr)
>  	}
>  }
>  
> +/*
> + * put_toc() - Builds a TOC with required format @format.
> + * @curlun: The LUN for which the TOC has to be built
> + * @msf: Min Sec Frame format or LBA format for address
> + * @format: TOC format code
> + * @buf: the buffer into which the TOC is built
> + *
> + * Builds a Table of Content which can be used as data for READ_TOC command.
> + * The TOC simulates a single session, single track CD-ROM mode 1 disc.
> + *
> + * Returns number of bytes written to @buf, -EINVAL if format not supported.
> + */
> +static int fsg_get_toc(struct fsg_lun *curlun, int msf, int format, u8 *buf)
> +{
> +	switch (format) {
> +	case 0:
> +		/* Formatted TOC */
> +		memset(buf, 0, 20);
> +		buf[1] = (20-2);	/* TOC data length */
> +		buf[2] = 1;		/* First track number */
> +		buf[3] = 1;		/* Last track number */
> +		buf[5] = 0x16;		/* Data track, copying allowed */
> +		buf[6] = 0x01;		/* Only track is number 1 */
> +		store_cdrom_address(&buf[8], msf, 0);
> +
> +		buf[13] = 0x16;		/* Lead-out track is data */
> +		buf[14] = 0xAA;		/* Lead-out track number */
> +		store_cdrom_address(&buf[16], msf, curlun->num_sectors);
> +		return 20;
> +		break;
> +
> +	case 2:
> +		/* Raw TOC */
> +		memset(buf, 0, 37);	/* Header + A0, A1 & A2 descriptors */
> +		buf[1] = 37;		/* 4 + 3*11 */

According to the SFF8020i spec Table 128, TOC Data Length is 2 + 11 *
(number of descriptors returned).  But that's probably a misprint.

> +		buf[2] = 1;		/* First complete session */
> +		buf[3] = 2;		/* Last complete session */

According to the spec, for drives that do not support multi-session, 
the First session number should be equal to the Last session number.


On Wed, 9 Mar 2011, Roger Quadros wrote:

> Mac OS-X expects CD-ROM TOC in raw format (i.e. format:2). It also
> sends the READ_TOC CDB in old style SFF8020i format. i.e. 2 format bits
> are encoded in MSBs of CDB byte 9.
> 
> This patch will enable CD-ROM emulation to work with Mac OS-X. Tested on
> Mac OS X v10.6.3.
> 
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
> ---
>  drivers/usb/gadget/file_storage.c |   32 +++++++++++++++++++-------------
>  1 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index a6eacb5..753ac94 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -1696,6 +1696,8 @@ static int do_read_toc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>  	int		msf = fsg->cmnd[1] & 0x02;
>  	int		start_track = fsg->cmnd[6];
>  	u8		*buf = (u8 *) bh->buf;
> +	u8		format;
> +	int		ret;
>  
>  	if ((fsg->cmnd[1] & ~0x02) != 0 ||		/* Mask away MSF */
>  			start_track > 1) {
> @@ -1703,18 +1705,22 @@ static int do_read_toc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>  		return -EINVAL;
>  	}
>  
> -	memset(buf, 0, 20);
> -	buf[1] = (20-2);		/* TOC data length */
> -	buf[2] = 1;			/* First track number */
> -	buf[3] = 1;			/* Last track number */
> -	buf[5] = 0x16;			/* Data track, copying allowed */
> -	buf[6] = 0x01;			/* Only track is number 1 */
> -	store_cdrom_address(&buf[8], msf, 0);
> +	/*
> +	 * Check if CDB is old style SFF-8020i
> +	 * i.e. format is in 2 MSBs of byte 9
> +	 * Mac OS-X host sends us this.
> +	 */
> +	format = (fsg->cmnd[9] >> 6) & 0x3;
> +	if (format == 0)
> +		format = fsg->cmnd[2] & 0xf;	/* new style MMC-2 */

The spec says: "Format field definition: When Format in Byte 2 is zero, 
then Byte 9 is used."  This logic does not follow that description.

Alan Stern

