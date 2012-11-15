Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768693Ab2KOSbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:31:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54580 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768673Ab2KOSbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:31:41 -0500
Message-ID: <50A5350A.3070109@wwwdotorg.org>
Date: Thu, 15 Nov 2012 11:31:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH V5 1/2] kbuild: centralize .dts->.dtb rule
References: <CACxGe6vhd_4rcBbYyqtvbySVaY6XpNE+HQq42PZhKe5yt=zcaA@mail.gmail.com> <1352980284-2819-1-git-send-email-grant.likely@secretlab.ca> <50A52FEC.4080409@wwwdotorg.org> <CACxGe6tZOjMXR6CNDzDTSUkcERLiX-2+Qoad0bcPum5Z-Jxaaw@mail.gmail.com>
In-Reply-To: <CACxGe6tZOjMXR6CNDzDTSUkcERLiX-2+Qoad0bcPum5Z-Jxaaw@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 11:20 AM, Grant Likely wrote:
> On Thu, Nov 15, 2012 at 6:09 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 11/15/2012 04:51 AM, Grant Likely wrote:
>>> Grant Likely wrote:
>>>> Or how about: I could pick up the patch with only the MIPS hunk and
>>>> every other user can be fixed up independently to use the new rule.
>>>
>>> Here's a trial patch to fix up ARM. Does this look correct? This patch
>>> depends on the generic dtb build rule already being applied.
>>
>> I think the patch looks OK technically, except for one minor comment below.
>>
>> One issue with this patch is that it moves *.dts from arch/arm/boot to
>> arch/arm/boot/dts, which means everyone has to adjust their scripts/...
>> that package/install/... the kernel. I guess it's an easy change for
>> people to make, but could easily catch people unawares if they do
>> incremental builds so that arch/arm/boot/*.dtb still exists but is stale.
> 
> True. We could temporarily remove or rename if the same file exists in
> the directory below to help people catch that problem. I really would
> like to clean up that build rule to be consistent though.
> 
> The other option is to move all the .dts files into the boot
> directory, but I don't think that is a good idea at all.

Maybe we can just add "rm *.dtb" to the following rules in
boot/Makefile, before calling the child make?

%.dtb: scripts
-	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@

 dtbs: scripts
-	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) dtbs

>>> +targets += dtbs
>>
>> Doesn't that make the "dtbs" target always run by default? Perhaps
>> that's reasonable though, and doesn't actually affect anything since the
>> make command for this directory always specifies an explicit target?
>>
>> Or, was that meant to be the following that got removed from ../Makefile?
>>
>> targets += $(dtb-y)
> 
> Yes it is supposed to be the same thing. Doesn't it effectively do the
> same since dtbs depends on $(dtb-y)?

Ah, I think so yes.

I guess anyway that $(targets) is presumably ignored if an explicit
build target is requested from make.
