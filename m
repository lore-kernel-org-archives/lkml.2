Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667Ab2JZT54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:57:56 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33906 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966285Ab2JZT5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:57:54 -0400
Message-ID: <508AEB3E.6090405@gmail.com>
Date: Fri, 26 Oct 2012 14:57:50 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4 REPOST 2/2] kbuild: run the pre-processor on *.dts
 files
References: <1351279797-16450-1-git-send-email-swarren@wwwdotorg.org> <1351279797-16450-2-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1351279797-16450-2-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 02:29 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Modify cmd_dtc to run the C pre-processor on the input .dts file before
> passing it to dtc for final compilation. This allows the use of #define
> and #include within the .dts file.

While this change is small the implications are not. I don't think no
comments reflects agreement on this.

Like I said previously, I think we first need guidelines on what is and
isn't acceptable use of C preprocessor in dts files.

Rob

> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
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
> ---
>  scripts/Makefile.lib |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
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
> +
>  # Bzip2
>  # ---------------------------------------------------------------------------
>  
> 
