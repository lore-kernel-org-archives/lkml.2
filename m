Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab2IKWRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:17:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40192 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2IKWRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:17:18 -0400
Message-ID: <504FB869.60201@wwwdotorg.org>
Date: Tue, 11 Sep 2012 16:17:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/9] pinctrl: mvebu: pinctrl driver core
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com> <20120911164409.4c030bd8@skate>
In-Reply-To: <20120911164409.4c030bd8@skate>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 08:44 AM, Thomas Petazzoni wrote:
> Hello Sebastian,
> 
> Sorry for getting back to you so late about this patch set. I have been
> very busy with other things.
> 
> Le Mon, 10 Sep 2012 10:39:38 +0200,
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> 
>> v3:
>> - list of functions is now built out of pin groups passed to core driver
>>   instead of parsing DT node.
> 
> Even though I have gone through your discussion with Stephen Warren on
> this, I don't get what you have done exactly, and I'm even more puzzled
> by the following piece of code:
> 
>> +static int __devinit _add_function(const char **funcs, const char *name)
>> +{
>> +	int n = 0;
>> +
>> +	while (funcs[n]) {
>> +		/* function already there */
>> +		if (strcmp(funcs[n], name) == 0)
>> +			return -EEXIST;
>> +		n++;
>> +	}
>> +	funcs[n] = name;
>> +	return 0;
>> +}
>> +
>> +static int __devinit mvebu_pinctrl_build_functions(struct platform_device *pdev,
>> +						   struct mvebu_pinctrl *pctl)
>> +{
>> +	const char **prefunc = kzalloc(sizeof(char *), GFP_KERNEL);
>> +	int num = 0;
>> +	int n, s;
>> +
>> +	for (n = 0; n < pctl->num_groups; n++) {
>> +		struct mvebu_pinctrl_group *grp = &pctl->groups[n];
>> +		for (s = 0; s < grp->num_settings; s++) {
>> +			/* skip unsupported settings on this variant */
>> +			if (pctl->variant &&
>> +			    !(pctl->variant & grp->settings[s].variant))
>> +				continue;
>> +
>> +			/* check for unique functions */
>> +			if (_add_function(prefunc, grp->settings[s].name))
>> +				continue;
>> +
>> +			num++;
>> +		}
>> +	}
>> +	return 0;
>> +}
> 
> What is this supposed to do? It allocates an array prefunc, whose
> reference is only stored in a local variable, and anywhere else, so
> basically it does nothing except leaking memory unless I got it wrong.

I imagine this is related to the way that the SoC-specific drivers
provide their configuration to the generic core driver. I'm not sure the
data structures used for this purpose are the best design.

The pinctrl core expects lists of:

* Pins

* Groups of pins (each being a name and an array of pins in the group)

* Functions that can be muxed onto the groups (each function being a
global entity rather than something with a pin or group, and each
function being a name, and an array of groups where the function can be
selected).

However, the drivers in this patch seem to invert the data-structures a
little - in other words, instead of defining a global list of functions,
they define a list of groups, and for each group, list the functions
that can be selected on to it.

In turn, that probably requires the core mvebu driver to invert these
data-structures at run-time in order to provide the data the pinctrl
core needs. I think it'd be better to just have each SoC-specific driver
store the data tables in the same format that the pinctrl core needs it,
so that the mvebu pinctrl core won't have to process the data-structures
at all.

In particular, the following data structure is what I'm talking about:

+static struct mvebu_mpp_mode dove_mpp_modes[] = {
+	MPP_MODE(0,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart2", "rts"),
+		MPP_FUNCTION(0x03, "sdio0", "cd"),
+		MPP_FUNCTION(0x0f, "lcd0", "pwm"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),

it's defining the functions within the context of a particular group
("mode" in the drivers terminology, I think...) rather than defining
functions and groups as separate top-level tables.
