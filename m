Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2HMN3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab2HMN3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:29:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1344015839-21800-15-git-send-email-tj@kernel.org>
References: <1344015839-21800-15-git-send-email-tj@kernel.org> <1344015839-21800-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        tomi.valkeinen@ti.com, Jens Axboe <axboe@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>, David Airlie <airlied@linux.ie>,
        Roland Dreier <roland@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Len Brown <len.brown@intel.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/14] workqueue: use mod_delayed_work() instead of cancel + queue
Date: Mon, 13 Aug 2012 14:27:57 +0100
Message-ID: <8393.1344864477@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Convert delayed_work users doing cancel_delayed_work() followed by
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
> v2: Tomi pointed out that __cancel_delayed_work() users can't be
>     safely converted to mod_delayed_work().  They could be calling it
>     from irq context and if that happens while delayed_work_timer_fn()
>     is running, it could deadlock.  __cancel_delayed_work() users are
>     dropped.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
