Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0IALuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:50:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39129 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0IALuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:50:05 -0400
Message-ID: <4C7E3DE0.7030209@canonical.com>
Date: Wed, 01 Sep 2010 19:49:52 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control rf/camera
 power
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282127719.2747.211.camel@localhost> <20100818155128.GA24363@darkside.kls.lan> <4C6CA31D.6030407@canonical.com> <20100819193146.GB32665@darkside.kls.lan> <4C6E2833.6080407@canonical.com> <20100820090824.GA23186@darkside.kls.lan> <4C7505A2.3000402@canonical.com> <20100830181954.GE31068@darkside.kls.lan>
In-Reply-To: <20100830181954.GE31068@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 02:19 AM, Mario 'BitKoenig' Holbe wrote:
> Hello Ike,
> 
> On Wed, Aug 25, 2010 at 07:59:30PM +0800, Ike Panhc wrote:
>> On 08/20/2010 05:08 PM, Mario 'BitKoenig' Holbe wrote:
>>> On Fri, Aug 20, 2010 at 03:01:07PM +0800, Ike Panhc wrote:
>>>> Could you attach or upload the DSDT of S12 somewhere I can reach?
>>>
>>> http://sandbox.fem.tu-ilmenau.de/s12/dsdt-s12-via.dsl
>>>
>>>> I check DSDT for S10-3 and B550, return value of _CFG is fixed.
>>>> [Ref: http://people.ubuntu.com/~ikepanhc/DSDTs]
>>>
>>> Looks more fixed than on my S12, indeed.
>>> I don't really speak AML, but while S10-3 ILDD (called from _CFG) seems
>>> to read fixed values only, here on S12 PHSR (called from _CFG) seems to
>>> do some kind of I/O operation. I'm not sure about this, but it somehow
>>> looks like.
>>>
>> It accesses something in system memory, but I have no idea what will happen
>> after writing..
> 
> Well, the pattern looks like I/O - mmapped I/O.
>         Store (Arg1, \_SB.INF0)
>         Store (Arg0, \_SB.BCMD)
>         Store (Zero, \_SB.SMIC)
>         Store (\_SB.INF0, Local0)
> 
> Note that INF0 is written before and read after writing SMIC. Hence,
> for this to be useful, something must have happened inbetween, i.e.
> I/O :)
> 
Yes, I have the same feeling. The problem is that I have no idea what happen after
writing.

>> There are two variables need to be written for turning on/off bluetooth. They are
>> BTST(in memory) and BTEN(is EC register). I will guess there are some sync failed
>> when enable bluetooth.
> 
> What exactly do you mean with "there are some sync failed"? I don't see
> anything like that in the logs.
> 
Oh, maybe I choose wrong word. Usually after some I/O writing, we have to wait for
some signal or time to make sure device complete operation. But it seems reading
right after writing. This is not important, just some nagging..

>> This could be a plan. I have several idea to go and need your help.
>> - Add some debug message to read BTST/BTEN when turning on/off bluetooth.
>> - Force to set BTST/BTEN before reading _CFG
>> - Provide a module parm to force enable rf devices.
>>
>> Will have the drivers and please test it and let me know the result.
> 
> Hmmm, I don't know if I got you right. I didn't find any new drivers to
> test, so I tried to add some more debug code myself. Hope this helps.
> I added some code to show_ideapad_cam() to be able to asynchronously
> trigger reading of BTST, BTEN, and BTPS. As before: the patch attached
> is not for inclusion but to show what I did. I'm usually not a kernel
> hacker, so please take a serious look at what I did before trusting the
> results :)
Sorry, I took some day off for a rest. And thank you, you did exactly
what I plan to do. From your log the values of BTST/BTEN match what it
shall be.

> 
> I attached a full protocol of actions I performed including kernel
> dmesges. Typed commands are prepended by #, manual actions and comments
> are enclosed in <>, kernel messages are timestamped, the rest is output
> of the commands.
> Basically I did the following:
> 0. I started with a fresh powered up system, all RF devices powered on.
> 1. I hw-switched RF off and back on, which went okay.
> 2. I sw-switched BT off and back on, which resulted in erroneous
> initialization.
> 3. I again sw-switched BT off and back on, which resulted in BT being
> completely gone.
> 4. I hw-switched RF off and back on, which brought BT back and
> operational.
Your log tells a lot. It tells me if the bluetooth init failed. Then we
have to turning off and power on again by hw switch to make it alive again.

So, I believe we have two issue here.
* when rfkill unblock, sometimes bluetooth init failed.
* power up system after rfkill block bluetooth, sometimes the cfgbit = 0xc0000
Am I correct?

> 
>>> I played with the hardware killswitch under Linux. The bluetooth device
>>> disappears and re-appears there and always seems to initialize
>>> correctly. No USB read errors this way.
> ...
>>> I'm not exactly sure what this means - especially because I don't know
>>> how the hardware killswitch works internally.
>>> It *could* mean, the initialization problem is proably something that
>>> could be dealt with in the USB layer long term (and would then probably
>>> not have to be worked around anymore in ideapad_laptop). I'm not sure
>>> about this, because this would mean the hard killswitch power-cut
>>> somehow differs from the soft killswitch power-cut.
>> Usually the hw rf switch turning off PHY only. When turning off, device and
>> its driver is still there. I believe S12 is designed in this way after
>> reading your test result.
> 
> Hmmm, I don't understand your reasoning here.
> I said the device disappears and re-appears when using the hw rf switch,
> this doesn't look like it would turn off PHY only.
I saw the USB disconnect in your log. You are right, the hw rf switch power
down the whole module.

Just check with B550, the hw rf switch power down the whole bluetooth, but
only turn off PHY for wifi. Looks like I can not take design for bluetooth
and wifi are the same. Thanks for let me check it again.

> 
> 
> best regards
>    Mario

