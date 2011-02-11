Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1BKJyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:54:32 -0500
Received: from t111.niisi.ras.ru ([193.232.173.111]:36958 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab1BKJya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:54:30 -0500
Date: Fri, 11 Feb 2011 13:00:21 +0300
From: "Antony N. Pavlov" <antony@niisi.msk.ru>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: fix sector erase command for
 AM29LV040B
Message-Id: <20110211130021.a05a37ec.antony@niisi.msk.ru>
In-Reply-To: <20110210214131.GA6561@pengutronix.de>
References: <1297371877-32123-1-git-send-email-antony@niisi.msk.ru>
	<20110210214131.GA6561@pengutronix.de>
Organization: NIISI
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 22:41:31 +0100
Wolfram Sang <w.sang@pengutronix.de> wrote:

Thank you for your quick response.

> On Fri, Feb 11, 2011 at 12:04:37AM +0300, Antony Pavlov wrote:
> > The AM29LV040B chips use 0x50 as sector erase command instead of 0x30 [1].
> > 
> > [1] http://www.datasheetcatalog.com/datasheets_pdf/A/M/2/9/AM29LV040B.shtml
> 
> I am confused. The datasheet says on page 15 it uses 0x30 while your
> description above says it uses 0x50...

It is my mistake! Of course it uses 0x30.

> > Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>
> > ---
> >  drivers/mtd/chips/cfi_cmdset_0002.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> > index f072fcf..a401dbe 100644
> > --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> > +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> > @@ -332,6 +332,14 @@ static void fixup_s29gl032n_sectors(struct mtd_info *mtd)
> >  	}
> >  }
> >  
> > +static void fixup_use_sector_erase_cmd_30(struct mtd_info *mtd)
> > +{
> > +	struct map_info *map = mtd->priv;
> > +	struct cfi_private *cfi = map->fldrv_priv;
> > +
> > +	cfi->sector_erase_cmd = CMD(0x30);
> cfi_chip_setup
> ... but here you change it to 0x30 (which is the default) instead of 0x50?
> 

In the commit 08968041bef437ec363623cd3218c2b083537ada
 (mtd: cfi_cmdset_0002: make sector erase command variable)
introdused field sector_erase_cmd. In this commit initialisation
of cfi->sector_erase_cmd made in cfi_chip_setup()
(file drivers/mtd/chips/cfi_probe.c), so the CFI chip has no problem:

...
        cfi->cfi_mode = CFI_MODE_CFI;
        cfi->sector_erase_cmd = CMD(0x30);
...

But for the JEDEC chips this initialisation is not carried out.
In my case (AM29LV040B) I have sector_erase_cmd == 0.

I shall send the patch in a few seconds.

-- 
Best regards,
  Antony Pavlov
