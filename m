Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2DJG5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:57:08 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:34454 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753713Ab2DJG5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com> <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 10 Apr 2012 12:26:43 +0530
Message-ID: <CAMQu2gwkGjWgLN3FVkzqeYCA+N-+==HPnjmH68AKgBsYrKtXaw@mail.gmail.com>
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if the
 current device is always running.
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 4:11 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Mon, 2012-04-09 at 11:33 +0530, Santosh Shilimkar wrote:
>> Commit 77b0d60{clockevents: Leave the broadcast device in shutdown mode
>> when not needed} was intended to leave the broadcast device in shutdown mode
>> when the per-cpu clockevent devices are always running.
>>
>> This breaks the systems where per cpu clock events stop in low power states.
>>
>> Hence revert 77b0d60 and implement the same requirement with use
>> of C3STOP feature flag.
>
> Problem you encountered is not related to leaving the broadcast device
> in shutdown mode. Problem is that we didn't track the mode change to
> oneshot and later during idle entry/exit, when we request the broadcast
> device services using CLOCK_EVT_NOTIFY_BROADCAST_ENTER etc,
> tick_broadcast_oneshot_control() returns with out doing much as it
> thinks broadcast device is in periodic mode.
>
You are right. In my last traces I didn't track the broadcast device state
fully. Did some more tracing and indeed the issue was the broadcast
device mode.

> Can you please check if the appended patch fixes the issue? I could
> reproduce the issue on my NHM platform which doesn't have always running
> apic timer and with the appended fix, all is well with cpu's going into
> tickless idle etc. Thanks.
> ---
>
Yes it does work on OMAP too.

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: clockevents: track broadcast device mode change in tick_broadcast_switch_to_oneshot()
>
> In the commit 77b0d60c5adf39c74039e2142a1d3cd1e4d53799,
> "clockevents: Leave the broadcast device in shutdown mode when not needed",
> we were bailing out too quickly in tick_broadcast_switch_to_oneshot(),
> with out tracking the broadcast device mode change to 'TICKDEV_MODE_ONESHOT'.
>
> This breaks the platforms which need broadcast device oneshot services during
> deep idle states. tick_broadcast_oneshot_control() thinks that it is
> in periodic mode and fails to take proper decisions based on the
> CLOCK_EVT_NOTIFY_BROADCAST_[ENTER, EXIT] notifications during deep
> idle entry/exit.
>
> Fix this by tracking the broadcast device mode as 'TICKDEV_MODE_ONESHOT',
> before leaving the broadcast HW device in shutdown mode if there are no active
> requests for the moment.
>
> Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
Thanks for the patch. Feel free to add,
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>	

Regards
Santosh
