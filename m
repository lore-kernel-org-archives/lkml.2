Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1GaVQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 17:16:50 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10251 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1GaVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 17:16:45 -0400
Date: Sun, 31 Jul 2011 23:16:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Takashi Iwai <tiwai@suse.de>
cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Joe Perches <joe@perches.com>,
        Eliot Blennerhassett <eblennerhassett@audioscience.com>,
        Jaroslav Kysela <perex@perex.cz>, support@audioscience.com
Subject: Re: [PATCH] Sound: AudioScience HPI: Don't leak firmware if mem
 alloc fails
In-Reply-To: <alpine.LNX.2.00.1107291106300.22532@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107312313360.28695@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107282145230.20477@swampdragon.chaosbits.net> <s5hpqkt6425.wl%tiwai@suse.de> <alpine.LNX.2.00.1107291106300.22532@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Jesper Juhl wrote:

> On Fri, 29 Jul 2011, Takashi Iwai wrote:
> 
> > At Thu, 28 Jul 2011 21:48:27 +0200 (CEST),
> > Jesper Juhl wrote:
> > > 
> > > We leak the memory allocated to 'firmware' when we fail to
> > > release_firmware() after a kmalloc() failure in hpi_dsp_code_open().
> > > This patch should take care of the leak.
> > > 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > ---
> > >  sound/pci/asihpi/hpidspcd.c |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > 
> > > 	Build tested only.
> > > 
> > > diff --git a/sound/pci/asihpi/hpidspcd.c b/sound/pci/asihpi/hpidspcd.c
> > > index 3a7afa3..8d261ef 100644
> > > --- a/sound/pci/asihpi/hpidspcd.c
> > > +++ b/sound/pci/asihpi/hpidspcd.c
> > > @@ -85,8 +85,10 @@ short hpi_dsp_code_open(u32 adapter, void *os_data, struct dsp_code *dsp_code,
> > >  
> > >  	HPI_DEBUG_LOG(DEBUG, "dsp code %s opened\n", fw_name);
> > >  	dsp_code->pvt = kmalloc(sizeof(*dsp_code->pvt), GFP_KERNEL);
> > > -	if (!dsp_code->pvt)
> > > +	if (!dsp_code->pvt) {
> > > +		release_firmware(firmware);
> > >  		return HPI_ERROR_MEMORY_ALLOC;
> > > +	}
> > 
> > IMO, it's better to use the same error handling like others, i.e.
> > "goto error2".  But you want to pass a different error code, so we'd
> > need to introduce an error code variable there...
> > 
> Thank you for the feedback. I'll cook up a better patch tonight.
> 
> 

Sorry about the delay - had non-computer things to attend to.

I hope this is more to your liking :-)


From: Jesper Juhl <jj@chaosbits.net>

We leak the memory allocated to 'firmware' when we fail to
release_firmware() after a kmalloc() failure in hpi_dsp_code_open().
This patch should take care of the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/asihpi/hpidspcd.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/pci/asihpi/hpidspcd.c b/sound/pci/asihpi/hpidspcd.c
index 3a7afa3..71d32c8 100644
--- a/sound/pci/asihpi/hpidspcd.c
+++ b/sound/pci/asihpi/hpidspcd.c
@@ -43,6 +43,7 @@ short hpi_dsp_code_open(u32 adapter, void *os_data, struct dsp_code *dsp_code,
 	struct pci_dev *dev = os_data;
 	struct code_header header;
 	char fw_name[20];
+	short err_ret = HPI_ERROR_DSP_FILE_NOT_FOUND;
 	int err;
 
 	sprintf(fw_name, "asihpi/dsp%04x.bin", adapter);
@@ -85,8 +86,10 @@ short hpi_dsp_code_open(u32 adapter, void *os_data, struct dsp_code *dsp_code,
 
 	HPI_DEBUG_LOG(DEBUG, "dsp code %s opened\n", fw_name);
 	dsp_code->pvt = kmalloc(sizeof(*dsp_code->pvt), GFP_KERNEL);
-	if (!dsp_code->pvt)
-		return HPI_ERROR_MEMORY_ALLOC;
+	if (!dsp_code->pvt) {
+		err_ret = HPI_ERROR_MEMORY_ALLOC;
+		goto error2;
+	}
 
 	dsp_code->pvt->dev = dev;
 	dsp_code->pvt->firmware = firmware;
@@ -99,7 +102,7 @@ error2:
 	release_firmware(firmware);
 error1:
 	dsp_code->block_length = 0;
-	return HPI_ERROR_DSP_FILE_NOT_FOUND;
+	return err_ret;
 }
 
 /*-------------------------------------------------------------------*/
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

