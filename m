Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0DIGvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:51:43 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:12789
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0DIGvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:51:38 -0400
X-Trace: 197771711/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKtrvktTQwwf/2dsb2JhbACbO3K5CoUJBA
X-IronPort-AV: E=Sophos;i="4.52,176,1270422000"; 
   d="scan'208";a="197771711"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Ooops when working with USB MIDI (2.6.33.1)
Date: Fri, 9 Apr 2010 07:51:35 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <201004051433.47171.tvrtko@ursulin.net> <4BBDA92B.8010505@ladisch.de> <s5haateyvzn.wl%tiwai@suse.de>
In-Reply-To: <s5haateyvzn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004090751.35398.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 Apr 2010 13:22:36 Takashi Iwai wrote:
> > Takashi, do you remember what the original problem was?
> 
> Well, I have only a vague memory -- it's a similar scenario that some app
> still accessing after disconnection.  The URB can't be handled after
> the disconnection is finished.
> 
> I think the patch below might fix in this case.  You can try it
> instead of reverting the commit above.
> 
> 
> thanks,
> 
> Takashi
> 
> ---
> diff --git a/sound/usb/usbmidi.c b/sound/usb/usbmidi.c
> index 2c59afd..81c8d85 100644
> --- a/sound/usb/usbmidi.c
> +++ b/sound/usb/usbmidi.c
> @@ -986,6 +986,8 @@ static void snd_usbmidi_output_drain(struct
>  snd_rawmidi_substream *substream) DEFINE_WAIT(wait);
>  	long timeout = msecs_to_jiffies(50);
> 
> +	if (ep->umidi->disconnected)
> +		return;
>  	/*
>  	 * The substream buffer is empty, but some data might still be in the
>  	 * currently active URBs, so we have to wait for those to complete.
> @@ -1275,6 +1277,11 @@ void snd_usbmidi_disconnect(struct list_head* p)
>  			snd_usbmidi_in_endpoint_delete(ep->in);
>  			ep->in = NULL;
>  		}
> +		ep->active_urbs = 0;
> +		if (ep->drain_urbs) {
> +			ep->drain_urbs = 0;
> +			wake_up(&ep->drain_wait);
> +		}
>  	}
>  	del_timer_sync(&umidi->error_timer);
>  }

For the second hunk, do you think ep->out->... and so on? That would be more 
in-line with code present in 2.6.33.

Tvrtko
