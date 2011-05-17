Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1EQVqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:46:11 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:47128 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab1EQVqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:46:10 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.39
Message-ID: <4DD2EC98.5080901@tremplin-utc.net>
Date: Tue, 17 May 2011 23:46:00 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Mandriva/3.1.10-1 (2011.0) Thunderbird/3.1.10
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC v2] lis3lv02d: avoid divide by zero due to unchecked register
 read
References: <201105160046.31019.chunkeey@googlemail.com> <4DD1079E.6000209@tremplin-utc.net> <201105162336.05306.chunkeey@googlemail.com>
In-Reply-To: <201105162336.05306.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 16-05-11 23:36, Christian Lamparter schreef:
> On Monday 16 May 2011 13:16:46 Éric Piel wrote:
>> Op 16-05-11 00:46, Christian Lamparter schreef:
>>>  From my POV, it looks like the hardware is not working as expected
>>> and returns a bogus data rate. The driver doesn't check the result
>>> and directly uses it as some sort of divisor in some places:
>>>
>>> msleep(lis3->pwron_delay / lis3lv02d_get_odr());
>>>
>>> Under this circumstances, this could very well cause the
>>> "divide by zero" exception from above.
>>>
>> However, I'd fix it a bit differently: let lis3lv02d_get_odr() return
>> the raw data, and create a special function
>> lis3lv02d_get_pwron_delay_ms() which does the "lis3->pwron_delay /
>> lis3lv02d_get_odr()" with special handling for 0 (returning a large
>> value and also sending a printk_once() ).
> Do you know how "volatile" this data rate is? If it never changes
> [at least it doesn't here?] then why not read it once in init_device
> and store it in the device context?
It is not normally changing, normally it is set just at init/unsuspend 
(where the bios can also interfere sometimes) and when the user changes 
it. So definitely within the same function it's not going to suddenly 
change. We could avoid calculating/checking it twice in 
lis3lv02d_selftest(). Care to do a third version with this little clean up?

>
> Anyway, I updated the code... But instead of returning a "large value"
> I went for the -ENXIO to bail-out early, so now we won't continue if
> something went bad [after resume for instance?].
Sounds even better than using a conservative value!

>
>> As you have noted, we might want to check other parts of the driver to
>> validate the data from the device. So far, all the code considers that
>> the device is flawless :-S
> well:
>    CHECK   drivers/misc/lis3lv02d/lis3lv02d.c
> drivers/misc/lis3lv02d/lis3lv02d.c:170:52: warning: cast to restricted __le16
This is not introduced by your patch, right? So it's fine for now :-)

Thanks,
Eric
