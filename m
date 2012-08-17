Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030966Ab2HQIuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:50:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5651 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2HQIuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:50:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 17 Aug 2012 01:50:16 -0700
Message-ID: <502E0635.6030309@nvidia.com>
Date: Fri, 17 Aug 2012 17:52:05 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com> <1345097337-24170-2-git-send-email-acourbot@nvidia.com> <502D3E29.1010501@wwwdotorg.org>
In-Reply-To: <502D3E29.1010501@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 03:38 AM, Stephen Warren wrote:
> On 08/16/2012 12:08 AM, Alexandre Courbot wrote:
>> Some device drivers (panel backlights especially) need to follow precise
>> sequences for powering on and off, involving gpios, regulators, PWMs
>> with a precise powering order and delays to respect between each steps.
>> These sequences are board-specific, and do not belong to a particular
>> driver - therefore they have been performed by board-specific hook
>> functions to far.
>>
>> With the advent of the device tree and of ARM kernels that are not
>> board-tied, we cannot rely on these board-specific hooks anymore but
>> need a way to implement these sequences in a portable manner. This patch
>> introduces a simple interpreter that can execute such power sequences
>> encoded either as platform data or within the device tree.
>
>> diff --git a/Documentation/devicetree/bindings/power_seq/power_seq.txt b/Documentation/devicetree/bindings/power_seq/power_seq.txt
>
>> +Specifying Power Sequences in the Device Tree
>> +=============================================
>> +In the device tree, power sequences are specified as sub-nodes of the device
>> +node and reference resources declared by that device.
>> +
>> +For an introduction about runtime interpreted power sequences, see
>> +Documentation/power/power_seq.txt and include/linux/power_seq.h.
>
> Device tree bindings shouldn't reference Linux documentation; the
> bindings are supposed to be OS-agnostic.

Ok, I should be able to do without this reference anyway.

>
>> +Power Sequences Structure
>> +-------------------------
>> +Power sequences are sub-nodes that are named such as the device driver can find
>> +them. The driver's documentation should list the sequence names it recognizes.
>
> That's a little roundabout. That might be better as simply:
>
> Valid power sequence names are defined by each device's binding. For a
> power sequence named "foo", a node named "foo-power-sequence" defines
> that sequence.
>
>> +Inside a power sequence node are sub-nodes that describe the different steps
>> +of the sequence. Each step must be named sequentially, with the first step
>> +named step0, the second step1, etc. Failure to follow this rule will result in a
>> +parsing error.
>
> Node names shouldn't be interpreted by the code; nodes should all be
> named after the type of object the represent. Hence, every step should
> be named just "step" for example.
>
> The node's unit address (@0) should be used to distinguish the nodes.
> This requires reg properties within each node to match the unit address,
> and hence #address-cells and #size-cells properties in the power
> sequence itself.

While this logic is perfectly suitable and adapted for devices, I think 
we should keep in mind that power sequences and their steps are not 
devices, but just arbitrary bits of information. Having adress cells and 
reg properties is useful when one needs to reference a node through a 
phandle, but this is *never* going to happen with sequence steps (unless 
we go insane and decide to allow goto-like statements :P). So having 
#address-cells, #size-cells, and reg serve absolutely no purpose here 
but cluttering the DT. If there is a hard rule that needs to be 
enforced, then let that be, but the other discussion you started (thanks 
for that by the way) does not seem to suggest so.

> Note that this somewhat conflicts with accessing the top-level power
> sequence by name too; perhaps that should be re-thought too. I must
> admit this DT rule kinda sucks.
>
>> +Power Sequences Steps
>> +---------------------
>> +Every step of a sequence describes an action to be performed on a resource. It
>> +generally includes a property named after the resource type, and which value
>> +references the resource to be used. Depending on the resource type, additional
>> +properties can be defined to control the action to be performed.
>
> I think you need to add a property that indicates what type of resource
> each step applies to. Sure, this is implicit in that if a "gpio"
> property exists, the step is a GPIO step, but in order to make that
> work, you'd have to search each node for each possible resource type's
> property name. It'd be far better to read a single type="gpio" property,
> then parse the step based on that.

Indeed right now all resource types must be checked. Having a type 
property would make that easier. I like to keep the DT as compact and 
expressive as possible, but I guess one more property per step would not 
hurt and is perhaps easier to understand too.

