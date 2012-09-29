Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab2I2UYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:24:35 -0400
Received: from 17.mo5.mail-out.ovh.net ([46.105.56.132]:35142 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297Ab2I2UYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:24:33 -0400
Date: Sat, 29 Sep 2012 22:02:22 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [RFC PATCH 2/2] kbuild: introduce cmd_dtc_cpp
Message-ID: <20120929200222.GC31527@game.jcrosoft.org>
References: <1348860731-20868-1-git-send-email-swarren@wwwdotorg.org>
 <1348860731-20868-3-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348860731-20868-3-git-send-email-swarren@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6079578022812429133
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:32 Fri 28 Sep     , Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> cmd_dtc_cpp runs the C pre-processor on the input .dts file before
> passing it to dtc for final compilation. This allows used of #define
> within the .dts file.
> 
> Introduce a new rule for %.dtsp -> %.dtb, which uses cmd_dtc_cpp. A new
> file extension is introduced for this purpose, since use of the pre-
> processor must be optional; any property or node name that starts with
> "#" must be escaped to prevent the pre-processor attempting to interpret
> it as a directive. For this reason, skeleton.dtsi-cpp is introduced for
> *.dts-cpp to include.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/boot/dts/skeleton.dtsip |   13 +++++++++++++
>  scripts/Makefile.lib             |    6 ++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/skeleton.dtsip
> 
> diff --git a/arch/arm/boot/dts/skeleton.dtsip b/arch/arm/boot/dts/skeleton.dtsip
> new file mode 100644
> index 0000000..8bf6729
> --- /dev/null
> +++ b/arch/arm/boot/dts/skeleton.dtsip
> @@ -0,0 +1,13 @@
> +/*
> + * Skeleton device tree; the bare minimum needed to boot; just include and
> + * add a compatible value.  The bootloader will typically populate the memory
> + * node.
> + */
> +
> +/ {
> +	\#address-cells = <1>;
> +	\#size-cells = <1>;
> +	chosen { };
> +	aliases { };
> +	memory { device_type = "memory"; reg = <0 0>; };
> +};
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 425578e..9dd81c0 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -269,6 +269,12 @@ cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile
>  $(obj)/%.dtb: $(src)/dts/%.dts FORCE
>  	$(call if_changed_dep,dtc)
>  
> +quiet_cmd_dtc_cpp = DTC+CPP $@
> +cmd_dtc_cpp = $(CC) -E -Wp,-MD,$(depfile) -xc $< | $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -
> +
> +$(obj)/%.dtb: $(src)/dts/%.dtsp FORCE
> +	$(call if_changed_dep,dtc_cpp)
> +
here no this is build stuff move it to Makefile.build

Best Regards,
J.
