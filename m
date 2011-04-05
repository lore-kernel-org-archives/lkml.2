Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1DEPp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:45:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62511 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1DEPpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=PbIOVbY7OdyX7ttcGHBxh0SCmflvICjHKyHhYALCob4dn93Fv1jLhyKgJ8DlNs5tYH
         Manmtm6EyUPMV5lax7kO7JQtpcTmxw1rWCBxhuGsz31rORnc8QOJJE1aOTIzbcw/9i2N
         jKY/OOIUvB0ee6evPaloP5nnUKgRAsQy6hGG0=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: stern@rowland.harvard.edu, sshtylyov@mvista.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
 <1302015569-9668-3-git-send-email-roger.quadros@nokia.com>
Date: Tue, 05 Apr 2011 17:45:50 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vtg12opj3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302015569-9668-3-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 16:59:28 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -1703,18 +1705,21 @@ static int do_read_toc(struct fsg_dev *fsg,  
> struct fsg_buffhd *bh)
>  		return -EINVAL;
>  	}
> -	memset(buf, 0, 20);
> -	buf[1] = (20-2);		/* TOC data length */
> -	buf[2] = 1;			/* First track number */
> -	buf[3] = 1;			/* Last track number */
> -	buf[5] = 0x16;			/* Data track, copying allowed */
> -	buf[6] = 0x01;			/* Only track is number 1 */
> -	store_cdrom_address(&buf[8], msf, 0);
> +	format = fsg->cmnd[2] & 0xf;
> +	/*
> +	 * Check if CDB is old style SFF-8020i
> +	 * i.e. format is in 2 MSBs of byte 9
> +	 * Mac OS-X host sends us this.
> +	 */
> +	if (format == 0)
> +		format = (fsg->cmnd[9] >> 6) & 0x3;
> -	buf[13] = 0x16;			/* Lead-out track is data */
> -	buf[14] = 0xAA;			/* Lead-out track number */
> -	store_cdrom_address(&buf[16], msf, curlun->num_sectors);
> -	return 20;
> +	ret = fsg_get_toc(curlun, msf, format, buf);
> +	if (ret < 0) {
> +		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
> +		return -EINVAL;
> +	}

I'd drop the “return -EINVAL;” and let “return ret;” below handle it.
This obviously also apply to patch to f_mass_storage.c (BTW. I would
merge the two patches).

> +	return ret;
>  }

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
