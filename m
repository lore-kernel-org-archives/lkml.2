Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0DIHTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 03:19:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50365 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab0DIHTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 03:19:36 -0400
X-Sasl-enc: q2J/vbfXRhNgalfyjzfs+2JIVoTCm/B71oqLF6LMPQ5E 1270797575
Message-ID: <4BBED506.40907@ladisch.de>
Date: Fri, 09 Apr 2010 09:19:34 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Ooops when working with USB MIDI (2.6.33.1)
References: <201004051433.47171.tvrtko@ursulin.net> <4BBDA92B.8010505@ladisch.de> <s5haateyvzn.wl%tiwai@suse.de> <201004090751.35398.tvrtko@ursulin.net>
In-Reply-To: <201004090751.35398.tvrtko@ursulin.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
> On Thursday 08 Apr 2010 13:22:36 Takashi Iwai wrote:
> > > Takashi, do you remember what the original problem was?
> > 
> > Well, I have only a vague memory -- it's a similar scenario that some app
> > still accessing after disconnection.  The URB can't be handled after
> > the disconnection is finished.
> > 
> > I think the patch below might fix in this case.  You can try it
> > instead of reverting the commit above.
> > 
> > --- a/sound/usb/usbmidi.c
> > +++ b/sound/usb/usbmidi.c
> > @@ -986,6 +986,8 @@ static void snd_usbmidi_output_drain(struct
> >  snd_rawmidi_substream *substream) DEFINE_WAIT(wait);
> >  	long timeout = msecs_to_jiffies(50);
> > 
> > +	if (ep->umidi->disconnected)
> > +		return;
> > ...
> > @@ -1275,6 +1277,11 @@ void snd_usbmidi_disconnect(struct list_head* p)
> >  			snd_usbmidi_in_endpoint_delete(ep->in);
> >  			ep->in = NULL;
> >  		}
> > +		ep->active_urbs = 0;
> > +		if (ep->drain_urbs) {
> > +			ep->drain_urbs = 0;
> > +			wake_up(&ep->drain_wait);
> > +		}
> 
> For the second hunk, do you think ep->out->... and so on? That would be more 
> in-line with code present in 2.6.33.

ep->out has been just freed.  And in the first hunk, in _drain, the ep
pointer is the same as ep->out in _disconnect.

In _disconnect, we must not free ep->in and ep->out because those
structures might still be accessed by all the functions called from
user space.

I'll write separate disconnect functions for the endpoint structures
when I find time.


Regards,
Clemens
