Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2LFHw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:52:59 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38035 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LFHw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:52:58 -0500
Date: Wed, 5 Dec 2012 23:52:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, Dudley Du <dudl@cypress.com>,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH v5 3/3] input: Cypress PS/2 Trackpad link into
 psmouse-base
Message-ID: <20121206075254.GB25921@core.coreip.homeip.net>
References: <1354752976-27257-1-git-send-email-kamal@canonical.com>
 <1354752976-27257-4-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354752976-27257-4-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

On Wed, Dec 05, 2012 at 04:16:16PM -0800, Kamal Mostafa wrote:
> From: Dudley Du <dudl@cypress.com>
> 
> Original code contributed by Dudley Du (Cypress Semiconductor Corporation),
> modified by Kamal Mostafa.
> 
> BugLink: http://launchpad.net/bugs/978807

Please fold it into the cypress_ps2 patch, they do not make sense
without each other.


> 
> Signed-off-by: Dudley Du <dudl@cypress.com>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/input/mouse/Kconfig        |   10 ++++++++++
>  drivers/input/mouse/Makefile       |    1 +
>  drivers/input/mouse/psmouse-base.c |   32 ++++++++++++++++++++++++++++++++
>  drivers/input/mouse/psmouse.h      |    1 +
>  4 files changed, 44 insertions(+)
> 
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index cd6268c..88954dd 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -68,6 +68,16 @@ config MOUSE_PS2_SYNAPTICS
>  
>  	  If unsure, say Y.
>  
> +config MOUSE_PS2_CYPRESS
> +       bool "Cypress PS/2 mouse protocol extension" if EXPERT
> +       default y
> +       depends on MOUSE_PS2
> +       help
> +         Say Y here if you have a Cypress PS/2 Trackpad connected to
> +         your system.
> +
> +         If unsure, say Y.
> +
>  config MOUSE_PS2_LIFEBOOK
>  	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EXPERT
>  	default y
> diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
> index 46ba755..323e352 100644
> --- a/drivers/input/mouse/Makefile
> +++ b/drivers/input/mouse/Makefile
> @@ -32,3 +32,4 @@ psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
>  psmouse-$(CONFIG_MOUSE_PS2_SENTELIC)	+= sentelic.o
>  psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
>  psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
> +psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)	+= cypress_ps2.o
> diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
> index 22fe254..cff065f 100644
> --- a/drivers/input/mouse/psmouse-base.c
> +++ b/drivers/input/mouse/psmouse-base.c
> @@ -34,6 +34,7 @@
>  #include "touchkit_ps2.h"
>  #include "elantech.h"
>  #include "sentelic.h"
> +#include "cypress_ps2.h"
>  
>  #define DRIVER_DESC	"PS/2 mouse driver"
>  
> @@ -759,6 +760,28 @@ static int psmouse_extensions(struct psmouse *psmouse,
>  	}
>  
>  /*
> + * Try Cypress Trackpad.
> + * Must try it before Finger Sensing Pad because Finger Sensing Pad probe
> + * upsets some modules of Cypress Trackpads.
> + */
> +	if (max_proto > PSMOUSE_IMEX &&
> +			cypress_detect(psmouse, set_properties) == 0) {
> +		if (cypress_supported()) {
> +			if (cypress_init(psmouse) == 0)
> +				return PSMOUSE_CYPRESS;
> +
> +			/*
> +			 * Finger Sensing Pad probe upsets some modules of
> +			 * Cypress Trackpad, must avoid Finger Sensing Pad
> +			 * probe if Cypress Trackpad device detected.
> +			 */
> +			return PSMOUSE_PS2;
> +		}
> +
> +		max_proto = PSMOUSE_IMEX;
> +	}
> +
> +/*
>   * Try ALPS TouchPad
>   */
>  	if (max_proto > PSMOUSE_IMEX) {
> @@ -896,6 +919,15 @@ static const struct psmouse_protocol psmouse_protocols[] = {
>  		.alias		= "thinkps",
>  		.detect		= thinking_detect,
>  	},
> +#ifdef CONFIG_MOUSE_PS2_CYPRESS
> +	{
> +		.type		= PSMOUSE_CYPRESS,
> +		.name		= "CyPS/2",
> +		.alias		= "cypress",
> +		.detect		= cypress_detect,
> +		.init		= cypress_init,
> +	},
> +#endif
>  	{
>  		.type		= PSMOUSE_GENPS,
>  		.name		= "GenPS/2",
> diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
> index fe1df23..2f0b39d 100644
> --- a/drivers/input/mouse/psmouse.h
> +++ b/drivers/input/mouse/psmouse.h
> @@ -95,6 +95,7 @@ enum psmouse_type {
>  	PSMOUSE_ELANTECH,
>  	PSMOUSE_FSP,
>  	PSMOUSE_SYNAPTICS_RELATIVE,
> +	PSMOUSE_CYPRESS,
>  	PSMOUSE_AUTO		/* This one should always be last */
>  };
>  
> -- 
> 1.7.10.4
> 

-- 
Dmitry
