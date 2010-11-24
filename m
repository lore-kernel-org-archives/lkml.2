Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0KXJCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:02:32 -0500
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:27759 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752392Ab0KXJCa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:02:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ideHyPYqWTai4Gg9YFErcEGYCCzR8q6Kwknkuja+yc6KdKsL57MvjNf7P6mgVywq/EcrzjsfoJFX9JpWCA9SSImHV9BRNo3S3xftj3fdbgJVmKcYbhQgMdhqj9BhqXqIkKkxUKkVSG5kIONcENRSS5FoYmLy/BQ6hNoCiVzO7VM=;
Message-ID: <549123.75632.qm@web31809.mail.mud.yahoo.com>
X-YMail-OSG: EYbwJ5sVM1n7YTjhUFPMcCmxrBGmagXgAAEm8J4mamLkg2w
 vBGlwYYL1r_RFq8XXn3gH0f8LrQ1KSCi3mC5AYHiUhN90aZsdLU.w53Ocyhz
 Bbqu5uNoRMWzZ.8eHmdjdYjcyUgMPJ4w53benNM.ByoNRk.wAGh8TuiWIEqq
 41aQj3GbgI1FjpF80Db6cbzTyOjvnOmQT.yatJkQbLUvP9zKeCXaCdi3GaoP
 WDtFgFYCK7EbEPUVSsf99L47kCOVUFnAffEe1QcsG9QJ_aYoPMs_ivEdskQl
 s2mjDFybPPBin7AIqI_X8MBk_c6ceBrm0Z5mD2ciKul5fbYYlnLZSh.gkryo
 H31gXC2SAXtOTi9ZDsyDwQ6RoRvMq7EPGqfHU
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Wed, 24 Nov 2010 01:02:28 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20101123143026.GM20296@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 11/23/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:

> Not really.  In your example case of the write-protect
> bit, either the
> device would be improperly marked as write-protected when
> it is not, or we
> would improperly send write commands to a protected
> device.  Neither is a
> great tradgedy; commands will fail, errors will be
> generated, and life will
> go on.

Yes, indeed.

> However, I don't know what is in the Caching Mode
> Page.

It's described in SBC-3.

> I don't know how
> those bits are used to determine the behavior of the rest
> of the kernel.

I see.

> Maybe one of those bits means "only store data in Japanese"
> or something
> equally disturbing.

I doubt it. (And I don't find that disturbing.)

> The old code used to make a "safe" default choice if the
> caching mode page
> was not available (for whatever
> reason).   What are the implications of not
> making the "safe" choice improperly (due to mode page
> corruption)?

Let's see... the old code made the ``"safe" default choice'' of believing that the write cache is disabled and will thus never synchronize the cache, i.e. send SYNCHRONIZE CACHE command, reading drivers/scsi/sd.c. It also believes that the read cache is enabled, harmless as it is not used by the kernel. It also assumes that DPOFUA is not supported and will thus never set FUA in the CDB, in sd_revalidate_disk() (blk dev ops).

Quoting you, s/write commands/cdbs with FUA set or SYNCHRONIZE CACHE command/g:

> we
> would improperly send write commands to a protected
> device.  Neither is a
> great tradgedy; commands will fail, errors will be
> generated, and life will
> go on.

But I believe the discussion has gone astray. Bringing it back to the original topic:

I doubt this as very unlikely. Has anyone actually seen a device that sends mode parameter data with faux Caching mode page or corrupted data that is in fact interpreted as a Caching mode page? Is such a device fully operational sans the faux Caching mode page, or does it just not work? Is it common to have devices having a faux Caching mode page or corrupted mode parameter data resulting in a Caching mode page with random data?

Undoubtedly, as the usb-storage maintainer, you must have variety of devices, some broken some not. Could you apply this patch to your tree and test some of the devices you have? My tests indicate a stable behavior.

    Luben

