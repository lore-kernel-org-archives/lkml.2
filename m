Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1GGVWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:22:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39654 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1GGVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:22:40 -0400
Message-ID: <4E1623EB.3010203@gmail.com>
Date: Fri, 08 Jul 2011 07:23:55 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>, "Chemparathy, Cyril" <cyril@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC/RFT 1/2] gpio/basic_mmio: add support for enable register
References: <cover.1309840042.git.nsekhar@ti.com> <83915224c24e43224272b1bf570cddb9545279a6.1309840042.git.nsekhar@ti.com> <4E12AC10.9020206@gmail.com> <20110706211054.GE5371@ponder.secretlab.ca> <B85A65D85D7EB246BE421B3FB0FBB593024D9B5379@dbde02.ent.ti.com> <20110707183734.GE2824@ponder.secretlab.ca>
In-Reply-To: <20110707183734.GE2824@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/11 04:37, Grant Likely wrote:
> On Thu, Jul 07, 2011 at 10:15:31PM +0530, Nori, Sekhar wrote:
>> Hi Grant,
>>
>> On Thu, Jul 07, 2011 at 02:40:54, Grant Likely wrote:
>>> On Tue, Jul 05, 2011 at 04:15:44PM +1000, Ryan Mallon wrote:
>>>> On 05/07/11 15:10, Sekhar Nori wrote:
>>>>> Some GPIO controllers have an enable register
>>>>> which needs to be written to before a GPIO
>>>>> can be used.
>>>>>
>>>>> Add support for enabling the GPIO. At this
>>>>> time inverted logic for enabling the GPIO
>>>>> is not supported. This can be done by adding
>>>>> a disable register as and when a controller
>>>>> with this comes along.
>>>>>
>>>>> Signed-off-by: Sekhar Nori<nsekhar@ti.com>
>>>>> ---
>>>>>
>>>> <snip>
>>>>
>>>>> static int bgpio_setup_io(struct bgpio_chip *bgc,
>>>>>  			  void __iomem *dat,
>>>>> @@ -369,6 +401,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
>>>>>  			 void __iomem *clr,
>>>>>  			 void __iomem *dirout,
>>>>>  			 void __iomem *dirin,
>>>>> +			 void __iomem *en,
>>>>>  			 bool big_endian)
>>>> The arguments to this function are getting a bit unwieldy :-). Maybe
>>>> we need to introduce something like:
>>>>
>>>> struct bgpio_chip_info {
>>>>     struct device *dev;
>>>>     unsigned long sz;
>>>>     void __iomem *dat;
>>>>     void __iomem *set;
>>>>     void __iomem *clr;
>>>>     void __iomem *dirout;
>>>>     void __iomem *dirin;
>>>>     void __iomem *en;
>>>>     bool big_endian;
>>>> };
>>>>
>>>> and pass that to bgpio_init instead. It would have the added
>>>> benefits of making the drivers more readable and that
>>>> bgpio_chip_info structs in the drivers can probably be marked
>>>> __initdata also.
>>> Or, what may be better is to make callers directly update the
>>> bgpio_chip structure.
>> I started implementing it this way, but felt that the bgpio_chip
>> structure also has many internal members (like the spinlock) and
>> this method will require users to spend quite a bit of time figuring
>> out which structure members they should initialize and which to leave
>> for bgpio_init() to do for them.
>>
>> There is also the case of direction register which is set from
>> either dirout or dirin depending upon whether the logic is inverted
>> or not. The bgpio_chip however needs to deal with a single direction
>> register offset.
> We *absolutely* still need the helper function for the complex
> settings, but for the non-complex ones, I'd rather just directly
> access the structure.  The kerneldoc documentation of the structure
> can and should be explicit about what the caller is allowed to do.
>
You could pull out all of the user accessible parts the bgpio_chip
structure in to a structure called bgpio_chip_info (or whatever) that
the drivers fill in and pass to bgpio_init, which then gets assigned as
a member of bgpio_chip.

Not sure what you mean about the helper function. If bgpio_init takes a
structure with all of the information about the particular chip then
initialisation of either a simple or complex gpio chip is done using the
same function. Only the number of fields in the bgpio_chip_info
structure which need to be filled in should change.

~Ryan


