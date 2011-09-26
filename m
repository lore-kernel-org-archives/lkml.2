Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1IZX70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:59:26 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40748 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321Ab1IZX7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:59:24 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, jean.pihet@newoldbits.com,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/3] PM / Runtime: Don't run callbacks under lock for power.irq_safe set
Organization: Texas Instruments, Inc.
References: <201108310017.03103.rjw@sisk.pl> <201109242323.03474.rjw@sisk.pl>
	<201109242325.53563.rjw@sisk.pl>
Date: Mon, 26 Sep 2011 16:59:20 -0700
In-Reply-To: <201109242325.53563.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 24 Sep 2011 23:25:53 +0200")
Message-ID: <87oby66ejr.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The rpm_suspend() and rpm_resume() routines execute subsystem or PM
> domain callbacks under power.lock if power.irq_safe is set for the
> given device.  This is inconsistent with that rpm_idle() does after
> commit 02b2677 (PM / Runtime: Allow _put_sync() from
> interrupts-disabled context) and is problematic for subsystems and PM
> domains wanting to use power.lock for synchronization in their
> runtime PM callbacks.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

The part described here looks right, and is much better for consistency.

Reviewed-by: Kevin Hilman <khilman@ti.com>

but...

[...]

> @@ -347,6 +353,15 @@ static int rpm_suspend(struct device *de
>  			goto out;
>  		}
>  
> +		if (dev->power.irq_safe) {
> +			spin_unlock(&dev->power.lock);
> +
> +			cpu_relax();
> +
> +			spin_lock(&dev->power.lock);
> +			goto repeat;
> +		}
> +


... AFAICT, this isn't directly related to the problem described in the
changelog (or at least I didn't find it obvious), and probably deserves
a comment in the code as well.

Thanks,

Kevin
