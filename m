Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2KGRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:25:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49558 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2KGRZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:25:27 -0500
Message-ID: <509A9984.3000709@wwwdotorg.org>
Date: Wed, 07 Nov 2012 10:25:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com> <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com> <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com> <5ED17D42-07B8-4D4F-B54F-82B4CC60584C@antoniou-consulting.com> <509A3595.7050600@ti.com>
In-Reply-To: <509A3595.7050600@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 03:19 AM, Benoit Cousson wrote:
> Hi Panto,
> 
> On 11/07/2012 09:13 AM, Pantelis Antoniou wrote:
>> Hi Grant
>>
>> On Nov 6, 2012, at 9:45 PM, Grant Likely wrote:
>>
>>> On Tue, Nov 6, 2012 at 7:34 PM, Pantelis Antoniou
>>> <panto@antoniou-consulting.com> wrote:
>>
>> [ snip ]
>>>
>>> g.
>>
>> Since we've started talking about longer term goals, and the versioning
>> provision seems to stand, I hope we address how much the fragment versioning
>> thing is similar to the way board revisions progress.
>>
>> If a versioning syntax is available then one could create a single DT 
>> file for a bunch of 'almost' similar board and board revisions.
> 
> I even think that the version issue is probably much more important for the short term than the overlay aspect. Well at least as important. We start having as well a bunch a panda board version with different HW setup.
> 
> Having a single board-XXX.dts that will support all these versions is probably the best approach to avoid choosing that from the bootloader.
> 
> We need to figure out a format + mechanism compatible with the current non-versioned format to allow filtering the nodes at runtime to keep only the relevant one.
> 
> Something that can find the driver that will provide the proper board version or subsystem version or whatever like that:
> 
> 	compatible-version = "ti,panda-version", "panda";
> 
> Then at runtime we should create only the node with the correct match between the driver version and the string version.
> 
> 
> /* regular panda audio routing */
> sound: sound {
> 	compatible = "ti,abe-twl6040";
> 	ti,model = "PandaBoard";
> 	compatible-version = "ti,panda-version", "panda";
> 
> 	/* Audio routing */
> 	ti,audio-routing =
> 		"Headset Stereophone", "HSOL",
> 		"Headset Stereophone", "HSOR",
> 		"Ext Spk", "HFL",
> 		"Ext Spk", "HFR",
> 		"Line Out", "AUXL",
> 		"Line Out", "AUXR",
> 		"HSMIC", "Headset Mic",
> 		"Headset Mic", "Headset Mic Bias",
> 		"AFML", "Line In",
> 		"AFMR", "Line In";
> };
> 
> 
> /* Audio routing is different between PandaBoard4430 and PandaBoardES */
> &sound {
> 	ti,model = "PandaBoardES";
> 	compatible-version = "ti,panda-version", "panda-es";
> 
> 	/* Audio routing */
> 	ti,audio-routing =
> 		"Headset Stereophone", "HSOL",
> 		"Headset Stereophone", "HSOR",
> 		"Ext Spk", "HFL",
> 		"Ext Spk", "HFR",
> 		"Line Out", "AUXL",
> 		"Line Out", "AUXR",
> 		"AFML", "Line In",
> 		"AFMR", "Line In";
> };
> 
> 
> Maybe some extra version match table can just be passed during the board machine_init 
> 
> 	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL, panda_version_match_table);

Is the only difference here the content of the ti,audio-routing
property? If so, then I don't think there's any need for infra-structure
for this; the driver code already reads that property and adjusts its
behaviour based upon it.

I do see that "Headset Mic" exists only in one of the tables above.
Perhaps the driver could scan the routing table, and only create the
ASoC object for the headset if it's mentioned in the routing table?

If there are additional differences, then you can always use the .data
field in of_device_id to automatically associate some configuration data
with different compatible values.

Even better might be to extend the binding so that all HW differences
are represented explicitly as properties; that way you wouldn't even
need different compatible values.
