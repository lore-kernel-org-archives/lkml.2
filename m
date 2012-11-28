Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2K1Sne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:43:34 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51085 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2K1Snd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:43:33 -0500
Message-ID: <50B65B4A.50508@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 12:43:22 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, riel@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
References: <20121126203603.28840.38736.stgit@lambeau> <20121127232442.GA8295@amt.cnet>
In-Reply-To: <20121127232442.GA8295@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112818-2000-0000-0000-00000A0EC66B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 05:24 PM, Marcelo Tosatti wrote:
> On Mon, Nov 26, 2012 at 02:36:24PM -0600, Michael Wolf wrote:
>> In the case of where you have a system that is running in a
>> capped or overcommitted environment the user may see steal time
>> being reported in accounting tools such as top or vmstat.
> The definition of stolen time is 'time during which the virtual CPU is
> runnable to not running'. Overcommit is the main scenario which steal
> time helps to detect.
>
> Can you describe the 'capped' case?
In the capped case, the time that the guest spends waiting due to it 
having used its full allottment of time shows up as steal time.  The way 
my patchset currently stands is that you would set up the
bandwidth control and you would have to pass it a  matching value from 
qemu.  In the future, it would
be possible to have something parse the bandwidth setting and 
automatically adjust the setting in the
host used for steal time reporting.
>
>>   This can
>> cause confusion for the end user.  To ease the confusion this patch set
>> adds the idea of consigned (expected steal) time.  The host will separate
>> the consigned time from the steal time.  The consignment limit passed to the
>> host will be the amount of steal time expected within a fixed period of
>> time.  Any other steal time accruing during that period will show as the
>> traditional steal time.
>>
>> ---
>>
>> Michael Wolf (5):
>>        Alter the amount of steal time reported by the guest.
>>        Expand the steal time msr to also contain the consigned time.
>>        Add the code to send the consigned time from the host to the guest
>>        Add a timer to allow the separation of consigned from steal time.
>>        Add an ioctl to communicate the consign limit to the host.
>>
>>
>>   arch/x86/include/asm/kvm_host.h       |   11 +++++++
>>   arch/x86/include/asm/kvm_para.h       |    3 +-
>>   arch/x86/include/asm/paravirt.h       |    4 +--
>>   arch/x86/include/asm/paravirt_types.h |    2 +
>>   arch/x86/kernel/kvm.c                 |    8 ++---
>>   arch/x86/kernel/paravirt.c            |    4 +--
>>   arch/x86/kvm/x86.c                    |   50 ++++++++++++++++++++++++++++++++-
>>   fs/proc/stat.c                        |    9 +++++-
>>   include/linux/kernel_stat.h           |    2 +
>>   include/linux/kvm_host.h              |    2 +
>>   include/uapi/linux/kvm.h              |    2 +
>>   kernel/sched/core.c                   |   10 ++++++-
>>   kernel/sched/cputime.c                |   21 +++++++++++++-
>>   kernel/sched/sched.h                  |    2 +
>>   virt/kvm/kvm_main.c                   |    7 +++++
>>   15 files changed, 120 insertions(+), 17 deletions(-)
>>
>> -- 
>> Signature
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

