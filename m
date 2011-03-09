Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1CINm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:42:29 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59362 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab1CINm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:42:27 -0500
Message-ID: <4D77836D.30009@ru.mvista.com>
Date: Wed, 09 Mar 2011 16:41:01 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roger Quadros <roger.quadros@nokia.com>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <1299673300-16726-1-git-send-email-roger.quadros@nokia.com> <1299673300-16726-2-git-send-email-roger.quadros@nokia.com>
In-Reply-To: <1299673300-16726-2-git-send-email-roger.quadros@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-03-2011 15:21, Roger Quadros wrote:

> fsg_get_toc can be used by both storage gadgets to build a CD-ROM
> Table of Contents which can be used as data for READ_TOC command.
> Currently fsg_get_toc supports two TOC formats, i.e.
> format 0: Formatted TOC and format 2: Raw TOC.

> Raw TOC is required for CD-ROM emulation to work with Mac OS-X.

> Signed-off-by: Roger Quadros<roger.quadros@nokia.com>
> ---
>   drivers/usb/gadget/storage_common.c |   79 +++++++++++++++++++++++++++++++++++
>   1 files changed, 79 insertions(+), 0 deletions(-)

> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index b015561..ffad1d9 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -655,6 +655,85 @@ static void store_cdrom_address(u8 *dest, int msf, u32 addr)
>   	}
>   }
>
> +/*

    The kerneldoc comments should start with "/**".

> + * put_toc() - Builds a TOC with required format @format.

    The function is called gsg_get_toc, isn't it?

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

    Parens not needed here. And kernel style assumes putting spacves around 
operators.

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
> +		memset(buf, 0, 37);	/* Header + A0, A1&  A2 descriptors */
> +		buf[1] = 37;		/* 4 + 3*11 */
> +		buf[2] = 1;		/* First complete session */
> +		buf[3] = 2;		/* Last complete session */
> +
> +		buf += 4;
> +		/* A0 point */
> +		buf[0] = 1;		/* Session number */
> +		buf[1] = 0x16;		/* Data track, copying alowed */
> +		/* 2 - Track number 0 ->  TOC */
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
> +		/* 2 - Track number 0 ->  TOC */
> +		buf[3] = 0xA1;		/* Point A1 */
> +		/* 4, 5, 6 - Min, sec, frame is zero */
> +		/* 7, zero */
> +		buf[8] = 1;		/* Pmin: last track number */
> +		/* 9, 10 - pmin and pframe are 0 */

    The above code is repetitive -- might be worth factoring out into a function.

> +
> +		buf += 11;
> +		/* A2 point*/
> +		buf[0] = 1;		/* Session number */
> +		buf[1] = 0x16;		/* Data track, copying alowed */
> +		/* 2 - Track number 0 ->  TOC */
> +		buf[3] = 0xA2;		/* Point A2 */
> +		/* 4, 5, 6 - Min, sec, frame is zero */
> +		/* 7, 8, 9, 10 - zero, Pmin, Psec, Pframe of Lead out */
> +		store_cdrom_address(&buf[7], msf, curlun->num_sectors);
> +		return 37;
> +		break;
> +	default:
> +		/* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
> +		return -EINVAL;
> +		break;
> +	}
> +}
> +

    OK, but where this function is called from?

WBR, Sergei
