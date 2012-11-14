Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423376Ab2KNTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:25:56 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48641 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423247Ab2KNTZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:25:53 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V6 2/2] kbuild: run the pre-processor on *.dts files
To: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>
Cc: David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <1352753907-3316-2-git-send-email-swarren@wwwdotorg.org>
References: <1352753907-3316-1-git-send-email-swarren@wwwdotorg.org> <1352753907-3316-2-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 14 Nov 2012 19:25:48 +0000
Message-Id: <20121114192548.59F093E0B7C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 13:58:27 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Modify cmd_dtc to run the C pre-processor on the input .dts file before
> passing it to dtc for final compilation. This allows the use of #define
> and #include within the .dts file.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> v6: No change.
> v5:
> * Update Documentation/kbuild for the new command and rule.
> v4:
> * Use -x assembler-with-cpp so pre-defined macros are set up so that
>   #included header files know to only use cpp syntax, not C syntax.
> * Define __DTS__ for similar reasons.
> * use $(CPP) not $(CC) -E, and use $(cpp_flags).
> * Save the pre-processed results so they can be easily inspected when
>   debugging build issues.
> * The use of -x assembler-with-cpp causes cpp to recognize directives in
>   column 1 only. Hence, there's no need to escape property names that
>   begin with #. Hence, there's no need for separate skeleton.dtsi and
>   skeleton.dtsip. Maintain a separate file extension and build rule so that
>   CPP-usage is opt-in. In particular, when using CPP, #include must be used
>   rather than /include/ so that dependencies work.
> v3: Pass "-x c" not "-xc" to cpp.
> v2: Place make %.dtb: %.dtsp rule into Makefile.lib.

Ugh, I'm definitely nervous about turning this on because of the long
term implications so I'm going to punt on actually making a decision
about it for the momemnt. However, I do have a question...

> ---
>  Documentation/kbuild/makefiles.txt |   23 +++++++++++++++++++++++
>  scripts/Makefile.lib               |    9 +++++++++
>  2 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index a0b0671..dfe6838 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -1194,6 +1194,29 @@ When kbuild executes, the following steps are followed (roughly):
>  
>  		clean-files += ... *.dtb
>  
> +    dtc_cpp
> +	This is just like dtc as describe above, except that the C pre-
> +	processor is invoked upon the .dtsp file before compiling the result
> +	with dtc.
> +
> +	In order for build dependencies to work, all files compiled using
> +	dtc_cpp must use the C pre-processor's #include functionality and not
> +	dtc's /include/ functionality.
> +
> +	Using the C pre-processor allows use of #define to create named
> +	constants. In turn, the #defines will typically appear in a header
> +	file, which may be shared with regular C code. Since the dtc language
> +	represents a data structure rather than code in C syntax, similar
> +	restrictions are placed on a header file included by a device tree
> +	file as for a header file included by an assembly language file.
> +	In particular, the C pre-processor is passed -x assembler-with-cpp,
> +	which sets macro __ASSEMBLY__. __DTS__ is also set. These allow header
> +	files to restrict their content to that compatible with device tree
> +	source.
> +
> +	A central rule exists to create $(obj)/%.dtb from $(src)/dts/%.dtsp;
> +	architecture Makefiles do no need to explicitly write out that rule.
> +
>  --- 6.8 Custom kbuild commands
>  
>  	When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 425578e..33432f4 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -269,6 +269,15 @@ cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile
>  $(obj)/%.dtb: $(src)/dts/%.dts FORCE
>  	$(call if_changed_dep,dtc)
>  
> +dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
> +
> +quiet_cmd_dtc_cpp = DTC+CPP $@
> +cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__ -x assembler-with-cpp -o $(dtc-tmp) $< ; \
> +	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
> +
> +$(obj)/%.dtb: $(src)/dts/%.dtsp FORCE
> +	$(call if_changed_dep,dtc_cpp)

Why this instead of a "%.dts: %.dtsp" rule? Then the exact same dtc rule
gets used in both cases.

The .dtb rule is probably already rather oddball in that it puts the
output one directory below the input. That probably should be cleaned
up.

g.
