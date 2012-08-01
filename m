Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2HACsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 22:48:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9459 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2HACso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 22:48:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 31 Jul 2012 19:48:43 -0700
Message-ID: <5018997B.7010808@nvidia.com>
Date: Wed, 1 Aug 2012 11:50:35 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <20120730113323.GA7303@avionic-0098.adnet.avionic-design.de> <5017AA87.2040503@nvidia.com> <20120731101931.GB16155@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120731101931.GB16155@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 07:19 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jul 31, 2012 at 06:51:03PM +0900, Alex Courbot wrote:
>> On 07/30/2012 08:33 PM, Thierry Reding wrote:
>>>> +You will need an instance of power_seq_resources to keep track of the resources
>>>> +that are already allocated. On success, the function returns a devm allocated
>>>> +resolved sequence that is ready to be passed to power_seq_run(). In case of
>>>> +failure, and error code is returned.
>>>
>>> I don't quite understand why the struct power_seq_resources is needed.
>>> Can this not be stored within power_seq?
>>
>> power_seq_resources serves two purposes:
>> 1) When parsing sequences, it keeps track of the resources we have
>> already allocated to avoid getting the same resource twice
>> 2) On cleanup, it cleans the resources that needs to be freed (i.e.
>> those that are not devm-handled).
>>
>> 2) can certainly be removed either by enforcing use of devm, or by
>> doing reference counting. 1) seems more difficult to avoid - we need
>> to keep track of the resources we already own between calls to
>> power_seq_build(). I'd certainly be glad to remove that structure
>> from public view and simplify the code if that is possible though.
>
> I still don't see the problem. Managing the resources should be part of
> the power_seq core and shouldn't be visible to users. Maybe what you are
> worried about is that you may need the same resource both for a power-up
> and a power-down sequence? I can see how that would require a global
> list of resources.

Yes, that is precisely my concern. Sorry for not stating that more clearly.

> However I still think it would be easier to encapsulate that completely.
> Maybe another level of abstraction is required. You could for example
> add another type to encapsulate several power sequences and that could
> keep a list of used resources. I can't think of a good name, but maybe
> the following DT snippet clarifies what I mean:
>
>          power-sequences {
>                  #address-cells = <1>;
>                  #size-cells = <0>;
>
>                  sequence@0 {
>                          name = "up";
>
>                          #address-cells = <1>;
>                          #size-cells = <0>;
>
>                          step@0 {
>                                  ...
>                          };
>
>                          ...
>                  };
>
>                  sequence@1 {
>                          name = "down";
>
>                          #address-cells = <1>;
>                          #size-cells = <0>;
>
>                          step@0 {
>                                  ...
>                          };
>
>                          ...
>                  };
>          };
>
> If you add a name property like this, you could extend the API to
> support running a named sequence:
>
>          power_seq_run(seq, "up");
>          ...
>          power_seq_run(seq, "down);

Mmm, that's something to consider. Forcing power sequences to be grouped 
within a "power-sequences" node would also make parsing easier from the 
driver side since it would not have to explicitly parse every sequence. 
We could even imagine some tighter integration with the device subsystem 
to automatically run specifically-named sequences during suspend/resume. 
But maybe I'm thinking too much here.

>
>>> Also, is there some way we can make the id property for GPIOs not
>>> require the -gpio suffix? If the resource type is already GPIO, then it
>>> seems redundant to add -gpio to the ID.
>>
>> There is unfortunately an inconsistency between the way regulators
>> and GPIOs are gotten by name. regulator_get(id) will expect to find
>> a property named "id-supply", while gpio_request_one(id) expects a
>> property named exactly "id". To workaround this we could sprintf the
>> correct property name from a non-suffixed property name within the
>> driver, but I think this actually speaks more in favor of having
>> phandles directly into the sequences.
>
> Yes, if it can be made to work by specifying the phandle directly that
> is certainly better.

Let's do that then - as for the PWM issue I had, let's address that by 
clearly stating in the documentation that phandles referring to a same 
device *must* be identical.

>>>> +     if (!seq) return 0;
>>>
>>> I don't think this is acceptable according to the coding style. Also,
>>> perhaps returning -EINVAL would be more meaningful?
>>
>> I neglected running checkpatch before submitting, apologies for
>> that. The return value seems correct to me, a NULL sequence has no
>> effect.
>
> But seq == NULL should never happen anyway, right?

It could if you are parsing a NULL node. It seems safe to me to consider 
that a NULL sequence is an empty sequence, but if I go for your solution 
involving another data structure to encapsulate the sequence, then this 
might change.

>>> Perhaps this should check for POWER_SEQ_STOP instead?
>>
>> There is no resource for POWER_SEQ_STOP - therefore, a NULL resource
>> is used instead.
>
> Still, you use POWER_SEQ_STOP as an explicit sentinel to mark the end of
> a sequence, so intuitively I'd be looking for that as a stop condition.

That is for platform data - resolved sequences get their type from their 
resource, and a STOP sequence does not have a resource. But the STOP 
type will go away too since we will have a steps count in the platform 
data instead.

>> I would like to do that actually. The issue is that it did not work
>> go well with the legacy pwm_backlight behavior: a power sequence
>> needs to be constructed out of a PWM obtained through
>> pwm_request(int pwm_id, char *label) and this behavior cannot be
>> emulated using the new platform data interface (which only works
>> with pwm_get()). But if I remove this old behavior, then I could
>> make power_seq opaque. I don't think many drivers are using it. What
>> do you think?
>
> I don't see how that is relevant here, since this power-sequencing code
> is supposed to be generic and not tied to any specific implementation.
> Can you explain further?
>
> In any case you shouldn't be using pwm_request() in new code.

Power sequences only rely on pwm_get, and never call pwm_request since 
it is, as you stated, deprecated. However there are still boards that 
use the old pwm_id member of the pwm_backlight_platform_data. For these, 
we must call pwm_request from the pwm_backlight driver in order to 
resolve the PWM (see pwm_backlight_legacy_probe of the seconds patch). 
As the PWM is being resolved by the backlight driver, and not within the 
power sequences parser, the resolved data structure must be visible to 
pwm_backlight so it can construct it. There are two ways to solve this 
and keep the power sequences structure private:

1) Add a way to resolve a PWM by id using pwm_request in the power 
sequences (we probably should not do that)
2) Port the old platform pwm_request code to use pwm_add_table and 
pwm_get instead.

Do I get points if I do 2)? :)

Thanks,
Alex.

