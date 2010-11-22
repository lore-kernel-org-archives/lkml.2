Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0KVUCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:02:31 -0500
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:43723 "HELO
	web31803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757456Ab0KVUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:02:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=zUV1PoXUcZ6RTs6jyPZsLcVVc3nDqIFSmocBSQFelvrufGo2TNefnr22vHA/jZBIqPYjGc3wC1BbzS3Jz7W/7JHL2oqNATWaURmOSlFw+ql8FMeSCAH4GPX4qOZfIRJcKjiV9/QLW7JTwVBlUxnPuULi8DiPSGikPylefEZms88=;
Message-ID: <538170.68988.qm@web31803.mail.mud.yahoo.com>
X-YMail-OSG: 6iZonlsVM1mBzDTKVHDN7R_sDeyd9xiJ13_YlikN2gBJ.2F
 SEK.eB.hmzwoGWLmreCuPVEa6Hih6wZWDUwRp0xp3ATNN5kStKyeRi2tqSR2
 JyKYNhCDhK0GD5EPZKEtvkrAIpNES0nutmCwJ.Jiq4g52WETkYOBbeFi2KxP
 qcFjQVORU1vOOZizk9wJu8ee36AiQLuqQYfGa6whoQvMzzdj8ED9S..4fyzO
 kNCNO0eCMF9BWmjm8MZYRRZtCd21YDuokAYFOwNnptzmtZZBkCECnN1DexyX
 PcpQqwIjloybGA1_4ItrPE9DN3uAYVOdtDrvNr6V7R9H4Tg9MYGGWpnX05M3
 yhn8bLEjeVvyaNhsFF3bkOrZ0LIGGRklZ9JqonDPeP2WIjhjtWm2uwWlNdXU
 -
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 22 Nov 2010 12:02:26 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/22/10, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > Some kernel transport drivers unconditionally disable
> > retrieval of the Caching mode page. One such for
> example is
> > the BBB/CBI transport over USB.
> 
> One reason for that is that historically we've seen devices
> that
> simply go crazy - to the point of simply stopping to
> respond to
> anything - when you ask for pages that Windows doesn't ask
> for.
> 
> It's especially common on USB storage, but it happens
> elsewhere too.
> The device firmware simply hasn't ever been tested in that
> situation,
> and it's buggy.
> 
> So I don't mind the patch per se, but I think it's
> potentially way
> more dangerous than it looks.

This patch does not ask for pages that Windows doesn't ask for. The sd driver already asks for all pages (page code 0x3F) and then checks if the device is write protected. Here is the present code:

  2217                  sd_read_write_protect_flag(sdkp, buffer);
  2218                  sd_read_cache_type(sdkp, buffer);
  2219                  sd_read_app_tag_own(sdkp, buffer);

Line 2217 asks for page code 0x3F, meaning all mode pages.
Line 2218 asks for the Caching mode page or not at all if the device flags forbid it (all USB storage devices in the Linux kernel).

This patch adds processing of the data returned when all mode pages are asked for (0x3F) in the function on line 2218. It then parses the data to find out if the Caching mode page is present.

   Luben

