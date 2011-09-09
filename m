Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab1IIG1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:27:15 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:35968 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758401Ab1IIG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:27:12 -0400
Message-ID: <4E69B1B6.2080604@ti.com>
Date: Fri, 09 Sep 2011 11:57:02 +0530
From: Santosh <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: Colin Cross <ccross@android.com>, rjw@sisk.pl, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/5] cpu_pm: call notifiers during suspend
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>	<1315060755-4613-3-git-send-email-santosh.shilimkar@ti.com>	<87k49knmrw.fsf@ti.com> <4E684F90.7010809@ti.com>	<87wrdjku9h.fsf@ti.com>	<CAMbhsRQvft4dqhAc4j_bXDR8018zeoSRXuWC6bS-d8rA0PgOyA@mail.gmail.com> <87ehzqbvvh.fsf@ti.com>
In-Reply-To: <87ehzqbvvh.fsf@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 02:21 AM, Kevin Hilman wrote:
> Colin Cross<ccross@android.com>  writes:
>
>> On Thu, Sep 8, 2011 at 7:01 AM, Kevin Hilman<khilman@ti.com>  wrote:
>>> Santosh<santosh.shilimkar@ti.com>  writes:
>>>
>>>> On Thursday 08 September 2011 01:32 AM, Kevin Hilman wrote:
>>>>> Santosh Shilimkar<santosh.shilimkar@ti.com>    writes:
>>>>>
>>>>>> From: Colin Cross<ccross@android.com>
[...]

>>
>> These notifiers are designed for drivers that are tightly coupled to
>> the cpu, and shared across multiple architectures (mostly GIC and
>> VFP).
>
> That is certainly the initial intended usage, and I understand that
> design, but they are useful for much more.
>
> Specifically, consider devices whose power transitions need to be
> tightly coupled with the CPU, but are in different power domains.
> Notifiers for these devices may need to be coordinated with
> platform-specific events.
>
> Also, it's not only about context save for off-mode.  Some of these
> tightly-coupled devices have other work to do besides context
> save/restore, and CPU PM notifiers are useful there.  A dumb example off
> the top of my head: pins (e.g. GPIOs), that need to be mux'd into safe
> mode to avoid glitches when coming back from off.  (admittedly, this is
> broken HW, but we all know broken HW is part of life.)
>
>> In practice, all of these devices are off in every suspend
>> state, because nobody leaves the CPU on in suspend.
>
> Sure, but you might leave other power domains on (or in retention)
> during suspend, and these domains might contain some of the devices
> whose power transitions are coupled with CPU transitions and thus using
> CPU PM notifiers.
>
> Also, so far we've only talked about suspend, but the CPU (and other
> power domains) might also go off during idle.  The approach in $SUBJECT
> patch addresses suspend but not idle, which means it's up to
> platform-specific code to trigger the notifiers for idle.  I think it
> should be the same for suspend.
>
>> The (next_state == OFF) api you refer to would have to be something
>> architecture specific, since the power state handling is very
>> different on every platform, so it's not something that would ever be
>> included in drivers that I imagined would be using these notifiers.
>
> Sure, but you created something so useful that it can be used in other
> areas than you initially imagined. :)   Thanks!
>
> I wouldn't imagine arch-specific being used in those generic drivers
> either, but in addition to the drivers you imagined, I'm already trying
> to the notifiers in drivers that are platform-specific.  I only imagine
> using the "next state" type of checking in platform-specific code, not
> in generic ones.
>
> Note however that I'm certainly not arguing that the notifiers should
> not be called in suspend.  I'm only arguing that it should be up to
> platform-specific code when to call them because of possible
> platform-specific pre-requisites in platform-specific notifier
> callbacks.
>
> IMO, there are 2 options.
>
> 1) leave it up to platform-specific code when to trigger the notifiers
>     for *both* suspend and idle PM transitions
>
> 2) trigger the notifiers in arch-independent code for both suspend and
>     idle *but* provide a way that platform-specific code can disable
>     them in favor of using platform-specific trigger points.
>
> If most platforms really don't care, then maybe (2) would be the
> better approach.  That's fine with me as long as there's a way to
> disable them so platform-specific ones can be used.
>
I think, we should keep the notifiers simple and option 1 the one
thing we should consider. It's just easy to take care of IDLE and
suspend together.

Regards
Santosh
