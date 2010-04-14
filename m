Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0DNPlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:41:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab0DNPlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:41:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=lg0uDkThEwewh6tDT1ori+neqbbsvt9XyCcIKG/M+tkbjKNwXT11fXt24VW6dgpw2
	6PBI1b/DA2HJACwY8PwsA==
MIME-Version: 1.0
In-Reply-To: <87fx2y9xdn.fsf@basil.nowhere.org>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <20100414000823.29004.98991.stgit@bumblebee1.mtv.corp.google.com>
	 <87fx2y9xdn.fsf@basil.nowhere.org>
Date: Wed, 14 Apr 2010 08:41:30 -0700
Message-ID: <o2y4352991a1004140841w7f37b84cnedcd91c2638a07ea@mail.gmail.com>
Subject: Re: [PATCH 1/3] [kidled]: introduce kidled.
From: Salman Qazi <sqazi@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 2:49 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Salman <sqazi@google.com> writes:
>> +
>> +static int proc_stats(struct ctl_table *table, int write,
>> +                   void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +     int ret;
>> +     unsigned long stats[3];
>> +     int cpu = (int)((long)table->extra1);
>> +     struct ctl_table fake = {};
>> +
>> +     if (write)
>> +             return -EINVAL;
>> +
>> +     fake.data = stats;
>> +     fake.maxlen = 3*sizeof(unsigned long);
>> +
>> +     ret = smp_call_function_single(cpu, getstats, &stats, 1);
>> +     if (ret)
>> +             return ret;
>
> Haven't read the whole thing, but do any of these stats really
> need to execute on the target CPU? They seem to be just readable
> fields.

To capture all the quantities for a CPU atomically, they must be read
on the CPU.  Basically, reading them on that CPU prevents them from
changing as we read them.

Also, if the CPU is idle (injected or otherwise), the quantities won't
get updated.

>
> Or does it simply not matter because this proc call is too infrequent?

It should be infrequent.  The idle cycle injector does all the hard
work.  These interfaces are for monitoring.

>
> Anyways global broadcasts are discouraged, there is typically
> always someone who feels their RT latency be messed up by them.


I will look at it one more time to see if there is something else that
can be done.

>
> -Andi
>
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
