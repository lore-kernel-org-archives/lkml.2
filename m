Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1LLWNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:13:13 -0500
Received: from tru75-7-88-161-131-83.fbx.proxad.net ([88.161.131.83]:56129
	"EHLO next.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754262Ab1LLWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:13:10 -0500
Message-ID: <4EE67C6B.8000206@free.fr>
Date: Mon, 12 Dec 2011 23:12:59 +0100
From: Wallak <wallak@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0.1) Gecko/20111122 Firefox/8.0.1 SeaMonkey/2.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: OSS audio compatibility layer regression - Linux-3.x - unable
 to register OSS PCM device 0:0
References: <1323545574.4ee3b3e6d21b8@imp.free.fr> <s5h1usaw1ut.wl%tiwai@suse.de>
In-Reply-To: <s5h1usaw1ut.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Takashi Iwai wrote:
> At Sat, 10 Dec 2011 20:32:54 +0100,
> wallak@free.fr wrote:
>> I've an issue, when I use the SND_OSSEMUL compatibility layer with the
>> snd_intel8x0 module. The devices can't be registered. Indeed, theses devices are
>> registered at the oss_init() stage, and are not available later. A patch to fix
>> this issue is available below. The patch uses the previous linux behavior.
> I guess you set CONFIG_SOUND_OSS=y?  This conflicts with the OSS
> emulation.  It looked as if both can co-exist in the former kernels,
> but it's just because we didn't check it strictly.  Both try to
> register the very same devices -- especially OSS does this at init
> even before needed.
> As a workaround, just disable CONFIG_SOUND_OSS unless you really need
> it.  Or, if this isn't the case, give your .config file.
>
> If this is the case, we can add a Kconfig rule to exclude the
> conflict in future...
>
>
> thanks,
>
> Takashi

Thanks; I will update the .config file.

Best Regards,
Wallak.

>>
>> Best Regards,
>> Wallak.
>>
>>
>> #log output
>> snd_intel8x0 0000:00:1f.5: PCI INT B ->  Link[LNKB] ->  GSI 10 (level, low) ->  IRQ
>> 10
>> intel8x0_measure_ac97_clock: measured 54899 usecs (2645 samples)
>> intel8x0: clocking to 48000
>> unable to register OSS PCM device 0:0
>> Bridge firewalling registered
>>
>> #patch fixing this issue: (commit 848669da3a92fa6ab815e0517af3294afb3ea928 adds
>> this issue)
>> --- linux-3.1.5-mdf/sound/oss/soundcard.c.orig    2011-12-09 17:57:05.000000000
>> +0100
>> +++ linux-3.1.5-mdf/sound/oss/soundcard.c    2011-12-10 15:18:02.000000000 +0100
>> @@ -526,21 +526,31 @@
>>   }
>>
>>
>> +/* These device names follow the official Linux device list,
>> + * Documentation/devices.txt.  Let us know if there are other
>> + * common names we should support for compatibility.
>> + * Only those devices not created by the generic code in sound_core.c are
>> + * registered here.
>> + */
>> +static const struct {
>> +    unsigned short minor;
>> +    char *name;
>> +    umode_t mode;
>> +    int *num;
>> +} dev_list[] = { /* list of minor devices */
>> +/* seems to be some confusion here -- this device is not in the device list */
>> +    {SND_DEV_DSP16,     "dspW",     S_IWUGO | S_IRUSR | S_IRGRP,
>> +&num_audiodevs},
>> +    {SND_DEV_AUDIO,     "audio",     S_IWUGO | S_IRUSR | S_IRGRP,
>> +&num_audiodevs},
>> +};
>> +
>>   static int dmabuf;
>>   static int dmabug;
>>
>>   module_param(dmabuf, int, 0444);
>>   module_param(dmabug, int, 0444);
>>
>> -/* additional minors for compatibility */
>> -struct oss_minor_dev {
>> -    unsigned short minor;
>> -    unsigned int enabled;
>> -} dev_list[] = {
>> -    { SND_DEV_DSP16 },
>> -    { SND_DEV_AUDIO },
>> -};
>> -
>>   static int __init oss_init(void)
>>   {
>>       int             err;
>> @@ -561,12 +571,18 @@
>>       sound_dmap_flag = (dmabuf>  0 ? 1 : 0);
>>
>>       for (i = 0; i<  ARRAY_SIZE(dev_list); i++) {
>> -        j = 0;
>> -        do {
>> -            unsigned short minor = dev_list[i].minor + j * 0x10;
>> -            if (!register_sound_special(&oss_sound_fops, minor))
>> -                dev_list[i].enabled = (1<<  j);
>> -        } while (++j<  num_audiodevs);
>> +        device_create(sound_class, NULL,
>> +                  MKDEV(SOUND_MAJOR, dev_list[i].minor), NULL,
>> +                  "%s", dev_list[i].name);
>> +
>> +        if (!dev_list[i].num)
>> +            continue;
>> +
>> +        for (j = 1; j<  *dev_list[i].num; j++)
>> +            device_create(sound_class, NULL,
>> +                      MKDEV(SOUND_MAJOR,
>> +                        dev_list[i].minor + (j*0x10)),
>> +                      NULL, "%s%d", dev_list[i].name, j);
>>       }
>>
>>       if (sound_nblocks>= MAX_MEM_BLOCKS - 1)
>> @@ -580,11 +596,11 @@
>>       int i, j;
>>
>>       for (i = 0; i<  ARRAY_SIZE(dev_list); i++) {
>> -        j = 0;
>> -        do {
>> -            if (dev_list[i].enabled&  (1<<  j))
>> -                unregister_sound_special(dev_list[i].minor);
>> -        } while (++j<  num_audiodevs);
>> +        device_destroy(sound_class, MKDEV(SOUND_MAJOR, dev_list[i].minor));
>> +        if (!dev_list[i].num)
>> +            continue;
>> +        for (j = 1; j<  *dev_list[i].num; j++)
>> +            device_destroy(sound_class, MKDEV(SOUND_MAJOR, dev_list[i].minor +
>> (j*0x10)));
>>       }
>>
>>       unregister_sound_special(1);
>>

