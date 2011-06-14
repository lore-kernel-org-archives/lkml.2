Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1FNPoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:44:13 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:36757 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab1FNPoK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:44:10 -0400
MIME-Version: 1.0
In-Reply-To: <1308056600-17601-1-git-send-email-santosh.shilimkar@ti.com>
References: <1308056600-17601-1-git-send-email-santosh.shilimkar@ti.com>
From: "Menon, Nishanth" <nm@ti.com>
Date: Tue, 14 Jun 2011 10:38:37 -0500
Message-ID: <BANLkTimKHsGCrbZ5FhYOyJC8+pASUD-nDg@mail.gmail.com>
Subject: Re: [PATCH] power: opp: Fix rcu_dereference_check() without protection!
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 08:03, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> With RCU debug options enabled, below warning is observed.
>
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> drivers/base/power/opp.c:151 invoked rcu_dereference_check() without protection!
>
> other info that might help us debug this:
>
> rcu_scheduler_active = 1, debug_locks = 1
> no locks held by swapper/1.
> ...
>
> ---------------------------------------------------
>
> Fix the same by protecting it with rcu_read lock.
>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> ---
>  drivers/base/power/opp.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 56a6899..cbed5e1 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -148,7 +148,9 @@ unsigned long opp_get_voltage(struct opp *opp)
>        struct opp *tmp_opp;
>        unsigned long v = 0;
>
> +       rcu_read_lock();
>        tmp_opp = rcu_dereference(opp);
> +       rcu_read_unlock();
>        if (unlikely(IS_ERR_OR_NULL(tmp_opp)) || !tmp_opp->available)
>                pr_err("%s: Invalid parameters\n", __func__);
>        else
NAK. please read the Documentation/power/opp.txt
the usage is as follows:
rcu_read_lock();
opp = opp_find_freq_ceil();
voltage = opp_get_voltage(opp);
rcu_read_unlock();

the reason for this is that the opp pointer is not safe if we lock
just the dereferencing.

Regards,
Nishanth Menon
