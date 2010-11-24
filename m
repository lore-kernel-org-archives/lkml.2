Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0KXQzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:55:06 -0500
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:47228 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755246Ab0KXQzF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:55:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=X1An7U6sNjwFQCKub3wntJKgIDBIevt//p67+9pB1xoKTw/7K8lBThpzoAjVo+1/3t1/UL3gjzThS6zrzqdZ+Hpm4X4WUyfn+7QNwl1g4x4pOaom1sXzaxqHZl+x6DcJrMk9oBeXVvDz8YLrRxhtcmUiy4zu1yDHiw41R55oLyg=;
Message-ID: <447417.38293.qm@web31807.mail.mud.yahoo.com>
X-YMail-OSG: RXKcxXYVM1ly8wWLS0H.i4vDq4xxkfwwTUJX_bxLqP2c0r_
 AooBwhKvB0m7YEQGHmTl7_9z7wliS01nOmrpAuyMuuLmaiZIeWn1kuvAXsmb
 AW7kEyQNHarTYvPc7eSjcRG.Uo.bmUUVH4aAHsQFhTIOBDRk3_mEj4_xCvm_
 cPm_B.JDVL1qHrtXlJ8bVuAbPOc9DiAvVjC_aRKsaZ5tURuFlcgZWOZum.oL
 kWd3tPevXXDLE.XY7dqs6NRnJhvrOUTLkr_y_Tz7hOE2FTLWLw.wbsesAAmi
 5l8oDkKOwBA_7hxUv_T9YVZOYr46sxvjT3wjl_Fntl9pOcTOy2S9kI4NSDe5
 sURCyhJHNwkOPFBuNaYbfzqjEA20UlAkvnzBly7XO.w--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Wed, 24 Nov 2010 08:55:02 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
To: James Bottomley <James.Bottomley@suse.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <1290593429.14652.33.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 11/24/10, James Bottomley <James.Bottomley@suse.de> wrote:

> The basic problem isn't devices lying ... the worst we'll
> do is current
> behaviour (not SYNC when we should).  The problem is
> devices that get
> confused (or worse simply crash the firmware).  The
> best way to avoid
> the crashing firmware problem ... if we can assume that
> modern USB
> devices are better is to key off the SCSI version. 
> Unfortunately, in
> spite of several attempts, we've never managed to stop
> usbstorage lying
> about this:
> 
>         /* Some devices
> report a SCSI revision level above 2 but are
>          * unable
> to handle the REPORT LUNS command (for which
>          * support
> is mandatory at level 3).  Since we already have
>          * a
> Get-Max-LUN request, we won't lose much by setting the
>          * revision
> level down to 2.  The only devices that would be
>          * affected
> are those with sparse LUNs. */
>         if
> (sdev->scsi_level > SCSI_2)
>            
> sdev->sdev_target->scsi_level =
>            
>         sdev->scsi_level =
> SCSI_2;
> 
> Untangling all of this would be rather complex, I fear.

CBI/BBB isn't supposed to be, nor is designed to support SAM-modern devices. So while REQUEST LUN /may/ work on some devices which implement it in their firmware, it is NOT a requirement for those devices as they are not required to adhere to any SAM version. Those transport protocols define a class-specific request to get the maximum LUN, and another to reset the target port (instead of I_T Reset or LU Reset). They also do not support SCSI Status completion of the command, nor Autosense. They also do not provide TMFs. They provide none of the SCSI transport protocol services in support of the Execute Command procedure call. The SCSI layer shouldn't be trying to guess their "SCSI version", and or treat them as real SCSI devices sending REPORT LUNs, etc. commands.

Newer, modern transport protocols over USB, are part of SAM, and it is devices who connect via those protocols that are being disadvantaged, due to the adoption (assumption) of CBI/BBB well into the SCSI layer.

To this effect, the transport protocol can tell upper layers if the device is true SCSI (new usb transports or other) or hybrid (usb-storage). In the former case, the device is a SCSI device, in the latter, only basic commands should be attempted.

This isn't to say that firmware for those devices wouldn't be buggy. Of course it will, and most will probably port their legacy FW over to the new SPTL, but the protocol requirements are there by design (i.e. there is no longer Get Max Lun class-specific request, the application client has to send REPORT LUNS, and FW has to answer it) and we have to accommodate that.

It is in this spirit that this patch doesn't change wire behavior, but simply parses data returned by a command already supported by older protocols.

     Luben

