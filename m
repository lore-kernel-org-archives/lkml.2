Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1IBQqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:46:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52279 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753424Ab1IBQqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:46:46 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/6D149LpX680WdCW9yzeiD7DyJdOIAq7hlkB4oyx
	76V8lcKVYnL/5+
Message-ID: <4E61086C.3050102@gmx.de>
Date: Fri, 02 Sep 2011 16:46:36 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, lethal@linux-sh.org,
        linux-fbdev@vger.kernel.org, francis.moro@gmail.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>, stable@kernel.org
Subject: Re: [PATCH] fb: avoid possible deadlock caused by fb_set_suspend
References: <4DF7B0B4.4060002@gmx.de> <1308337359-3480-1-git-send-email-FlorianSchandinat@gmx.de> <20110618104311.6d80ba50@neptune.home> <20110618111934.26203dbf@neptune.home> <4E5FA7F9.9030802@gmx.de> <Pine.LNX.4.64.1109021802560.4731@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109021802560.4731@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno, Guennadi,

On 09/02/2011 04:06 PM, Guennadi Liakhovetski wrote:
> Hi Florian
> 
> On Thu, 1 Sep 2011, Florian Tobias Schandinat wrote:
> 
>> ping
>>
>> Guennadi, I really want this issue fixed. Please have a look at Bruno's patch
>> otherwise your driver might remain or get even more broken...
>>
>> I am scheduling Herton's patch for the next merge window.
> 
> So, the patch looks simple and correct, when applied on top of 
> http://marc.info/?l=linux-kernel&m=130833638508657&w=2
> But it doesn't apply anymore and after fixing a trivial merge conflict, it 
> fails to build, which is also trivially fixed. Please, add my
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

So I guess we can finally solve this issue, thanks.

On the other hand I just noticed the original patch didn't have Bruno's
Signed-off and a commit message was missing. So may I ask you, Bruno, to add
your Signed-off or preferably resend the version tested by Guennadi in the
appropriate patch format.


Thanks,

Florian Tobias Schandinat

