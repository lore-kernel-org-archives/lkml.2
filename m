Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2FLWpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:45:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46344 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab2FLWpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:45:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120612223422.GB13492@fifo99.com>
References: <20120612220924.GA13376@fifo99.com>
	<20120612222912.GB16381@google.com>
	<20120612223422.GB13492@fifo99.com>
Date: Tue, 12 Jun 2012 15:45:20 -0700
Message-ID: <CACBanvo7DxYPWEtSAWV25Xq94vqJBugMAwbrEHz9DfSFTpSL_w@mail.gmail.com>
Subject: Re: hung_task checking and sys_sync
From: Mandeep Baines <msb@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: fweisbec@gmail.com, sshaiju@mvista.com, mingo@elte.hu,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 3:34 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Tue, Jun 12, 2012 at 03:29:12PM -0700, Mandeep Singh Baines wrote:
>>
>> But the time is not unbounded. You could mask the hung_task_detector for
>> this case but then you lose the ability to catch bugs in this code path.
>>
>> The timeout is configurable via /proc/sys/kernel/hung_task_timeout_secs.
>> Can you bump up the value at boot via sysctl.conf?
>
> Maybe, but I'm wondering if these types should just be stopped because Andrew
> had complained about them already.
>

Fair enough. Actually, internally I had a patch where we'd use a task
flag to disable and enable the hang check but the approach in the
patch you pointed me to seems better.

>> > Has there been any commit that disable these messages bdi_sched_wait?
>> >
>>
>> No. There is no mechanism to disable hung_task for a specific code path.
>> We do skip processes if PF_PROZEN or PF_FROZEN_SKIP is set but that is
>> really a different situation where the wait is unbounded.
>
> There is presidence for this type of change,
>
> Author: Mark Lord <kernel@teksavvy.com>
> Date:   Fri Sep 24 09:51:13 2010 -0400
>
>    block: Prevent hang_check firing during long I/O
>
>    During long I/O operations, the hang_check timer may fire,
>    trigger stack dumps that unnecessarily alarm the user.
>
>    Eg.  hdparm --security-erase NULL /dev/sdb  ## can take *hours* to complete
>
>    So, if hang_check is armed, we should wake up periodically
>    to prevent it from triggering.  This patch uses a wake-up interval
>    equal to half the hang_check timer period, which keeps overhead low enough.
>
>    Signed-off-by: Mark Lord <mlord@pobox.com>
>    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>

Interesting. I wasn't aware of this patch. Maybe we could abstract
this approach via wait_for_completion_no_hang_check().

Regards,
Mandeep
