Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1IHXj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:39:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab1IHXjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:39:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=A1yF/5ES5aqwBLpwWNkpAleHLbwWwid5wylhtQeZdJjLPTfipf0R7eid5ft49u9FG
	OHXFVZ0YXvlMWYBo1mI0g==
MIME-Version: 1.0
In-Reply-To: <87wrdjku9h.fsf@ti.com>
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
	<1315060755-4613-3-git-send-email-santosh.shilimkar@ti.com>
	<87k49knmrw.fsf@ti.com>
	<4E684F90.7010809@ti.com>
	<87wrdjku9h.fsf@ti.com>
Date: Thu, 8 Sep 2011 11:04:26 -0700
X-Google-Sender-Auth: 9xOVIxOe8qx_ipdaIrSsGG1ZAaU
Message-ID: <CAMbhsRQvft4dqhAc4j_bXDR8018zeoSRXuWC6bS-d8rA0PgOyA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] cpu_pm: call notifiers during suspend
From: Colin Cross <ccross@android.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Santosh <santosh.shilimkar@ti.com>, rjw@sisk.pl, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 7:01 AM, Kevin Hilman <khilman@ti.com> wrote:
> Santosh <santosh.shilimkar@ti.com> writes:
>
>> On Thursday 08 September 2011 01:32 AM, Kevin Hilman wrote:
>>> Santosh Shilimkar<santosh.shilimkar@ti.com>  writes:
>>>
>>>> From: Colin Cross<ccross@android.com>
>>>>
>>>> Implements syscore_ops in cpu_pm to call the cpu and
>>>> cpu cluster notifiers during suspend and resume,
>>>> allowing drivers receiving the notifications to
>>>> avoid implementing syscore_ops.
>>>>
>>>> Signed-off-by: Colin Cross<ccross@android.com>
>>>> [santosh.shilimkar@ti.com: Rebased against 3.1-rc4]
>>>> Signed-off-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>
>>> I don't think using syscore_ops is right here.  The platform code should
>>> decide where in its own suspend path the notifiers should be triggered.
>>>
>>> The reason is because while the syscore_ops run late in the suspend
>>> path, they still run before some platform-specific decisions about the
>>> low-power states are made.  That means that any notifiers that need to
>>> use information about the target low-power state (e.g. whether context
>>> will be lost or not) cannot do so since that information has not yet
>>> been decided until the platform_suspend_ops->enter() runs.
>>>
>> Initially I thought the same but in general S2R, platform doesn't
>> support multiple states like CPUIDLE. On OMAP, we do have a debug
>> option to choose the state but on real product, it's always the
>> deepest supported state is used. So the driver saving the
>> full context for S2R, should be fine.
>>
>> Ofcourse for CPUIDLE, the notifier call chain decisions are left
>> with platform CPUIDLE drivers since there can be multiple low
>> power states and the context save/restore has to be done based
>> on low power states.
>>
>> The advantage with this is, the platform code is clean from the
>> notfiers calls. CPUIDLE driver needs to call the different notifier
>> events based on C-states and that perfectly works.
>>
>> I liked this simplification for the S2R. Down side is in S2R if you
>> don't plan to hit deepest state, drivers end up saving full context
>> which is fine I guess.
>
> That's not the downside I'm worried about.
>
> If you have a driver that has a notifier, presumably it has something it
> wants to do to prepare for suspend *and* for idle, and you'd only want a
> single notifier callback in the driver to be used for both.  That
> callback would look something like:
>
>   start_preparing_for_suspend();
>
>   if (next_state == OFF)
>      save_context();
>
>   finish_preparing_for_suspend();
>
>
> The problem with the current cpu_*_pm_enter() calls in syscore_ops is
> that they happen before the next states are programmed, so during
> suspend the 'if (next_state == off)' above would never be true, but
> during idle it might be.

These notifiers are designed for drivers that are tightly coupled to
the cpu, and shared across multiple architectures (mostly GIC and
VFP).  In practice, all of these devices are off in every suspend
state, because nobody leaves the CPU on in suspend.

The (next_state == OFF) api you refer to would have to be something
architecture specific, since the power state handling is very
different on every platform, so it's not something that would ever be
included in drivers that I imagined would be using these notifiers.