>> +Example
>> +-------
>> +Here are example sequences declared within a backlight device that use all the
>> +supported resources types:
>> +
>> +     backlight {
>> +             compatible = "pwm-backlight";
>> +             ...
>> +
>> +             /* resources used by the sequences */
>> +             pwms = <&pwm 2 5000000>;
>> +             pwm-names = "backlight";
>> +             power-supply = <&backlight_reg>;
>> +             enable-gpio = <&gpio 28 0>;
>> +
>> +             power-on-sequence {
>> +                     step0 {
>> +                             regulator = "power";
>> +                             enable;
>> +                     };
>> +                     step1 {
>> +                             delay = <10000>;
>> +                     };
>> +                     step2 {
>> +                             pwm = "backlight";
>> +                             enable;
>> +                     };
>> +                     step3 {
>> +                             gpio = "enable";
>> +                             enable;
>> +                     };
>> +             };
>> +
>> +             power-off-sequence {
>> +                     step0 {
>> +                             gpio = "enable";
>> +                             disable;
>> +                     };
>> +                     step1 {
>> +                             pwm = "backlight";
>> +                             disable;
>> +                     };
>> +                     step2 {
>> +                             delay = <10000>;
>> +                     };
>> +                     step3 {
>> +                             regulator = "power";
>> +                             disable;
>> +                     };
>> +             };
>> +     };
>
> I notice that for clocks, pwms, and interrupts, the initial step of the
> lookup is via a single property that lists all know resources of that
> type. Regulators and GPIOs don't follow this style though. Using the
> same mechanism for power-sequences would yield something like the
> following, which would avoid the "node names must be significant" issue
> I mention above, although it does make everything rather more wordy.
>
> [start my proposal]
>>        backlight {
>>                compatible = "pwm-backlight";
>>
>>                /* resources used by the sequences */
>>                pwms = <&pwm 2 5000000>;
>>                pwm-names = "backlight";
>>                power-supply = <&backlight_reg>;
>>                bl-enable-gpio = <&gpio 28 0>;
>>                pwr-seqs = <&bl_on &bl_off>;
>>                pwr-seq-names = "on", "off";
>>
>>                #address-cells = <1>;
>>                #size-cells = <0>;
>>
>>                bl_on: pwr-seq@0 {
>>                        reg = <0>;
>>                        #address-cells = <1>;
>>                        #size-cells = <0>;
>>                        step@0 {
>>                                reg = <0>;
>>                                type = "regulator";
>>                                regulator = "power";
>>                                enable;
>>                        };
>>                        step@1 {
>>                                reg = <1>;
>>                                type = "delay";
>>                                delay = <10000>;
>>                        };
>>                        step@2 {
>>                                reg = <2>;
>>                                type = "pwm";
>>                                pwm = "backlight";
>>                                enable;
>>                        };
>>                        step@3 {
>>                                reg = <3>;
>>                                type = "gpio";
>>                                gpio = "bl-enable";
>>                                enable;
>>                        };
>>                };
>>
>>                bl_off: pwr-seq@1 {
>>                        reg = <1>;
>>                        #address-cells = <1>;
>>                        #size-cells = <0>;
>>                        step@0 {
>>                                reg = <0>;
>>                                type = "gpio";
>>                                gpio = "bl-enable";
>>                                disable;
>>                        };
>>                        step@1 {
>>                                reg = <1>;
>>                                type = "pwm";
>>                                pwm = "backlight";
>>                                disable;
>>                        };
>>                        step@2 {
>>                                reg = <2>;
>>                                type = "delay";
>>                                delay = <10000>;
>>                        };
>>                        step@3 {
>>                                reg = <3>;
>>                                type = "regulator";
>>                                regulator = "power";
>>                                disable;
>>                        };
>>                };
>>        };
>>
> [end my proposal]

Mmmm, so looking at this, what strikes me is that the amount of 
unused/redundant information is actually higher than the amount of 
information the driver will effectively use. If these conventions can be 
ignored here, we definitely should do that.

>
>> diff --git a/Documentation/power/power_seq.txt b/Documentation/power/power_seq.txt
>
>> +Usage by Drivers and Resources Management
>> +-----------------------------------------
>> +Power sequences make use of resources that must be properly allocated and
>> +managed. The power_seq_build() function builds a power sequence from the
>> +platform data. It also takes care of resolving and allocating the resources
>> +referenced by the sequence if needed:
>> +
>> +  struct power_seq *power_seq_build(struct device *dev, struct list_head *ress,
>> +                                    struct platform_power_seq *pseq);
>> +
>> +The 'dev' argument is the device in the name of which the resources are to be
>> +allocated.
>> +
>> +The 'ress' argument is a list to which the resolved resources are appended. This
>> +avoids allocating a resource referenced in several power sequences multiple
>> +times.
>
> I see in other parts of the thread, there has been discussion re:
> needing the separate ress parameter, and requiring the driver to pass
> this in to multiple power_seq_build calls.
>
> The way the pinctrl subsystem solved this was to have a single function
> that parsed all pinctrl setting (c.f. all power sequences) at once, and
> return a single handle. Later, the driver passes this handle
> pinctrl_lookup_state(), along with the requested state (c.f. sequence
> name) to search for, and finally passes that handle to
> pinctrl_select_state(). Doing something similar here would result in:
>
> struct power_seqs *power_seq_get(struct device *dev);
> void power_seq_put(struct power_seqs *seqs);
> struct power_seq *power_seq_lookup(struct power_seqs *seqs,
>                                  const char *name);
> int power_seq_executestruct power_seq *seq);
>
> struct power_seqs *devm_power_seq_get(struct device *dev);
> void devm_power_seq_put(struct power_seqs *seqs);

Well, if both of you bring this then I have no choice but seriously 
consider that. :) If other subsystems follow the same scheme then this 
is an additional point for this.

>
>> +On success, the function returns a devm allocated resolved sequence that is
>
> Perhaps the function should be named devm_power_seq_build(), in order to
> make this obvious to people who only read the client code, and not this
> documentation.

Agreed.

Thanks,
Alex.

