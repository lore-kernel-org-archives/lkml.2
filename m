Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2HABko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:40:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11399 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2HABkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:40:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 31 Jul 2012 18:40:41 -0700
Message-ID: <5018898A.4050700@nvidia.com>
Date: Wed, 1 Aug 2012 10:42:34 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <50170EA0.1010408@wwwdotorg.org> <5017B434.2010706@nvidia.com> <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de> <5017CDF9.2060304@firmworks.com>
In-Reply-To: <5017CDF9.2060304@firmworks.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 09:22 PM, Mitch Bradley wrote:
> On 7/31/2012 6:56 PM, Thierry Reding wrote:
>> On Tue, Jul 31, 2012 at 07:32:20PM +0900, Alex Courbot wrote:
>>> On 07/31/2012 07:45 AM, Stephen Warren wrote:
>>>> I wonder if using the same structure/array as input and output would
>>>> simplify the API; the platform data would fill in the fields mentioned
>>>> above, and power_seq_build() would parse those, then set other fields in
>>>> the same structs to the looked-up handle values?
>>>
>>> The thing is that I am not sure what happens to the platform data
>>> once probe() is done. Isn't it customary to mark it with __devinit
>>> and have it freed after probing is successful?
>>
>> No, platform data should stay around forever. Otherwise, consider what
>> would happen if your driver is built as a module and you unload and load
>> it again.
>>
>>> More generally, I think it is a good practice to have data
>>> structures tailored right for what they need to do - code with
>>> members that are meaningful only at given points of an instance's
>>> life tends to be more confusing.
>>
>> I agree. Furthermore the driver unload/reload would be another reason
>> not to reuse platform data as the output of the build() function.
>>
>> But maybe what Stephen meant was more like filling a structure with data
>> taken from the platform data and pass that to a resolve() function which
>> would fill in the missing pieces like pointers to actual resources. I
>> imagine a managed interface would become a little trickier to do using
>> such an approach.
>>
>>>> If the nodes have a unit address (i.e. end in "@n"), which they will
>>>> have to if all named "step" and there's more than one of them, then they
>>>> will need a matching reg property. Equally, the parent node will need
>>>> #address-cells and #size-cells too. So, the last couple lines would be:
>>>>
>>>> 		power-on-sequence {
>>>> 			#address-cells = <1>;
>>>> 			#size-cells = <0>;
>>>> 			step@0 {
>>>> 				reg = <0>;
>>>
>>> That's precisely what I would like to avoid - I don't need the steps
>>> to be numbered and I certainly have no use for a reg property. Isn't
>>> there a way to make it simpler?
>>
>> It's not technically valid to not have the reg property. Or
>> #address-cells and #size-cells properties for that matter.
>
> I'm not keen on this representation where individual steps are nodes.
> That seems like it could end up being too "heavyweight" for a long sequence.

Using nodes has a big advantage though: we can use any arbitrary 
property to add extra parameters to the resource being controlled. Right 
now we only use enable/disable, but for example one can imagine an 
optional voltage setting for a regulator. It is much more future-proof 
than a design where the number of parameters would be fixed and could 
not be extended without breaking compatibility.

I experimented encoding the whole sequence within a single property. It 
works of course, but is not really flexible, hard to read, and quite 
error-prone overall. The memory footprint gain was not so obvious 
neither (although it was indeed more compact).

What bothers me is to have to specify the cells layout and reg property 
for *every single sequence*, but well, I guess we can live with that.

Alex.
