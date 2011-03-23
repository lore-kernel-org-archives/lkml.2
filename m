Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1CWOHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:07:16 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:50609 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1CWOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:07:14 -0400
Subject: Re: [PATCH v2] sound/oss: remove offset from load_patch callbacks
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, alsa-devel@alsa-project.org, security@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <s5hhbauc4zs.wl%tiwai@suse.de>
References: <1300888042.1968.7.camel@dan>  <s5hhbauc4zs.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 10:06:22 -0400
Message-ID: <1300889182.1968.13.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 14:59 +0100, Takashi Iwai wrote:
> At Wed, 23 Mar 2011 09:47:22 -0400,
> Dan Rosenberg wrote:
> > --- a/sound/oss/midi_synth.c
> > +++ b/sound/oss/midi_synth.c
> > @@ -508,16 +506,15 @@ midi_synth_load_patch(int dev, int format, const char __user *addr,
> >  	 * been transferred already.
> >  	 */
> >  
> > -	if(copy_from_user(&((char *) &sysex)[offs], &(addr)[offs], hdr_size - offs))
> > +	if (copy_from_user(&sysex, addr, hdr_size))
> 
> Please correct the comment in the above as well.
> With this change, the transfer is no longer partial.

Will do.

> 
> > --- a/sound/oss/opl3.c
> > +++ b/sound/oss/opl3.c
> ...
> > @@ -834,7 +834,7 @@ static int opl3_load_patch(int dev, int format, const char __user *addr,
> >  	 * What the fuck is going on here?  We leave junk in the beginning
> >  	 * of ins and then check the field pretty close to that beginning?
> >  	 */
> > -	if(copy_from_user(&((char *) &ins)[offs], addr + offs, sizeof(ins) - offs))
> > +	if (copy_from_user(&ins, addr, sizeof(ins)))
> 
> Ditto.

Likewise.

> 
> >  		return -EFAULT;
> >  
> >  	if (ins.channel < 0 || ins.channel >= SBFM_MAXINSTR)
> > diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
> > index 5ea1098..2e842cb 100644
> > --- a/sound/oss/sequencer.c
> > +++ b/sound/oss/sequencer.c
> > @@ -241,7 +241,7 @@ int sequencer_write(int dev, struct file *file, const char __user *buf, int coun
> >  				return -ENXIO;
> >  
> >  			fmt = (*(short *) &event_rec[0]) & 0xffff;
> > -			err = synth_devs[dev]->load_patch(dev, fmt, buf, p + 4, c, 0);
> > +			err = synth_devs[dev]->load_patch(dev, fmt, buf, c, 0);
> 
> The address must be "buf + p + 4" instead of "buf", when you omit the
> offset argument.
> 

Are you sure?  Previously, the copy of the header was from (buf + p + 4)
to (dst + p + 4) with length (hdr_size - (p + 4)), and now the copy is
from buf to dst with length hdr_size.  If I do as you suggest, then the
copy will be from (buf + p + 4) to dst for the header.

-Dan

> 
> thanks,
> 
> Takashi


