Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab2AKFDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 00:03:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:53904 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2AKFDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 00:03:33 -0500
Message-ID: <1326258182.23910.105.camel@pasglop>
Subject: Re: [PATCH] of: Support CONFIG_CMDLINE_EXTEND config option
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jan 2012 16:03:02 +1100
In-Reply-To: <4F0CF61F.50705@gmail.com>
References: <1326156853-24840-1-git-send-email-dianders@chromium.org>
	 <4F0CF61F.50705@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 20:38 -0600, Rob Herring wrote:
> On 01/09/2012 06:54 PM, Doug Anderson wrote:
> > The old logic assumes CMDLINE_FROM_BOOTLOADER vs. CMDLINE_FORCE and
> > ignores CMDLINE_EXTEND.  Here's the old logic:
> > 
> > - CONFIG_CMDLINE_FORCE=true
> >     CONFIG_CMDLINE
> > - dt bootargs=non-empty:
> >     dt bootargs
> > - dt bootargs=empty, @data is non-empty string
> >     @data is left unchanged
> > - dt bootargs=empty, @data is empty string
> >     CONFIG_CMDLINE (or "" if that's not defined)
> > 
> > The old logic would also not honor CONFIG_CMDLINE_FORCE if there was no
> > "chosen" attribute in the device tree.
> > 
> > The new logic is now documented in of_fdt.h and is copied here for
> > reference:
> > 
> > - CONFIG_CMDLINE_FORCE=true
> >     CONFIG_CMDLINE
> > - CONFIG_CMDLINE_EXTEND=true
> >     CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)
> > - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=non-empty:
> >     dt bootargs
> > - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is non-empty string
> >     @data is left unchanged
> > - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is empty string
> >     CONFIG_CMDLINE (or "" if that's not defined)
> >
So if CONFIG_CMDLINE_EXTEND=true, dt_bootargs is empty, and @data is non
empty, I want CONFIG_CMDLINE + @data..

Now the logic...

> > +/*
> > + * Convert configs to something easy to use in C code
> > + */
> > +#if defined(CONFIG_CMDLINE_FORCE)
> > +static const int overwrite_incoming_cmdline = 1;
> > +static const int read_dt_cmdline;
> > +static const int concat_cmdline;
> > +#elif defined(CONFIG_CMDLINE_EXTEND)
> > +static const int overwrite_incoming_cmdline = 1;
> > +static const int read_dt_cmdline = 1;
> > +static const int concat_cmdline = 1;
> > +#else /* CMDLINE_FROM_BOOTLOADER */
> > +static const int overwrite_incoming_cmdline;
> > +static const int read_dt_cmdline = 1;
> > +static const int concat_cmdline;
> > +#endif
> > +
> > +#ifdef CONFIG_CMDLINE
> > +static const char *config_cmdline = CONFIG_CMDLINE;
> > +#else
> > +static const char *config_cmdline = "";
> > +#endif
> > +
> >  int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
> >  				     int depth, void *data)
> >  {
> > @@ -672,28 +695,29 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
> >  
> >  	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
> >  
> > +	/* Make sure cmdline default is set early to handle case of no chosen */
> > +	if (data && (overwrite_incoming_cmdline || !((char *)data)[0]))
> > +		strlcpy(data, config_cmdline, COMMAND_LINE_SIZE);
> > +

That means that if CONFIG_CMDLINE_EXTEND is set, it will overwrite
whatever is in data. So in my case of user command line coming via
"data" in the first place, I'm not going to get the expected behaviour.

You can probably fix that by doing

	if (data && ((overwrite_incoming_cmdline && !concat_cmdline) || ...

But we are losing the point of having those variables instead of
CONFIG_* in the first place.

Additionally...

> >  	if (depth != 1 || !data ||
> >  	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
> >  		return 0;
> >  
> >  	early_init_dt_check_for_initrd(node);
> >  
> > -	/* Retrieve command line */
> > -	p = of_get_flat_dt_prop(node, "bootargs", &l);
> > -	if (p != NULL && l > 0)
> > -		strlcpy(data, p, min((int)l, COMMAND_LINE_SIZE));
> > -
> > -	/*
> > -	 * CONFIG_CMDLINE is meant to be a default in case nothing else
> > -	 * managed to set the command line, unless CONFIG_CMDLINE_FORCE
> > -	 * is set in which case we override whatever was found earlier.
> > -	 */
> > -#ifdef CONFIG_CMDLINE
> > -#ifndef CONFIG_CMDLINE_FORCE
> > -	if (!((char *)data)[0])
> > -#endif
> > -		strlcpy(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
> > -#endif /* CONFIG_CMDLINE */
> > +	/* Retrieve command line unless forcing */
> > +	if (read_dt_cmdline) {
> > +		p = of_get_flat_dt_prop(node, "bootargs", &l);
> > +		if (p != NULL && l > 0) {
> > +			if (concat_cmdline) {
> > +				strlcat(data, " ", COMMAND_LINE_SIZE);
> > +				strlcat(data, p, min_t(int, (int)l,
> > +						       COMMAND_LINE_SIZE));
> > +			} else
> > +				strlcpy(data, p, min_t(int, (int)l,
> > +						       COMMAND_LINE_SIZE));
> > +		}
> > +	}

So if you have CONFIG_CMDLINE_EXTEND, and have a command line in the
device-tree, you just read it, concat with what's in data but ...

the next node in the device-tree will hit the initial code above again
which will overwrite what you just did with the content of
CONFIG_CMDLINE (unless /chosen is the last node in the device-tree,
probably why it might have worked for you once).

It can still work ... as long as once you've hit the command line above,
you clear overwrite_incoming_cmdline. You may also clear read_dt_cmdline
for good measure.

Cheers,
Ben.

> >  	pr_debug("Command line is: %s\n", (char*)data);
> >  
> > diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> > index ed136ad..346d6c7 100644
> > --- a/include/linux/of_fdt.h
> > +++ b/include/linux/of_fdt.h
> > @@ -91,6 +91,25 @@ extern int of_flat_dt_is_compatible(unsigned long node, const char *name);
> >  extern int of_flat_dt_match(unsigned long node, const char *const *matches);
> >  extern unsigned long of_get_flat_dt_root(void);
> >  
> > +/*
> > + * early_init_dt_scan_chosen - scan the device tree for ramdisk and bootargs
> > + *
> > + * The boot arguments will be placed into the memory pointed to by @data.
> > + * That memory should be COMMAND_LINE_SIZE big and initialized to be a valid
> > + * (possibly empty) string.  Logic for what will be in @data after this
> > + * function finishes:
> > + *
> > + * - CONFIG_CMDLINE_FORCE=true
> > + *     CONFIG_CMDLINE
> > + * - CONFIG_CMDLINE_EXTEND=true
> > + *     CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)
> > + * - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=non-empty:
> > + *     dt bootargs
> > + * - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is non-empty string
> > + *     @data is left unchanged
> > + * - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is empty string
> > + *     CONFIG_CMDLINE (or "" if that's not defined)
> > + */
> >  extern int early_init_dt_scan_chosen(unsigned long node, const char *uname,
> >  				     int depth, void *data);
> >  extern void early_init_dt_check_for_initrd(unsigned long node);


