Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab0LLJQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 04:16:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:58962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0LLJQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 04:16:08 -0500
Message-ID: <4D0492CB.2010702@kernel.org>
Date: Sun, 12 Dec 2010 10:15:55 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
References: <1292086307-19211-1-git-send-email-tj@kernel.org>	<1292086307-19211-10-git-send-email-tj@kernel.org> <s5hk4jfbc94.wl%tiwai@suse.de>
In-Reply-To: <s5hk4jfbc94.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 09:15:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Takashi.

On 12/12/2010 09:56 AM, Takashi Iwai wrote:
>> diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
>> index 7611add..b3e9fac 100644
>> --- a/sound/soc/codecs/wm8350.c
>> +++ b/sound/soc/codecs/wm8350.c
>> @@ -1626,7 +1626,6 @@ static int  wm8350_codec_remove(struct snd_soc_codec *codec)
>>  {
>>  	struct wm8350_data *priv = snd_soc_codec_get_drvdata(codec);
>>  	struct wm8350 *wm8350 = dev_get_platdata(codec->dev);
>> -	int ret;
>>  
>>  	wm8350_clear_bits(wm8350, WM8350_JACK_DETECT,
>>  			  WM8350_JDL_ENA | WM8350_JDR_ENA);
>> @@ -1641,15 +1640,9 @@ static int  wm8350_codec_remove(struct snd_soc_codec *codec)
>>  	priv->hpr.jack = NULL;
>>  	priv->mic.jack = NULL;
>>  
>> -	/* cancel any work waiting to be queued. */
>> -	ret = cancel_delayed_work(&codec->delayed_work);
>> -
>>  	/* if there was any work waiting then we run it now and
>>  	 * wait for its completion */
>> -	if (ret) {
>> -		schedule_delayed_work(&codec->delayed_work, 0);
>> -		flush_scheduled_work();
>> -	}
>> +	flush_delayed_work_sync(&codec->delayed_work);
> 
> I vaguely remember Liam introduced this kind of code by some reason.
> 
> Liam, isn't it better for cancel_delayed_work_sync(), or should it be
> like the above?

flush_delayed_work_sync() semantics has been recently changed such
that if a delayed work is pending it's queued immediately and then
completion is waited.  IOW, the behavior remains unchanged with the
above change.

Thanks.

-- 
tejun
