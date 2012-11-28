Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2K1TQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:16:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38079 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2K1TQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:16:26 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
To: Glauber Costa <glommer@parallels.com>,
        Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
In-Reply-To: <50B47E40.5030805@parallels.com>
References: <20121126203603.28840.38736.stgit@lambeau> <50B47E40.5030805@parallels.com>
User-Agent: Notmuch/0.13.2+93~ged93d79 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 28 Nov 2012 13:16:21 -0600
Message-ID: <87ip8pwnay.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <glommer@parallels.com> writes:

> Hi,
>
> On 11/27/2012 12:36 AM, Michael Wolf wrote:
>> In the case of where you have a system that is running in a
>> capped or overcommitted environment the user may see steal time
>> being reported in accounting tools such as top or vmstat.  This can
>> cause confusion for the end user.  To ease the confusion this patch set
>> adds the idea of consigned (expected steal) time.  The host will separate
>> the consigned time from the steal time.  The consignment limit passed to the
>> host will be the amount of steal time expected within a fixed period of
>> time.  Any other steal time accruing during that period will show as the
>> traditional steal time.
>
> If you submit this again, please include a version number in your series.
>
> It would also be helpful to include a small changelog about what changed
> between last version and this version, so we could focus on that.
>
> As for the rest, I answered your previous two submissions saying I don't
> agree with the concept. If you hadn't changed anything, resending it
> won't change my mind.
>
> I could of course, be mistaken or misguided. But I had also not seen any
> wave of support in favor of this previously, so basically I have no new
> data to make me believe I should see it any differently.
>
> Let's try this again:
>
> * Rik asked you in your last submission how does ppc handle this. You
> said, and I quote: "In the case of lpar on POWER systems they simply
> report steal time and do not alter it in any way.
> They do however report how much processor is assigned to the partition
> and that information is in /proc/ppc64/lparcfg."

This only is helpful for static entitlements.

But if we allow dynamic entitlements--which is a very useful feature,
think buying an online "upgrade" in a cloud environment--then you need
to account for entitlement loss at the same place where you do the rest
of the accounting: in /proc/stat.

> Now, that is a *way* more sensible thing to do. Much more. "Confusing
> users" is something extremely subjective. This is specially true about
> concepts that are know for quite some time, like steal time. If you out
> of a sudden change the meaning of this, it is sure to confuse a lot more
> users than it would clarify.

I'll bring you a nice bottle of scotch at the next KVM Forum if you can
find me one user that can accurately describe what steal time is.

The semantics are so incredibly subtle that I have a hard time believing
anyone actually understands what it means today.

Regards,

Anthony Liguori
>
>
>
>
>
>> 
>> ---
>> 
>> Michael Wolf (5):
>>       Alter the amount of steal time reported by the guest.
>>       Expand the steal time msr to also contain the consigned time.
>>       Add the code to send the consigned time from the host to the guest
>>       Add a timer to allow the separation of consigned from steal time.
>>       Add an ioctl to communicate the consign limit to the host.
>> 
>> 
>>  arch/x86/include/asm/kvm_host.h       |   11 +++++++
>>  arch/x86/include/asm/kvm_para.h       |    3 +-
>>  arch/x86/include/asm/paravirt.h       |    4 +--
>>  arch/x86/include/asm/paravirt_types.h |    2 +
>>  arch/x86/kernel/kvm.c                 |    8 ++---
>>  arch/x86/kernel/paravirt.c            |    4 +--
>>  arch/x86/kvm/x86.c                    |   50 ++++++++++++++++++++++++++++++++-
>>  fs/proc/stat.c                        |    9 +++++-
>>  include/linux/kernel_stat.h           |    2 +
>>  include/linux/kvm_host.h              |    2 +
>>  include/uapi/linux/kvm.h              |    2 +
>>  kernel/sched/core.c                   |   10 ++++++-
>>  kernel/sched/cputime.c                |   21 +++++++++++++-
>>  kernel/sched/sched.h                  |    2 +
>>  virt/kvm/kvm_main.c                   |    7 +++++
>>  15 files changed, 120 insertions(+), 17 deletions(-)
>> 
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
