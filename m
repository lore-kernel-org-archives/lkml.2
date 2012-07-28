Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2G1B2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 21:28:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2G1B2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 21:28:40 -0400
Date: Fri, 27 Jul 2012 18:28:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, padovan@profusion.mobi, marcel@holtmann.org,
        peterz@infradead.org, mingo@redhat.com, davem@davemloft.net,
        dougthompson@xmission.com, ibm-acpi@hmh.eng.br, cbou@mail.ru,
        rui.zhang@intel.com, Jens Axboe <axboe@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>, David Airlie <airlied@linux.ie>,
        Roland Dreier <roland@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Len Brown <len.brown@intel.com>, David Howells <dhowells@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/15] workqueue: use mod_delayed_work() instead of
 cancel + queue
Message-ID: <20120728012832.GA19817@core.coreip.homeip.net>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
 <1343433308-26614-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343433308-26614-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 04:55:07PM -0700, Tejun Heo wrote:
> Convert delayed_work users doing [__]cancel_delayed_work() +
> queue_delayed_work() to mod_delayed_work().
> 
> Most conversions are straight-forward.  Ones worth mentioning are,
> 
> * drivers/edac/edac_mc.c: edac_mc_workq_setup() converted to always
>   use mod_delayed_work() and cancel loop in
>   edac_mc_reset_delay_period() is dropped.
> 
> * drivers/platform/x86/thinkpad_acpi.c: No need to remember whether
>   watchdog is active or not.  @fan_watchdog_active and related code
>   dropped.
> 
> * drivers/power/charger-manager.c: Seemingly a lot of
>   delayed_work_pending() abuse going on here.
>   [delayed_]work_pending() are unsynchronized and racy when used like
>   this.  I converted one instance in fullbatt_handler().  Please
>   conver the rest so that it invokes workqueue APIs for the intended
>   target state rather than trying to game work item pending state
>   transitions.  e.g. if timer should be modified - call
>   mod_delayed_work(), canceled - call cancel_delayed_work[_sync]().
> 
> * drivers/thermal/thermal_sys.c: thermal_zone_device_set_polling()
>   simplified.  Note that round_jiffies() calls in this function are
>   meaningless.  round_jiffies() work on absolute jiffies not delta
>   delay used by delayed_work.
> 
> * net/core/link_watch.c: linkwatch_schedule_work() was doing a quite
>   elaborate dancing around its delayed_work.  Collapse it such that
>   linkwatch_work is queued for immediate execution if LW_URGENT and
>   existing timer is kept otherwise.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Roland Dreier <roland@kernel.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

For the input parts:

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
