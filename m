Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2KHHbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:31:42 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38687 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2KHHbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:31:39 -0500
Message-ID: <509B5FD7.3010609@gmail.com>
Date: Thu, 08 Nov 2012 08:31:35 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Christof Meerwald <cmeerw@cmeerw.org>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
References: <20121105191336.GA1404@edge.cmeerw.net> <Pine.LNX.4.44L0.1211071220230.1175-100000@iolanthe.rowland.org> <s5hzk2tfcg8.wl%tiwai@suse.de> <509B0013.6080508@gmail.com> <s5hwqxwfvbx.wl%tiwai@suse.de>
In-Reply-To: <s5hwqxwfvbx.wl%tiwai@suse.de>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.11.2012 07:43, Takashi Iwai wrote:
> At Thu, 08 Nov 2012 01:42:59 +0100,
> Daniel Mack wrote:
>>
>> On 07.11.2012 20:19, Takashi Iwai wrote:
>>> At Wed, 7 Nov 2012 12:34:43 -0500 (EST),
>>> Alan Stern wrote:
>>>>
>>>> On Mon, 5 Nov 2012, Christof Meerwald wrote:
>>>>
>>>>> BTW, I have been able to reproduce the problem on a completely
>>>>> different machine (also running Ubuntu 12.10, but different hardware).
>>>>> The important thing appears to be that the USB audio device is
>>>>> connected via a USB 2.0 hub (and then using the test code posted in
>>>>> http://pastebin.com/aHGe1S1X specifying the audio device as
>>>>> "plughw:Set" (or whatever it's called) seems to trigger the freeze).
>>>>
>>>> Christof: Thank you for that reference, it was a big help.  After
>>>> crashing my system many times I have tracked the problem, at least in
>>>> part.  The patch below should prevent your system from freezing.
>>>>
>>>>
>>>> Takashi: It turns out the the problem is triggered when the audio
>>>> subsystem calls snd_usb_endpoint_stop() with wait == 0 and then calls
>>>> snd_usb_endpoint_start().  Since the driver doesn't wait for the
>>>> outstanding URBs to finish, it tries to submit them again while they
>>>> are still active.
>>>>
>>>> Normally the USB core would realize this and fail the submission, but a
>>>> bug in ehci-hcd prevented this from happening.  (That bug is what the
>>>> patch below fixes.)  The URB gets added to the active list twice,
>>>> resulting in list corruption and an oops in interrupt context, which
>>>> freezes the system.
>>>>
>>>> The user program that triggers the problem basically looks like this:
>>>>
>>>>   snd_pcm_prepare(rec_pcm);
>>>>   snd_pcm_start(rec_pcm);
>>>>   snd_pcm_drop(rec_pcm);
>>>>
>>>>   snd_pcm_prepare(rec_pcm);
>>>>   snd_pcm_start(rec_pcm);
>>>>
>>>> The snd_pcm_drop call unlinks the URBs but does not wait for them to
>>>> finish.  Then the second snd_pcm_start call submits the URBs before
>>>> they have finished.
>>
>>
>> Thanks for investigating on this and to everyone who so quickyl tested
>> the provided patch. Seems like we got the right idea where the problem
>> really is.
>>
>> However, the proposed patch seems wrong to me (see below).
>>
>>>> What is the right solution for this problem?
>>>
>>> How about the patch below?  (It's for 3.6, and won't be applied cleanly
>>> to 3.7, but easy to adapt.)
>>>
>>>
>>> Takashi
>>>
>>> ---
>>> diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
>>> index d9de667..38830e2 100644
>>> --- a/sound/usb/endpoint.c
>>> +++ b/sound/usb/endpoint.c
>>> @@ -35,6 +35,7 @@
>>>  
>>>  #define EP_FLAG_ACTIVATED	0
>>>  #define EP_FLAG_RUNNING		1
>>> +#define EP_FLAG_STOPPING	2
>>>  
>>>  /*
>>>   * snd_usb_endpoint is a model that abstracts everything related to an
>>> @@ -502,10 +503,19 @@ static int wait_clear_urbs(struct snd_usb_endpoint *ep)
>>>  	if (alive)
>>>  		snd_printk(KERN_ERR "timeout: still %d active urbs on EP #%x\n",
>>>  					alive, ep->ep_num);
>>> +	clear_bit(EP_FLAG_STOPPING, &ep->flags);
>>>  
>>>  	return 0;
>>>  }
>>>  
>>> +/* wait until urbs are really dropped */
>>> +void snd_usb_endpoint_sync_stop(struct snd_usb_endpoint *ep)
>>> +{
>>> +	if (test_bit(EP_FLAG_STOPPING, &ep->flags))
>>> +		wait_clear_urbs(ep);
>>> +}
>>> +
>>> +
>>>  /*
>>>   * unlink active urbs.
>>>   */
>>> @@ -913,6 +923,8 @@ void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep,
>>>  
>>>  		if (wait)
>>>  			wait_clear_urbs(ep);
>>> +		else
>>> +			set_bit(EP_FLAG_STOPPING, &ep->flags);
>>>  	}
>>>  }
>>>  
>>> diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
>>> index cbbbdf2..c1540a4 100644
>>> --- a/sound/usb/endpoint.h
>>> +++ b/sound/usb/endpoint.h
>>> @@ -16,6 +16,7 @@ int snd_usb_endpoint_set_params(struct snd_usb_endpoint *ep,
>>>  int  snd_usb_endpoint_start(struct snd_usb_endpoint *ep, int can_sleep);
>>>  void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep,
>>>  			   int force, int can_sleep, int wait);
>>> +void snd_usb_endpoint_sync_stop(struct snd_usb_endpoint *ep);
>>>  int  snd_usb_endpoint_activate(struct snd_usb_endpoint *ep);
>>>  int  snd_usb_endpoint_deactivate(struct snd_usb_endpoint *ep);
>>>  void snd_usb_endpoint_free(struct list_head *head);
>>> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
>>> index f782ce1..aee3ab0 100644
>>> --- a/sound/usb/pcm.c
>>> +++ b/sound/usb/pcm.c
>>> @@ -546,6 +546,11 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substream *substream)
>>>  	if (snd_BUG_ON(!subs->data_endpoint))
>>>  		return -EIO;
>>>  
>>> +	if (subs->sync_endpoint)
>>> +		snd_usb_endpoint_sync_stop(subs->sync_endpoint);
>>> +	if (subs->data_endpoint)
>>> +		snd_usb_endpoint_sync_stop(subs->data_endpoint);
>>
>> We can't simply stop both endpoints in the prepare callback.
> 
> The new function doesn't stop the stream by itself but it just syncs
> if the stream is being stopped beforehand.  So, it's safe to call it
> there.
> 
> Maybe the name was confusing.  It should have been like
> snd_usb_endpoint_sync_pending_stop() or such.

Ah, right. I was errornously looking closer to Alan's patch but then
replied to yours. Alright then - thanks for explaining :)


Daniel

