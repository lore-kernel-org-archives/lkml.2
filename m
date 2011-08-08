Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1HHJdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:33:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35893 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1HHJdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:33:41 -0400
MIME-Version: 1.0
In-Reply-To: <s5h1uwwia80.wl%tiwai@suse.de>
References: <1312790832-6790-1-git-send-email-wangshaoyan.pt@taobao.com>
	<s5h1uwwia80.wl%tiwai@suse.de>
Date: Mon, 8 Aug 2011 17:33:40 +0800
Message-ID: <CANxBZFqTrWrHqarez4W=rjOTWENgjb_g=PEX5Ja6euE35Hj4HA@mail.gmail.com>
Subject: Re: [PATCH] sound: don't use the deprecated function check_region
From: Wang Shaoyan <stufever@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, perex@perex.cz,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/8 Takashi Iwai <tiwai@suse.de>:
> At Mon,  8 Aug 2011 16:07:12 +0800,
> stufever@gmail.com wrote:
>>
>> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
>>
>>   sound/oss/pss.c: In function 'configure_nonsound_components':
>>   sound/oss/pss.c:676: warning: 'check_region' is deprecated (declared at include/linux/ioport.h:201)
>>
>> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
>> ---
>>  sound/oss/pss.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/sound/oss/pss.c b/sound/oss/pss.c
>> index 9b800ce..0fa26bd 100644
>> --- a/sound/oss/pss.c
>> +++ b/sound/oss/pss.c
>> @@ -673,9 +673,10 @@ static void configure_nonsound_components(void)
>>
>>       if (pss_cdrom_port == -1) {     /* If cdrom port enablation wasn't requested */
>>               printk(KERN_INFO "PSS: CDROM port not enabled.\n");
>> -     } else if (check_region(pss_cdrom_port, 2)) {
>> +     } else if (!request_region(pss_cdrom_port, 2, "PSS CDROM")) {
>>               printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
>>       } else {
>> +             release_region(pss_cdrom_port, 2);
>>               set_io_base(devc, CONF_CDROM, pss_cdrom_port);
>>               printk(KERN_INFO "PSS: CDROM I/O port set to 0x%x.\n", pss_cdrom_port);
>>       }
>
> Well, this just hides the warning but doesn't fix the possible race,
> which is the reason check_region() is marked as deprecated after all.
>

AFAIK, check_region() is deprecated because such usage:
check_region()
...do something    <-- here another process may do check and request same region
request_region()
But nowadays, request_region has done the check internally, so use the
proper request_region to check is enough, am I miss something?

> Instead of releasing the resource there, keep it and release in the
> destructor properly like other normal resources.
>

maybe we can release here?

set_io_base(devc, CONF_CDROM, pss_cdrom_port);
printk(KERN_INFO "PSS: CDROM I/O port set to 0x%x.\n", pss_cdrom_port);
release_region(pss_cdrom_port, 2);

>
> thanks,
>
> Takashi
>



-- 
Wang Shaoyan
