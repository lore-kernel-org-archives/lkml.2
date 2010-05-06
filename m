Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab0EFPSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:18:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59237 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751524Ab0EFPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:18:08 -0400
Date: Thu, 6 May 2010 11:18:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <1272429119-12103-2-git-send-email-arve@android.com>
Message-ID: <Pine.LNX.4.44L0.1005061110090.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, [UTF-8] Arve Hjønnevåg wrote:

> +static void suspend_worker(struct work_struct *work)
> +{
> +	int ret;
> +	int entry_event_num;
> +
> +	enable_suspend_blockers = true;
> +	while (!suspend_is_blocked()) {
> +		entry_event_num = current_event_num;
> +
> +		if (debug_mask & DEBUG_SUSPEND)
> +			pr_info("suspend: enter suspend\n");
> +
> +		ret = pm_suspend(requested_suspend_state);
> +
> +		if (debug_mask & DEBUG_EXIT_SUSPEND)
> +			pr_info_time("suspend: exit suspend, ret = %d ", ret);
> +
> +		if (current_event_num == entry_event_num)
> +			pr_info("suspend: pm_suspend returned with no event\n");
> +	}
> +	enable_suspend_blockers = false;
> +}

Here's a completely new issue.  When using opportunistic suspends on an
SMP system, it could happen that the system gets a wakeup event and
this routine starts running again before the event's IRQ handler has
finished (or has enabled a suspend blocker).  The system would 
re-suspend too soon.

Is there anything in the PM core that waits until all outstanding IRQs 
have been handled before unfreezing processes?  If there is, I can't 
find it.  Should such a thing be added?

Alan Stern

