Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3ABUBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:01:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab3ABUBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:01:02 -0500
Message-ID: <50E491D5.3080106@ti.com>
Date: Wed, 2 Jan 2013 14:00:21 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pratik Patel <pratikp@codeaurora.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        <linux-arm-msm@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        "magnus.p.persson@stericsson.com" <magnus.p.persson@stericsson.com>,
        "david.rusling@linaro.org" <david.rusling@linaro.org>,
        "arve@android.com" <arve@android.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "d-deao@ti.com" <d-deao@ti.com>,
        "christian.bejram@stericsson.com" <christian.bejram@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: CoreSight framework and drivers
References: <1355858365-11849-1-git-send-email-pratikp@codeaurora.org> <20121219112314.GA26329@mudshark.cambridge.arm.com> <50D1F37E.6000804@ti.com> <20121219212431.GC23594@pratikp-linux.qualcomm.com> <50D34EE5.8090407@ti.com> <20121220195127.GA14877@pratikp-linux.qualcomm.com> <50D3972E.4030607@ti.com> <20121221221828.GA2658@pratikp-linux.qualcomm.com>
In-Reply-To: <20121221221828.GA2658@pratikp-linux.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/21/2012 04:18 PM, Pratik Patel wrote:
> On Thu, Dec 20, 2012 at 04:54:38PM -0600, Jon Hunter wrote:
>>
>> On 12/20/2012 01:51 PM, Pratik Patel wrote:
>>> On Thu, Dec 20, 2012 at 11:46:13AM -0600, Jon Hunter wrote:
>>>>
>>>> On 12/19/2012 03:24 PM, Pratik Patel wrote:
>>>>
>>>> [snip]
>>>>
>>>>> Currently we use the CoreSight virtual bus to conveniently list
>>>>> sysfs configuration attributes for all the registered CoreSight
>>>>> devices.
>>>>>
>>>>> For eg:
>>>>> /sys/bus/coresight/devices/coresight-etm0/<attribute>
>>>>> /sys/bus/coresight/devices/coresight-etm1/<attribute>
>>>>> /sys/bus/coresight/devices/coresight-stm/<attribute>
>>>>> /sys/bus/coresight/devices/coresight-tmc-etf/<attribute>
>>>>> ...
>>>>> ...
>>>>>
>>>>> Some of the attributes are based on device type (i.e. source,
>>>>> link or sink) so they will exist for all devices of that type
>>>>> while some are device specific.
>>>>>
>>>>> Maybe I am misunderstanding the question but are you suggesting
>>>>> to register CoreSight devices to the AMBA bus instead of the
>>>>> CoreSight core layer code?
>>>>
>>>> Yes exactly.
>>>>
>>>>> Will Deacon mentioned earlier that AMBA framework can be changed
>>>>> to accomodate devices with a different class but I am more
>>>>> concerned with losing some of the stuff that the core layer code
>>>>> does (eg. coresight_register, coresight_enable, coresight_disable
>>>>> in coresight.c) if we register CoreSight drivers to the AMBA bus
>>>>> without letting the core layer know about the device connections.
>>>>
>>>> I may be missing something, but couldn't you keep all the
>>>> register/enable/disable stuff but just register the device with the amba
>>>> bus? Obviously some changes would need to be made.
>>>>
>>>
>>> Ok, so are you referring to making CoreSight devices register
>>> with AMBA bus instead of platform bus keeping everything else
>>> intact?
>>
>> Yes exactly. However, please note I am not saying that we should do
>> this, and I asking what direction does the community want us to take
>> here? Platform bus or AMBA bus?
>>
>>>> Personally, I don't have strong feeling either way, but we have ETM/ETB
>>>> drivers using AMBA today and so I am hoping we can come to agreement on
>>>> this going forward.
>>>>
>>>> Russell, Will, what are your thoughts?
>>>>
>>>> Otherwise, looking at the code, I like what you have implemented. I
>>>> still need to look closer, but I am struggling to figure out how a
>>>> coresight device such as the cross-trigger-interface fits with this
>>>> model. This model appears to be geared towards coresight devices used
>>>> for traces purposes and are either source, links or sinks. The
>>>> cross-trigger-interface is not a source or a sink. However, although you
>>>> it could be considered as a link (routing events), it is not really, as
>>>> it may not link to other coresight sinks/source.
>>>>
>>>> In my case, I have PMU-IRQ --> CTI --> GIC. So a non-coresight source
>>>> and sink. In away the CTI looks more like a 2nd-level interrupt
>>>> controller than anything else. Hence, another type of coresight device
>>>> may be needed in addition to source, links and sinks. Or link is
>>>> extended in some way to connect to non-coresight sources/sinks.
>>>>
>>>> Let me know if you have any thoughts.
>>>>
>>>
>>> I had left the "None" type for miscellaneous stuff but I agree it
>>> should be a separate type - maybe "debug".
>>>
>>> Having said that I like the CTI driver you have uploaded. Need to
>>> look at it in more detail. Since CTI connections can vary between
>>> chip to chip, we need a generic way to deal with it.
>>
>> Yes if you have any ideas let me know. As Will had mentioned it would be
>> good to have a common function table all these devices could use too. I
>> will take a closer look at what you have.
>>
> 
> I had started on a CTI driver much in line with your current
> implementation but your approach looks good to me.
> 
> Looking at the code though, I couldn't find a way to perform a
> mapping between two different CTIs. Reason I ask is because we
> have use cases where we need to map one CTIs input to another
> CTIs output on the same channel.

The code is largely based upon the existing cti helpers, which just had
a cti_map_trigger() function. The use-case you described is not
supported by the current helpers and so also not supported in my initial
implementation (although we should add this). Hence, it would be
probably best to split the cti_map_trigger() into two functions say,
cti_map_triggerin() and cti_map_triggerout(), to map a trigger
input/output to a channel.

> Do you intend to support different entities within kernel to map
> different trig_in or trig_out on the same CTI? If so, it might
> probably require reference counting for the enable/disable.

I need to think about this some more, as this does make it a little more
complex. Right now only one entity can use a cti module at a time.

> What user interface do you plan to provide for the CTI? Maybe
> something consistent with other CoreSight components in sysfs to
> allow users to enable, disable, map and unmap ???

Yes that's possible.

> Please let me know your thoughts.
> 
> CTIs can easily be made part of the CoreSight core layer using a
> different type but apart from being part of the CoreSight list
> containing all the trace and CTI components, not sure if there is
> anything that is useful to do in the core layer. Need to think
> about this.

Yes it would be good to make this all part of the same coresight framework.

Cheers
Jon

