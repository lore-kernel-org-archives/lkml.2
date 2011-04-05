Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1DEPn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:43:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53777 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1DEPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=qNCi1pFG9msmga+HliLXwD5M/FeWqbKkpPBEJQtY/e07ZRkMVPwTAV+plSGv8i6mSv
         pPnAtmW7+LG7Zo8YP1/DLRhjcqG0qWMJCGDiOhmNyypmnhdSZy73BwdIfzVf6fCN0saC
         kMeWx4xGNb+AR7jjdYdumG4JC20zb9cJ7JPzQ=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: stern@rowland.harvard.edu, sshtylyov@mvista.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
 <1302015569-9668-2-git-send-email-roger.quadros@nokia.com>
Date: Tue, 05 Apr 2011 17:43:20 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vtg1yhef3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302015569-9668-2-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 16:59:27 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c

> +static int fsg_get_toc(struct fsg_lun *curlun, int msf, int format, u8  
> *buf)
> +{
> +	int i, len;
> +	switch (format) {
> +	case 0:
> +		/* Formatted TOC */
> +		len = 4 + 2*8;		/* 4 byte header + 2 descriptors */
> +		memset(buf, 0, len);
> +		buf[1] = len - 2;	/* TOC Length excludes length field */
> +		buf[2] = 1;		/* First track number */
> +		buf[3] = 1;		/* Last track number */
> +		buf[5] = 0x16;		/* Data track, copying allowed */
> +		buf[6] = 0x01;		/* Only track is number 1 */
> +		store_cdrom_address(&buf[8], msf, 0);
> +
> +		buf[13] = 0x16;		/* Lead-out track is data */
> +		buf[14] = 0xAA;		/* Lead-out track number */
> +		store_cdrom_address(&buf[16], msf, curlun->num_sectors);
> +		return len;
> +		break;

Useless break.  Or, you could put "return len;" at the end of the function.

> +
> +	case 2:
> +		/* Raw TOC */
> +		len = 4 + 3*11;		/* 4 byte header + 3 descriptors */
> +		memset(buf, 0, len);	/* Header + A0, A1 & A2 descriptors */
> +		buf[1] = len - 2;	/* TOC Length excludes length field */
> +		buf[2] = 1;		/* First complete session */
> +		buf[3] = 1;		/* Last complete session */
> +
> +		buf += 4;
> +		/* fill in A0, A1 and A2 points */
> +		for (i = 0; i < 3; i++) {
> +			buf[0] = 1;	/* Session number */
> +			buf[1] = 0x16;	/* Data track, copying allowed */
> +			/* 2 - Track number 0 ->  TOC */
> +			buf[3] = 0xA0 + i; /* A0, A1, A2 point */
> +			/* 4, 5, 6 - Min, sec, frame is zero */
> +			buf[8] = 1;	/* Pmin: last track number */
> +			buf += 11;	/* go to next track descriptor */
> +		}
> +		buf -= 11;		/* go back to A2 descriptor */
> +
> +		/* For A2, 7, 8, 9, 10 - zero, Pmin, Psec, Pframe of Lead out */
> +		store_cdrom_address(&buf[7], msf, curlun->num_sectors);
> +		return len;
> +		break;

Same here.

> +	default:
> +		/* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
> +		return -EINVAL;

Can we fall back to the old behaviour here?

> +		break;

And here.

> +	}
> +}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
