Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab2KNKou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:44:50 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:58013 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab2KNKos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:44:48 -0500
Message-ID: <50A3761C.6090101@parrot.com>
Date: Wed, 14 Nov 2012 11:44:44 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re : Re: Sound+USB: deadlock problem
References: <50A20429.3020109@suse.cz>	<s5ha9ulx5xe.wl%tiwai@suse.de>	<50A20512.10805@suse.cz>	<s5h7gppx568.wl%tiwai@suse.de>	<50A21542.2090102@suse.cz> <s5hy5i5iz97.wl%tiwai@suse.de>
In-Reply-To: <s5hy5i5iz97.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A deadlock was detected with this patch. You need the following patch [1]


Matthieu


> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Takashi Iwai <tiwai@suse.de>
> 
> commit 34f3c89fda4fba9fe689db22253ca8db2f5e6386 upstream.
> 
> Replace mutex with rwsem for codec->shutdown protection so that
> concurrent accesses are allowed.
> 
> Also add the protection to snd_usb_autosuspend() and
> snd_usb_autoresume(), too.
> 
> Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  sound/usb/card.c     | 12 ++++++++----
>  sound/usb/mixer.c    | 12 ++++++------
>  sound/usb/pcm.c      | 12 ++++++------
>  sound/usb/usbaudio.h |  2 +-
>  4 files changed, 21 insertions(+), 17 deletions(-)



[1]

Takashi Iwai a écrit :
> At Tue, 13 Nov 2012 10:39:14 +0100,
> Jiri Slaby wrote:
>> On 11/13/2012 09:45 AM, Takashi Iwai wrote:
>>> At Tue, 13 Nov 2012 09:30:10 +0100,
>>> Jiri Slaby wrote:
>>>> On 11/13/2012 09:28 AM, Takashi Iwai wrote:
>>>>> At Tue, 13 Nov 2012 09:26:17 +0100,
>>>>> Jiri Slaby wrote:
>>>>>> Hello,
>>>>>>
>>>>>> I've just plugged+unplugged+plugged my USB audio card and the audio
>>>>>> subsystem got stuck:
>>>>> Which kernel?  If it's older than 3.7-rc5, could you try 3.7-rc5?
>>>> Oh, forgot to mention:
>>>> 3.7.0-rc5-next-20121112_64+
>>> Through a quick glance, one of mutex locks seems stuck.
>>> Just a blind short -- does the patch below cure the problem?
>> Yes, this helps.
>>
>> Adding a LOCKDEP splash _before_ applying the patch:
> 
> Thanks, this helps much for understanding the cause.
> It's a new rwsem in the usb-audio driver that deadlocks.
> 
> Although the previous patch fixes the deadlock it opens the race
> again. 
> 
> Could you try the patch below instead?  The rwsem above doesn't have
> to be taken for the whole operation, but just needs to protect for
> turning on the flag.  The patch below should suffice for protecting
> races but avoids the deadlock.
> 
> 
> Takashi
> 
> ---
> diff --git a/sound/usb/card.c b/sound/usb/card.c
> index 282f0fc..dbf7999 100644
> --- a/sound/usb/card.c
> +++ b/sound/usb/card.c
> @@ -559,9 +559,11 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
>  		return;
>  
>  	card = chip->card;
> -	mutex_lock(&register_mutex);
>  	down_write(&chip->shutdown_rwsem);
>  	chip->shutdown = 1;
> +	up_write(&chip->shutdown_rwsem);
> +
> +	mutex_lock(&register_mutex);
>  	chip->num_interfaces--;
>  	if (chip->num_interfaces <= 0) {
>  		snd_card_disconnect(card);
> @@ -582,11 +584,9 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
>  			snd_usb_mixer_disconnect(p);
>  		}
>  		usb_chip[chip->index] = NULL;
> -		up_write(&chip->shutdown_rwsem);
>  		mutex_unlock(&register_mutex);
>  		snd_card_free_when_closed(card);
>  	} else {
> -		up_write(&chip->shutdown_rwsem);
>  		mutex_unlock(&register_mutex);
>  	}
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

