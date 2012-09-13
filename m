Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab2IMPo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:44:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35922 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab2IMPoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:44:22 -0400
Message-ID: <5051FF51.1080800@wwwdotorg.org>
Date: Thu, 13 Sep 2012 09:44:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <1347443867-18868-2-git-send-email-acourbot@nvidia.com> <50510791.8080302@wwwdotorg.org> <3678448.5nUOr4ZZV4@percival>
In-Reply-To: <3678448.5nUOr4ZZV4@percival>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 12:02 AM, Alex Courbot wrote:
> On Thursday 13 September 2012 06:07:13 Stephen Warren wrote:
>> On 09/12/2012 03:57 AM, Alexandre Courbot wrote:
>>> Some device drivers (panel backlights especially) need to follow precise
>>> sequences for powering on and off, involving gpios, regulators, PWMs
>>> with a precise powering order and delays to respect between each steps.
>>> These sequences are board-specific, and do not belong to a particular
>>> driver - therefore they have been performed by board-specific hook
>>> functions to far.
>>>
>>> With the advent of the device tree and of ARM kernels that are not
>>> board-tied, we cannot rely on these board-specific hooks anymore but
>>> need a way to implement these sequences in a portable manner. This patch
>>> introduces a simple interpreter that can execute such power sequences
>>> encoded either as platform data or within the device tree.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>>
>>> diff --git a/Documentation/power/power_seq.txt
>>> b/Documentation/power/power_seq.txt
>>>
>>> +Sometimes, you may want to browse the list of resources allocated by a
>>> sequence, +for instance to ensure that a resource of a given type is
>>> present. The +power_seq_set_resources() function returns a list head that
>>> can be used with +the power_seq_for_each_resource() macro to browse all
>>> the resources of a set: +
>>> +  struct list_head *power_seq_set_resources(struct power_seq_set *seqs);
>>> +  power_seq_for_each_resource(pos, seqs)
>>> +
>>> +Here "pos" will be a pointer to a struct power_seq_resource. This
>>> structure +contains the type of the resource, the information used for
>>> identifying it, and +the resolved resource itself.
>>
>> I don't think you need to include that [power_seq_set_resources] prototype
>> here?
> 
> Why not? I thought it was customary to include the prototypes in the 
> documentation, and this seems to be the right place for this function.

It's something used internally to the macro; what the user cares about
is which macro to use for the functionality you're describing, not any
prototypes needed by the internal implementation of the macro, which are
always provided by the appropriate header.

>>> diff --git a/drivers/power/power_seq/power_seq.c
>>> b/drivers/power/power_seq/power_seq.c
>>>
>>> +struct power_seq_step {
>>> +	/* Copy of the platform data */
>>> +	struct platform_power_seq_step pdata;
>>
>> I'd reword the comment to "Copy of the step", and name the field "step".
> 
> That would make a step within a step - doesn't pdata make it more explicit 
> what this member is for (containing the platform data for this step)?

Well, it's not always platform data; it could come from device tree.
Sorry for bike-shedding slightly, but how about just "data",
"step_data", "config", or "step_config"?

>>> +static const struct power_seq_res_ops
>>> power_seq_types[POWER_SEQ_NUM_TYPES] = { +	[POWER_SEQ_DELAY] =
>>> POWER_SEQ_DELAY_TYPE,
>>> +	[POWER_SEQ_REGULATOR] = POWER_SEQ_REGULATOR_TYPE,
>>> +	[POWER_SEQ_PWM] = POWER_SEQ_PWM_TYPE,
>>> +	[POWER_SEQ_GPIO] = POWER_SEQ_GPIO_TYPE,
>>> +};
>>
>> Ah, I see why you're using #include now.
> 
> We could also go with something more dynamic and compile these files 
> separately, but that would require some registration mechanism which I don't 
> think is needed for such a simple feature.

Sure. There are already examples in the kernel of basically what you're
doing anyway, and it's not like it'd be hard to change this if we want
to do something different in the future too.
