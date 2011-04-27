Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab1D0XEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:04:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42790 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1D0XEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MeAlcGgPLliZyZy9GveXAoz38s+ZvbuMu83pqlmVrbwD9jH+6hK6Fda0lMnMfKUn9e
         PlaNx2BdAmDBzybR5NhA==
MIME-Version: 1.0
In-Reply-To: <201104272348.24084.rjw@sisk.pl>
References: <201104130205.26988.rjw@sisk.pl>
	<201104242330.13607.rjw@sisk.pl>
	<201104242342.58326.rjw@sisk.pl>
	<201104272348.24084.rjw@sisk.pl>
Date: Wed, 27 Apr 2011 16:04:09 -0700
Message-ID: <BANLkTimHkKq9+0z-4CZs=34GNO6Ab0wZPQ@mail.gmail.com>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Generic clock manipulation
 rountines for runtime PM (v3)
From: Colin Cross <ccross@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 2:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Many different platforms and subsystems may want to disable device
> clocks during suspend and enable them during resume which is going to
> be done in a very similar way in all those cases.  For this reason,
> provide generic routines for the manipulation of device clocks during
> suspend and resume.
>
> Convert the ARM shmobile platform to using the new routines.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>
> Hi,
>
> This (hopefully final) version of the patch has a couple of bugs fixed in
> clock_ops.c.
>
> Thanks,
> Rafael
>
> ---
>  arch/arm/mach-shmobile/pm_runtime.c |  140 -----------
>  drivers/base/power/Makefile         |    1
>  drivers/base/power/clock_ops.c      |  423 ++++++++++++++++++++++++++++++++++++
>  include/linux/pm_runtime.h          |   42 +++
>  kernel/power/Kconfig                |    4
>  5 files changed, 479 insertions(+), 131 deletions(-)
>
<snip>
> +void pm_runtime_clk_remove(struct device *dev, const char *con_id)
> +{
> +       struct pm_runtime_clk_data *prd = __to_prd(dev);
> +       struct pm_clock_entry *ce;
> +
> +       if (!prd)
> +               return;
> +
> +       mutex_lock(&prd->lock);
> +
> +       list_for_each_entry(ce, &prd->clock_list, node)
Braces
> +               if (!con_id && !ce->con_id) {
> +                       __pm_runtime_clk_remove(ce);
> +                       break;
> +               } else if (!con_id || !ce->con_id) {
> +                       continue;
> +               } else if (!strcmp(con_id, ce->con_id)) {
> +                       __pm_runtime_clk_remove(ce);
> +                       break;
> +               }
> +
> +       mutex_unlock(&prd->lock);
> +}
>
> +/**
> + * pm_runtime_clk_acquire - Acquire a device clock.
> + * @dev: Device whose clock is to be acquired.
> + * @con_id: Connection ID of the clock.
> + */
> +static void pm_runtime_clk_acquire(struct device *dev,
> +                                   struct pm_clock_entry *ce)
> +{
> +       ce->clk = clk_get(dev, ce->con_id);
> +       if (!IS_ERR(ce->clk)) {
> +               ce->clock_active = true;
> +               dev_dbg(dev, "Clock %s managed by runtime PM.\n", ce->con_id);
> +       }
> +}
> +
> +/**
> + * pm_runtime_clk_suspend - Disable clocks in a device's runtime PM clock list.
> + * @dev: Device to disable the clocks for.
> + */
> +int pm_runtime_clk_suspend(struct device *dev)
> +{
> +       struct pm_runtime_clk_data *prd = __to_prd(dev);
> +       struct pm_clock_entry *ce;
> +
> +       dev_dbg(dev, "%s()\n", __func__);
> +
> +       if (!prd)
> +               return 0;
> +
> +       mutex_lock(&prd->lock);
> +
> +       list_for_each_entry_reverse(ce, &prd->clock_list, node) {
> +               if (!ce->clk) {
> +                       dev_err(dev, "Clock is not ready for runtime PM\n");
> +                       pm_runtime_clk_acquire(dev, ce);
Why delay the call to clk_get until the first suspend?  Also, this
will always print an error during the first call to suspend.

> +               }
> +
> +               if (ce->clock_active) {
I don't think clock_active is necessary, and the name is misleading.
Why not use if (ce->clk)?

> +                       clk_disable(ce->clk);
> +                       ce->clock_enabled = false;
Clock enables are already refcounted, do you really need a flag as
well?  In what situations would pm_runtime_clk_remove get called,
which currently needs to know when the clock is enabled?

> +               }
> +       }
> +
> +       mutex_unlock(&prd->lock);
> +
> +       return 0;
> +}
> +
> +/**
> + * pm_runtime_clk_resume - Enable clocks in a device's runtime PM clock list.
> + * @dev: Device to enable the clocks for.
> + */
> +int pm_runtime_clk_resume(struct device *dev)
> +{
> +       struct pm_runtime_clk_data *prd = __to_prd(dev);
> +       struct pm_clock_entry *ce;
> +
> +       dev_dbg(dev, "%s()\n", __func__);
> +
> +       if (!prd)
> +               return 0;
> +
> +       mutex_lock(&prd->lock);
> +
> +       list_for_each_entry(ce, &prd->clock_list, node) {
> +               if (!ce->clk)
> +                       pm_runtime_clk_acquire(dev, ce);
If the clock was not present during suspend, should you be enabling it
during resume?

> +
> +               if (ce->clock_active) {
> +                       clk_enable(ce->clk);
> +                       ce->clock_enabled = true;
> +               }
> +       }
> +
> +       mutex_unlock(&prd->lock);
> +
> +       return 0;
> +}
