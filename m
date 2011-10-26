Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab1JZNPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:15:30 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:42375 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932807Ab1JZNP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:15:27 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] hda_hwdep: Fix possible buffer overflow
Date: Wed, 26 Oct 2011 15:15:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.6-gentoo; KDE/4.6.5; x86_64; ; )
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <1319615292-27396-1-git-send-email-alexander.stein@systec-electronic.com> <s5hipnbsyd8.wl%tiwai@suse.de>
In-Reply-To: <s5hipnbsyd8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110261515.25189.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday 26 October 2011 14:58:43 Takashi Iwai wrote:
> At Wed, 26 Oct 2011 09:48:12 +0200,
> 
> Alexander Stein wrote:
> > If a line in the firmware file is larger than the given buffer size (and
> > so the firmware file size), size is set to a value larger than the actual
> > buffer size. This results in an overflow in the buffer passed.
> > Fix this by copying only up to 127 chars per line.
> 
> Actually this check should have been
> 
> 	if (size > fw->size)
> 		size = fw->size;
> 
> Otherwise it doesn't make sense.
> If the change is OK, could you resend the patch with it?

IMO this check isn't even needed. This case should be catched by this check

   for (len = 0; len < fw->size; len++) {

already.
Opinions?

Alexader

> > Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> > ---
> > 
> >  sound/pci/hda/hda_hwdep.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/sound/pci/hda/hda_hwdep.c b/sound/pci/hda/hda_hwdep.c
> > index bf3ced5..61da08d 100644
> > --- a/sound/pci/hda/hda_hwdep.c
> > +++ b/sound/pci/hda/hda_hwdep.c
> > @@ -745,6 +745,7 @@ static int parse_line_mode(char *buf, struct hda_bus
> > *bus)
> > 
> >   * if successfully copied a line
> >   *
> >   * the spaces at the beginning and the end of the line are stripped
> > 
> > + * lines read are clamped to 127 chars
> > 
> >   */
> >  
> >  static int get_line_from_fw(char *buf, int size, struct firmware *fw)
> >  {
> > 
> > @@ -756,8 +757,6 @@ static int get_line_from_fw(char *buf, int size,
> > struct firmware *fw)
> > 
> >  	}
> >  	if (!fw->size)
> >  	
> >  		return 0;
> > 
> > -	if (size < fw->size)
> > -		size = fw->size;
> > 
> >  	for (len = 0; len < fw->size; len++) {
> >  	
> >  		if (!*p)
> > 
> > @@ -768,7 +767,8 @@ static int get_line_from_fw(char *buf, int size,
> > struct firmware *fw)
> > 
> >  			break;
> >  		
> >  		}
> >  		if (len < size)
> > 
> > -			*buf++ = *p++;
> > +			*buf++ = *p;
> > +		p++;
> > 
> >  	}
> >  	*buf = 0;
> >  	fw->size -= len;
