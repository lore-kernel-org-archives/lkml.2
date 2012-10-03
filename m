Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2JCIWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:22:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10338 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab2JCIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:22:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 03 Oct 2012 01:20:29 -0700
Message-ID: <506BF62F.6040308@nvidia.com>
Date: Wed, 3 Oct 2012 17:24:15 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <4473898.CeAQBgUhKL@percival> <20120913071928.GA20959@opensource.wolfsonmicro.com> <1378218.yLeQheNFT0@percival> <20120913072943.GB20959@opensource.wolfsonmicro.com> <5051FAC5.40501@wwwdotorg.org>
In-Reply-To: <5051FAC5.40501@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 12:24 AM, Stephen Warren wrote:
> On 09/13/2012 01:29 AM, Mark Brown wrote:
>> On Thu, Sep 13, 2012 at 04:26:34PM +0900, Alex Courbot wrote:
>>> On Thursday 13 September 2012 15:19:30 Mark Brown wrote:
>>>>> On Thursday 13 September 2012 14:25:53 Mark Brown wrote:
>>>>>> It would be sensible to make sure that the framework is done in such a
>>>>>> way that drivers can use it - there will be drivers (perhaps not display
>>>>>> ones) that have a known power sequence and which could benefit from the
>>>>>> ability to use library code to implement it based on the user simply
>>>>>> supplying named resources.
>>
>>>>> Not sure I understand what you mean, but things should be working this way
>>>>> already - regulators and PWMs are acquired by name using the standard
>>>>> regulator_get() and pwm_get() functions. GPIOs do not, AFAIK, have a way
>>>>> to be referenced by name so their number is used instead.
>>
>>>> Right, but the sequencing for enabling them is currently open coded in
>>>> each driver.
>>
>>> Mmm then I'm afraid I don't see what you wanted to say initially - could you
>>> elaborate?
>>
>> The driver knows the power sequence.  Having to type the same sequence
>> into the DT or platform data for each board using the device wouuld be
>> retarded so we need the drivers to be able to give the sequence to the
>> library if they're going to be able to reuse it (which is a lot of what
>> Tomi is talking about).
>
> I believe that's trivial to implement. The relevant function is:
>
> struct power_seq_set *devm_power_seq_set_build(struct device *dev,
> 		   struct platform_power_seq_set *pseq);
>
> It's up to the driver whether pseq comes from platform data or is
> hard-coded into the driver (or not provided at all, for the DT case).
> So, the only change needed to convert a "hard-coded" driver to this API
> is to convert the current custom data structure (or code) that describes
> the sequence into a struct platform_power_seq_set.

If we go this way (which looks good IMO!), then maybe we should abandon 
that "platform" denomination and merge platform_power_seq* structures 
with the currently private power_seq*, and also replace the "building" 
step with a resources acquisition one. Calling these structures 
"platform" implies they are for platform data while they can be used to 
perform more flexible things as Mark mentioned. Also making the resolved 
resource visible would allow drivers to "patch" generic sequences with 
the proper GPIO numbers at runtime. We would also avoid a few memory 
copies and both design and usage would be simplified, at the cost of 
having more things exposed. How does that sound?

Alex.

