Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab2KNUSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:18:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55760 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2KNUS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:18:28 -0500
Message-ID: <50A3FC90.7030105@wwwdotorg.org>
Date: Wed, 14 Nov 2012 13:18:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V6 2/2] kbuild: run the pre-processor on *.dts files
References: <1352753907-3316-1-git-send-email-swarren@wwwdotorg.org> <1352753907-3316-2-git-send-email-swarren@wwwdotorg.org> <20121114192548.59F093E0B7C@localhost>
In-Reply-To: <20121114192548.59F093E0B7C@localhost>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 12:25 PM, Grant Likely wrote:
> On Mon, 12 Nov 2012 13:58:27 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Modify cmd_dtc to run the C pre-processor on the input .dts file before
>> passing it to dtc for final compilation. This allows the use of #define
>> and #include within the .dts file.

> Ugh, I'm definitely nervous about turning this on because of the long
> term implications so I'm going to punt on actually making a decision
> about it for the momemnt. However, I do have a question...

Hmmm. So how do we get to a decision on this then?

>> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
>> index 425578e..33432f4 100644
>> --- a/scripts/Makefile.lib
>> +++ b/scripts/Makefile.lib
>> @@ -269,6 +269,15 @@ cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile
>>  $(obj)/%.dtb: $(src)/dts/%.dts FORCE
>>  	$(call if_changed_dep,dtc)
>>  
>> +dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
>> +
>> +quiet_cmd_dtc_cpp = DTC+CPP $@
>> +cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__ -x assembler-with-cpp -o $(dtc-tmp) $< ; \
>> +	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
>> +
>> +$(obj)/%.dtb: $(src)/dts/%.dtsp FORCE
>> +	$(call if_changed_dep,dtc_cpp)
> 
> Why this instead of a "%.dts: %.dtsp" rule? Then the exact same dtc rule
> gets used in both cases.
> 
> The .dtb rule is probably already rather oddball in that it puts the
> output one directory below the input. That probably should be cleaned
> up.

I was a little nervous about potentially having some *.dts be primary
source files, and others be derived from *.dtsp (assuming that we
convert platforms to this new feature as desired, rather than en-mass).
It seems like it'd just cause confusion; people might just end up
accidentally editing a *.dts that was generated without realizing it.
