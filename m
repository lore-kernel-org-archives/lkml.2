Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2EHNiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:38:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40916 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560Ab2EHNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:38:51 -0400
Message-ID: <4FA921E5.4080305@openvz.org>
Date: Tue, 08 May 2012 17:38:45 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH bugfix v3.4] ALSA: hda - fix "silence after S3" regression
References: <4FA91A27.3030801@openvz.org> <20120508130810.17396.27499.stgit@zurg> <s5h397aoldh.wl%tiwai@suse.de>
In-Reply-To: <s5h397aoldh.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Tue, 08 May 2012 17:08:10 +0400,
> Konstantin Khlebnikov wrote:
>>
>> This fixes regression in shd-hda-codec after 785f857d1cb0856b612b46a0545b74aa2
>> ("ALSA: hda - Set codec to D3 forcibly even if not used")
>>
>> hda_set_power_state() call must be explicitly protected against recursive
>> snd_hda_power_up/down() calls, otherwise it accidentally switches device into
>> D0 right before suspend. As result after resume sound device stays in D3 state
>> and does not works because driver believes that the device is on already.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> Hrm, does this really fix your problem?  The path is called only
> during the suspend.  Then, in the resume path, the codec is all
> powered up anyway.

This fixes my problem: during suspend hda_set_power_state() calls snd_hda_power_up()
it set codec->power_on = 1 and switches device into D0. At S3 resume codec->power_on == 1
but all devices actually in D3 state. As result on resume path device stays in D3,
but after one power-save cycle all works again.

>
> If the race between the leftover power-save work is really a culprit,
> the fix would be just calling cancel_delayed_work_sync() before
> that point...

Race was always there, my problem was caused by commit which mentioned above.

Whole this code is very racy, someone needs to fix it.

>
>
> thanks,
>
> Takashi
>
>> ---
>>   sound/pci/hda/hda_codec.c |    6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
>> index 7a8fcc4..a0ea9d6 100644
>> --- a/sound/pci/hda/hda_codec.c
>> +++ b/sound/pci/hda/hda_codec.c
>> @@ -5444,10 +5444,14 @@ int snd_hda_suspend(struct hda_bus *bus)
>>   	list_for_each_entry(codec,&bus->codec_list, list) {
>>   		if (hda_codec_is_power_on(codec))
>>   			hda_call_codec_suspend(codec);
>> -		else /* forcibly change the power to D3 even if not used */
>> +		else {
>> +			/* forcibly change the power to D3 even if not used */
>> +			codec->power_transition = 1;
>>   			hda_set_power_state(codec,
>>   					    codec->afg ? codec->afg : codec->mfg,
>>   					    AC_PWRST_D3);
>> +			codec->power_transition = 0;
>> +		}
>>   		if (codec->patch_ops.post_suspend)
>>   			codec->patch_ops.post_suspend(codec);
>>   	}
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

