Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1CIPKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:10:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57183 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757072Ab1CIPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:10:37 -0500
Date: Wed, 9 Mar 2011 10:10:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <roger.quadros@nokia.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: gadget: storage: Add fsg_get_toc helper
In-Reply-To: <1299673300-16726-2-git-send-email-roger.quadros@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1103091005570.1965-100000@iolanthe.rowland.org>
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

In addition to the things Sergei mentioned...

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

There's no reason to do it this way.  The compiler is a lot better than 
you are at addition.  Just put 4 + 3*11 in the assignment statement, 
and in the comment explain what the numbers mean.

> +		buf[2] = 1;		/* First complete session */
> +		buf[3] = 2;		/* Last complete session */
> +
> +		buf += 4;
> +		/* A0 point */
> +		buf[0] = 1;		/* Session number */
> +		buf[1] = 0x16;		/* Data track, copying alowed */
> +		/* 2 - Track number 0 -> TOC */
> +		buf[3] = 0xA0;		/* Point A0 */
> +		/* 4, 5, 6 - Min, sec, frame is zero */
> +		/* 7 - zero */
> +		buf[8] = 1;		/* Pmin: 1st track number */
> +		/* 9 - disc type 0: CD-ROM/DA with 1st track in mode 1 */
> +		/* 10 - pframe 0 */
> +
> +		buf += 11;
> +		/* A1 point*/
> +		buf[0] = 1;		/* Session number */
> +		buf[1] = 0x16;		/* Data track, copying alowed */
> +		/* 2 - Track number 0 -> TOC */
> +		buf[3] = 0xA1;		/* Point A1 */
> +		/* 4, 5, 6 - Min, sec, frame is zero */
> +		/* 7, zero */
> +		buf[8] = 1;		/* Pmin: last track number */
> +		/* 9, 10 - pmin and pframe are 0 */
> +
> +		buf += 11;
> +		/* A2 point*/
> +		buf[0] = 1;		/* Session number */
> +		buf[1] = 0x16;		/* Data track, copying alowed */
> +		/* 2 - Track number 0 -> TOC */
> +		buf[3] = 0xA2;		/* Point A2 */
> +		/* 4, 5, 6 - Min, sec, frame is zero */
> +		/* 7, 8, 9, 10 - zero, Pmin, Psec, Pframe of Lead out */
> +		store_cdrom_address(&buf[7], msf, curlun->num_sectors);

These things could be put into a loop, instead of a separate function.

> +		return 37;

It might be a good idea to use a variable instead of having all these 
"37"s floating around.  It would make future updates more reliable.

> +		break;
> +	default:
> +		/* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
> +		return -EINVAL;
> +		break;
> +	}
> +}

Alan Stern