> 
> to the set and use this updated version:
> 
> diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/sh_mobile_hdmi.c
> index 7d54e2c..647ba98 100644
> --- a/drivers/video/sh_mobile_hdmi.c
> +++ b/drivers/video/sh_mobile_hdmi.c
> @@ -1111,6 +1111,7 @@ static long sh_hdmi_clk_configure(struct sh_hdmi *hdmi, unsigned long hdmi_rate,
>  static void sh_hdmi_edid_work_fn(struct work_struct *work)
>  {
>  	struct sh_hdmi *hdmi = container_of(work, struct sh_hdmi, edid_work.work);
> +	struct fb_info *info;
>  	struct sh_mobile_hdmi_info *pdata = hdmi->dev->platform_data;
>  	struct sh_mobile_lcdc_chan *ch;
>  	int ret;
> @@ -1123,8 +1124,9 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
>  
>  	mutex_lock(&hdmi->mutex);
>  
> +	info = hdmi->info;
> +
>  	if (hdmi->hp_state == HDMI_HOTPLUG_CONNECTED) {
> -		struct fb_info *info = hdmi->info;
>  		unsigned long parent_rate = 0, hdmi_rate;
>  
>  		ret = sh_hdmi_read_edid(hdmi, &hdmi_rate, &parent_rate);
> @@ -1148,42 +1150,45 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
>  
>  		ch = info->par;
>  
> -		console_lock();
> +		if (lock_fb_info(info)) {
> +			console_lock();
>  
> -		/* HDMI plug in */
> -		if (!sh_hdmi_must_reconfigure(hdmi) &&
> -		    info->state == FBINFO_STATE_RUNNING) {
> -			/*
> -			 * First activation with the default monitor - just turn
> -			 * on, if we run a resume here, the logo disappears
> -			 */
> -			if (lock_fb_info(info)) {
> +			/* HDMI plug in */
> +			if (!sh_hdmi_must_reconfigure(hdmi) &&
> +			    info->state == FBINFO_STATE_RUNNING) {
> +				/*
> +				 * First activation with the default monitor - just turn
> +				 * on, if we run a resume here, the logo disappears
> +				 */
>  				info->var.width = hdmi->var.width;
>  				info->var.height = hdmi->var.height;
>  				sh_hdmi_display_on(hdmi, info);
> -				unlock_fb_info(info);
> +			} else {
> +				/* New monitor or have to wake up */
> +				fb_set_suspend(info, 0);
>  			}
> -		} else {
> -			/* New monitor or have to wake up */
> -			fb_set_suspend(info, 0);
> -		}
>  
> -		console_unlock();
> +			console_unlock();
> +			unlock_fb_info(info);
> +		}
>  	} else {
>  		ret = 0;
> -		if (!hdmi->info)
> +		if (!info)
>  			goto out;
>  
>  		hdmi->monspec.modedb_len = 0;
>  		fb_destroy_modedb(hdmi->monspec.modedb);
>  		hdmi->monspec.modedb = NULL;
>  
> -		console_lock();
> +		if (lock_fb_info(info)) {
> +			console_lock();
>  
> -		/* HDMI disconnect */
> -		fb_set_suspend(hdmi->info, 1);
> +			/* HDMI disconnect */
> +			fb_set_suspend(info, 1);
>  
> -		console_unlock();
> +			console_unlock();
> +			unlock_fb_info(info);
> +		}
>  	}
>  
>  out:
> 
> Thanks
> Guennadi
> 
>>
>>
>> Regards,
>>
>> Florian Tobias Schandinat
>>
>>
>> On 06/18/2011 09:19 AM, Bruno Prémont wrote:
>>> Guennadi, could you have a look at (completely untested) patch which avoids
>>> possible deadlock due to inverted lock taking order on hotplug as well
>>> as "readding" lock_fb_info() for fb_set_suspend() call after Herton's
>>> patch to fb_set_suspend().
>>>
>>> Thanks,
>>> Bruno
>>>
>>>
>>> On Sat, 18 June 2011 Bruno Prémont <bonbons@linux-vserver.org> wrote:
>>>> On Fri, 17 June 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>>>>> From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>>>>>
>>>>> A lock ordering issue can cause deadlocks: in framebuffer/console code,
>>>>> all needed struct fb_info locks are taken before acquire_console_sem(),
>>>>> in places which need to take console semaphore.
>>>>>
>>>>> But fb_set_suspend is always called with console semaphore held, and
>>>>> inside it we call lock_fb_info which gets the fb_info lock, inverse
>>>>> locking order of what the rest of the code does. This causes a real
>>>>> deadlock issue, when we write to state fb sysfs attribute (which calls
>>>>> fb_set_suspend) while a framebuffer is being unregistered by
>>>>> remove_conflicting_framebuffers, as can be shown by following show
>>>>> blocked state trace on a test program which loads i915 and runs another
>>>>> forked processes writing to state attribute:
>>>>>
>>>>> Test process with semaphore held and trying to get fb_info lock:
>>>>
>>>> ...
>>>>
>>>>> fb-test2 which reproduces above is available on kernel.org bug #26232.
>>>>> To solve this issue, avoid calling lock_fb_info inside fb_set_suspend,
>>>>> and move it out to where needed (callers of fb_set_suspend must call
>>>>> lock_fb_info before if needed). So far, the only place which needs to
>>>>> call lock_fb_info is store_fbstate, all other places which calls
>>>>> fb_set_suspend are suspend/resume hooks that should not need the lock as
>>>>> they should be run only when processes are already frozen in
>>>>> suspend/resume.
>>>>
>>>> From a quick look through FB drivers in 2.6.39 I've found one that would need
>>>> more work:
>>>> - drivers/video/sh_mobile_hdmi.c: sh_hdmi_edid_work_fn()
>>>>   Should get changed to
>>>>   a) right locking order in case (hdmi->hp_state == HDMI_HOTPLUG_CONNECTED)
>>>>   b) lock fb_info in the other case
>>>>   For this one fb_set_suspend() does get call in a hotplug worker,
>>>>   thus independently on suspend/resume process.
>>>>
>>>> The rest does match the suspend/resume hook pattern mentioned.
>>>>
>>>> Bruno
>>>>
>>>>
>>>>> References: https://bugzilla.kernel.org/show_bug.cgi?id=26232
>>>>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>>>>> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>>>>> Cc: stable@kernel.org
>>>>> ---
>>>>>  drivers/video/fbmem.c   |    3 ---
>>>>>  drivers/video/fbsysfs.c |    3 +++
>>>>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
>>>>> index 5aac00e..ad93629 100644
>>>>> --- a/drivers/video/fbmem.c
>>>>> +++ b/drivers/video/fbmem.c
>>>>> @@ -1738,8 +1738,6 @@ void fb_set_suspend(struct fb_info *info, int state)
>>>>>  {
>>>>>  	struct fb_event event;
>>>>>  
>>>>> -	if (!lock_fb_info(info))
>>>>> -		return;
>>>>>  	event.info = info;
>>>>>  	if (state) {
>>>>>  		fb_notifier_call_chain(FB_EVENT_SUSPEND, &event);
>>>>> @@ -1748,7 +1746,6 @@ void fb_set_suspend(struct fb_info *info, int state)
>>>>>  		info->state = FBINFO_STATE_RUNNING;
>>>>>  		fb_notifier_call_chain(FB_EVENT_RESUME, &event);
>>>>>  	}
>>>>> -	unlock_fb_info(info);
>>>>>  }
>>>>>  
>>>>>  /**
>>>>> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
>>>>> index 04251ce..67afa9c 100644
>>>>> --- a/drivers/video/fbsysfs.c
>>>>> +++ b/drivers/video/fbsysfs.c
>>>>> @@ -399,9 +399,12 @@ static ssize_t store_fbstate(struct device *device,
>>>>>  
>>>>>  	state = simple_strtoul(buf, &last, 0);
>>>>>  
>>>>> +	if (!lock_fb_info(fb_info))
>>>>> +		return -ENODEV;
>>>>>  	console_lock();
>>>>>  	fb_set_suspend(fb_info, (int)state);
>>>>>  	console_unlock();
>>>>> +	unlock_fb_info(fb_info);
>>>>>  
>>>>>  	return count;
>>>>>  }
>>>
>>>
>>> diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/sh_mobile_hdmi.c
>>> index 2b9e56a..b1a13ab 100644
>>> --- a/drivers/video/sh_mobile_hdmi.c
>>> +++ b/drivers/video/sh_mobile_hdmi.c
>>> @@ -1151,27 +1151,27 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
>>>  
>>>  		ch = info->par;
>>>  
>>> -		console_lock();
>>> +		if (lock_fb_info(info)) {
>>> +			console_lock();
>>>  
>>> -		/* HDMI plug in */
>>> -		if (!sh_hdmi_must_reconfigure(hdmi) &&
>>> -		    info->state == FBINFO_STATE_RUNNING) {
>>> -			/*
>>> -			 * First activation with the default monitor - just turn
>>> -			 * on, if we run a resume here, the logo disappears
>>> -			 */
>>> -			if (lock_fb_info(info)) {
>>> +			/* HDMI plug in */
>>> +			if (!sh_hdmi_must_reconfigure(hdmi) &&
>>> +			    info->state == FBINFO_STATE_RUNNING) {
>>> +				/*
>>> +				 * First activation with the default monitor - just turn
>>> +				 * on, if we run a resume here, the logo disappears
>>> +				 */
>>>  				info->var.width = hdmi->var.width;
>>>  				info->var.height = hdmi->var.height;
>>>  				sh_hdmi_display_on(hdmi, info);
>>> -				unlock_fb_info(info);
>>> +			} else {
>>> +				/* New monitor or have to wake up */
>>> +				fb_set_suspend(info, 0);
>>>  			}
>>> -		} else {
>>> -			/* New monitor or have to wake up */
>>> -			fb_set_suspend(info, 0);
>>> -		}
>>>  
>>> -		console_unlock();
>>> +			console_unlock();
>>> +			unlock_fb_info(info);
>>> +		}
>>>  	} else {
>>>  		ret = 0;
>>>  		if (!hdmi->info)
>>> @@ -1181,12 +1181,15 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
>>>  		fb_destroy_modedb(hdmi->monspec.modedb);
>>>  		hdmi->monspec.modedb = NULL;
>>>  
>>> -		console_lock();
>>> +		if (lock_fb_info(info)) {
>>> +			console_lock();
>>>  
>>> -		/* HDMI disconnect */
>>> -		fb_set_suspend(hdmi->info, 1);
>>> +			/* HDMI disconnect */
>>> +			fb_set_suspend(hdmi->info, 1);
>>>  
>>> -		console_unlock();
>>> +			console_unlock();
>>> +			unlock_fb_info(info);
>>> +		}
>>>  		pm_runtime_put(hdmi->dev);
>>>  	}
>>>  
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

