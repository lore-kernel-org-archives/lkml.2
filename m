Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1CJDdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 22:33:19 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38705 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750981Ab1CJDdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 22:33:18 -0500
Date: Wed, 9 Mar 2011 22:33:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        <tglx@linutronix.de>
Subject: Re: [linux-pm] [RFC][PATCH 1/2] Introduce struct syscore_ops and
 related functionality
In-Reply-To: <201103100133.06734.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1103092224480.3620-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Rafael J. Wysocki wrote:

> Some subsystems need to carry out suspend/resume and shutdown
> operations with one CPU on-line and interrupts disabled.  The only
> way to register such operations is to define a sysdev class and
> a sysdev specifically for this purpose which is cumbersome and
> inefficient.  Moreover, the arguments taken by sysdev suspend,
> resume and shutdown callbacks are practically never necessary.
> 
> For this reason, introduce a simpler interface allowing subsystems
> to register operations to be executed very late during system suspend
> and shutdown and very early during resume in the form of
> strcut syscore_ops objects.

...

> Index: linux-2.6/drivers/base/syscore.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/base/syscore.c

It's true that the existing sys.c file lies in drivers/base; this is
presumably because it handles a bunch of class-related registration
stuff.  Now you're getting rid of all that, leaving just the
power-related operations, so doesn't it make more sense to put this
file in drivers/base/power?

> +/**
> + * syscore_suspend - Execute all the registered system core suspend callbacks.
> + *
> + * This function is executed with one CPU on-line and disabled interrupts.
> + */
> +int syscore_suspend(void)
> +{
> +	struct syscore_ops *ops;
> +
> +	list_for_each_entry_reverse(ops, &syscore_ops_list, node)
> +		if (ops->suspend) {
> +			int ret = ops->suspend();
> +			if (ret) {
> +				pr_err("PM: System core suspend callback "
> +					"%pF failed.\n", ops->suspend);
> +				return ret;

If an error occurs, you need to go back and resume all the things that
were suspended.  At least, that's what the code in sysdev_suspend does.

> +			}
> +		}
> +
> +	return 0;
> +}

Alan Stern

