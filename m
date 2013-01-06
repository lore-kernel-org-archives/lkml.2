Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3AFCyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 21:54:08 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:55899 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3AFCx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 21:53:58 -0500
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2013 21:53:58 EST
Date: Sat, 05 Jan 2013 20:24:43 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 6/6] OF: Introduce DT overlay support.
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jon Loeliger <jdl@jdl.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1357327870-13615-7-git-send-email-panto@antoniou-consulting.com>
	(from panto@antoniou-consulting.com on Fri Jan  4 13:31:10 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1357439083.31232.37@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 01:31:10 PM, Pantelis Antoniou wrote:
> Introduce DT overlay support.
> Using this functionality it is possible to dynamically overlay a part  
> of
> the kernel's tree with another tree that's been dynamically loaded.
> It is also possible to remove node and properties.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Just commenting on the documentation a bit...

> ---
>  Documentation/devicetree/overlay-notes.txt | 179 +++++++
>  drivers/of/Kconfig                         |  10 +
>  drivers/of/Makefile                        |   1 +
>  drivers/of/overlay.c                       | 831  
> +++++++++++++++++++++++++++++
>  include/linux/of.h                         | 107 ++++
>  5 files changed, 1128 insertions(+)
>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>  create mode 100644 drivers/of/overlay.c
> 
> diff --git a/Documentation/devicetree/overlay-notes.txt  
> b/Documentation/devicetree/overlay-notes.txt
> new file mode 100644
> index 0000000..5289cbb
> --- /dev/null
> +++ b/Documentation/devicetree/overlay-notes.txt
> @@ -0,0 +1,179 @@
> +Device Tree Overlay Notes
> +-------------------------
> +
> +This document describes the implementation of the in-kernel
> +device tree overlay functionality residing in drivers/of/overlay.c  
> and is a
> +companion document to  
> Documentation/devicetree/dt-object-internal.txt[1] &
> +Documentation/devicetree/dynamic-resolution-notes.txt[2]
> +
> +How overlays work
> +-----------------
> +
> +A Device Tree's overlay purpose is to modify the kernel's live tree,  
> and
> +have the modification affecting the state of the the kernel in a way  
> that
> +is reflecting the changes.

My wild guess here is this has something to do with hotplug support,  
but I don't know if modules are expected to do this or if userspace  
does it and modules respond... Could you give a couple sentences about  
the purpose and potential users of this mechanism in the summary?

> +Since the kernel mainly deals with devices, any new device node that  
> result

results

> +in an active device should have it created while if the device node  
> is either
> +disabled or removed all together, the affected device should be  
> deregistered.

I'm not following this bit. It looks like some test is missing between  
"while if"?

> +Lets take an example where we have a foo board with the following  
> base tree
> +which is taken from [1].
> +
> +---- foo.dts  
> -----------------------------------------------------------------
> +	/* FOO platform */
> +	/ {
> +		compatible = "corp,foo";
> +
> +		/* shared resources */
> +		res: res {
> +		};
> +
> +		/* On chip peripherals */
> +		ocp: ocp {
> +			/* peripherals that are always instantiated */
> +			peripheral1 { ... };
> +		}
> +	};
> +---- foo.dts  
> -----------------------------------------------------------------
> +
> +The overlay bar.dts, when loaded (and resolved as described in [2])  
> should
> +
> +---- bar.dts  
> -----------------------------------------------------------------
> +/plugin/;	/* allow undefined label references and record them */
> +/ {
> +	....	/* various properties for loader use; i.e. part id etc.  
> */
> +	fragment@0 {
> +		target = <&ocp>;
> +		__overlay__ {
> +			/* bar peripheral */
> +			bar {
> +				compatible = "corp,bar";
> +				... /* various properties and child  
> nodes */
> +			}
> +		};
> +	};
> +};
> +---- bar.dts  
> -----------------------------------------------------------------
> +
> +result in foo+bar.dts
> +
> +---- foo+bar.dts  
> -------------------------------------------------------------
> +	/* FOO platform + bar peripheral */
> +	/ {
> +		compatible = "corp,foo";
> +
> +		/* shared resources */
> +		res: res {
> +		};
> +
> +		/* On chip peripherals */
> +		ocp: ocp {
> +			/* peripherals that are always instantiated */
> +			peripheral1 { ... };
> +
> +			/* bar peripheral */
> +			bar {
> +				compatible = "corp,bar";
> +				... /* various properties and child  
> nodes */
> +			}
> +		}
> +	};
> +---- foo+bar.dts  
> -------------------------------------------------------------
> +
> +As a result of the the overlay, a new device node (bar) has been  
> created
> +so a bar platform device will be registered and if a matching device  
> driver
> +is loaded the device will be created as expected.

Is this done by a module, or does doing this then trigger a hotplug  
event that requests a module? (Or is this a syntax allowing a  
bootloader to collate multiple device tree segments and then Linux  
links them when parsing the device tree...?)

> +Overlay in-kernel API
> +---------------------
> +
> +The steps typically required to get an overlay to work are as  
> follows:
> +
> +1. Use of_build_overlay_info() to create an array of initialized and
> +ready to use of_overlay_info structures.
> +2. Call of_overlay() to apply the overlays declared in the array.
> +3. If the overlay needs to be removed, call of_overlay_revert().
> +4. Finally release the memory taken by the overlay info array by
> +of_free_overlay_info().
> +
> +/**
> + * of_build_overlay_info	- Build an overlay info array
> + * @tree:	Device node containing all the overlays
> + * @cntp:	Pointer to where the overlay info count will be help
> + * @ovinfop:	Pointer to the pointer of an overlay info structure.
> + *
> + * Helper function that given a tree containing overlay information,
> + * allocates and builds an overlay info array containing it, ready
> + * for use using of_overlay.
> + *
> + * Returns 0 on success with the @cntp @ovinfop pointers valid,
> + * while on error a negative error value is returned.
> + */
> +int of_build_overlay_info(struct device_node *tree,
> +		int *cntp, struct of_overlay_info **ovinfop);

Copying the htmldocs info blocks into a Documentation text file means  
you have to keep them in sync by hand. Possibly you want this  
documentation in a docbook template instead?

> +/**
> + * of_free_overlay_info	- Free an overlay info array
> + * @count:	Number of of_overlay_info's
> + * @ovinfo_tab:	Array of overlay_info's to free
> + *
> + * Releases the memory of a previously allocate ovinfo array
> + * by of_build_overlay_info.
> + * Returns 0, or an error if the arguments are bogus.
> + */
> +int of_free_overlay_info(int count, struct of_overlay_info  
> *ovinfo_tab);
> +
> +/**
> + * of_overlay	- Apply @count overlays pointed at by  
> @ovinfo_tab
> + * @count:	Number of of_overlay_info's
> + * @ovinfo_tab:	Array of overlay_info's to apply
> + *
> + * Applies the overlays given, while handling all error conditions
> + * appropriately. Either the operation succeeds, or if it fails the
> + * live tree is reverted to the state before the attempt.
> + * Returns 0, or an error if the overlay attempt failed.
> + */
> +int of_overlay(int count, struct of_overlay_info *ovinfo_tab);
> +
> +/**
> + * of_overlay_revert	- Revert a previously applied overlay
> + * @count:	Number of of_overlay_info's
> + * @ovinfo_tab:	Array of overlay_info's to apply
> + *
> + * Revert a previous overlay. The state of the live tree
> + * is reverted to the one before the overlay.
> + * Returns 0, or an error if the overlay table is not given.
> + */
> +int of_overlay_revert(int count, struct of_overlay_info *ovinfo_tab);
> +
> +Overlay DTS Format
> +------------------
> +
> +The DTS of an overlay should have the following format:
> +
> +{
> +	/* ignored properties by the overlay */
> +
> +	fragment@0 {	/* first child node */
> +		target=<phandle>;	/* target of the overlay */
> +		__overlay__ {
> +			property-a;	/* add property-a to the target  
> */
> +			-property-b;	/* remove property-b from  
> target */
> +			node-a {	/* add to an existing, or  
> create a node-a */
> +				...
> +			};
> +			-node-b {	/* remove an existing node-b */
> +				...
> +			};
> +		};
> +	}
> +	fragment@1 {	/* second child node */
> +		...
> +	};
> +	/* more fragments follow */
> +}
> +
> +It should be noted that the DT overlay format described is the one  
> expected
> +by the of_build_overlay_info() function, which is a helper function.  
> There
> +is nothing stopping someone coming up with his own DTS format and  
> that will
> +end up filling in the fields of the of_overlay_info array.
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index f9a6193..964a1c2 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -92,4 +92,14 @@ config OF_RESOLVE
>  	  Enable OF dynamic resolution support. This allows you to
>  	  load Device Tree object fragments are run time.
> 
> +config OF_OVERLAY
> +	bool "OF overlay support"
> +	depends on OF
> +	select OF_DYNAMIC
> +	select OF_DEVICE
> +	select OF_RESOLVE
> +	help
> +	  OpenFirmware overlay support. Allows you to modify on runtime  
> the
> +	  live tree using overlays.

"You" being... a module? The bootloader? A userspace program that just  
loaded some firmware? A udev hook responding to a hotplug event?

Rob