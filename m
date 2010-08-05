Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911Ab0HEXUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:20:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65486 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab0HEXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:20:30 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
        "linux-pm\@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2] pm: Add runtime PM statistics
Organization: Deep Root Systems, LLC
References: <20100710095254.5ab7291c@infradead.org>
	<201007112326.07541.rjw@sisk.pl>
	<20100711221646.35f11b70@infradead.org>
	<201007132328.28853.rjw@sisk.pl> <4C3F2CEF.2090404@linux.intel.com>
Date: Thu, 05 Aug 2010 16:20:28 -0700
In-Reply-To: <4C3F2CEF.2090404@linux.intel.com> (Arjan van de Ven's message of
	"Thu, 15 Jul 2010 08:44:47 -0700")
Message-ID: <87bp9gpryb.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> writes:

> +
> +/**
> + * update_pm_runtime_accounting - Update the time accounting of power
> states
> + * @dev: Device to update the accounting for
> + *
> + * In order to be able to have time accounting of the various power states
> + * (as used by programs such as PowerTOP to show the effectiveness of
> runtime
> + * PM), we need to track the time spent in each state.
> + * update_pm_runtime_accounting must be called each time before the
> + * runtime_status field is updated, to account the time in the old state
> + * correctly.
> + */
> +void update_pm_runtime_accounting(struct device *dev)
> +{
> +    unsigned long now = jiffies;
> +    int delta;
> +
> +    delta = now - dev->power.accounting_timestamp;
> +
> +    if (delta < 0)
> +        delta = 0;
> +
> +    dev->power.accounting_timestamp = now;
> +
> +    if (dev->power.disable_depth > 0)
> +        return;
> +
> +    if (dev->power.runtime_status == RPM_SUSPENDED)
> +        dev->power.suspended_jiffies += delta;
> +    else
> +        dev->power.active_jiffies += delta;
> +}

By using jiffies, I think we might miss events in drivers that are doing
runtime PM transitions in short bursts.  On embedded systems with slow
HZ, there could potentially be lots of transitions between ticks.

It would be nicer to use clocksource-based time so transitions between
jiffies could still be factored into the accounting.

Kevin


