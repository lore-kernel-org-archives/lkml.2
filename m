Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2ALPNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:13:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45986 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2ALPNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:13:33 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1326380884.2442.187.camel@twins>
References: <1326276668-19932-1-git-send-email-mgorman@suse.de>
	<1326276668-19932-3-git-send-email-mgorman@suse.de>
	<CAOtvUMfmSrotCGn-51SC3eiQU=xK4C_Trh+8FEfTGOJcGUgVag@mail.gmail.com>
	<1326380884.2442.187.camel@twins>
Date: Thu, 12 Jan 2012 17:13:32 +0200
Message-ID: <CAOtvUMfMquadAkDNmsY-_wuyypz6Hga5B4fhpL+dMQy0zd_Gsw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: page allocator: Do not drain per-cpu lists via
 IPI from page allocator context
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Miklos Szeredi <mszeredi@novell.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
        Gong Chen <gong.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 5:08 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-01-12 at 16:51 +0200, Gilad Ben-Yossef wrote:
>> What I can't figure out is why we don't need  get/put_online_cpus()
>> pair around each and every call
>> to on_each_cpu everywhere? and if we do, perhaps making it a part of
>> on_each_cpu is the way to go?
>>
>> Something like:
>>
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index f66a1b2..cfa3882 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -691,11 +691,15 @@ void on_each_cpu(void (*func) (void *info), void
>> *info, int wait)
>>  {
>>         unsigned long flags;
>>
>> +       BUG_ON(in_atomic());
>> +
>> +       get_online_cpus();
>>         preempt_disable();
>
> Your preempt_disable() here serializes against hotplug..

I'm probably daft, but why didn't it work for the page allocator then?

Mel's description reads: "Part of the problem is the page allocator is
sending IPIs using
on_each_cpu() without calling get_online_cpus() to prevent changes
to the online cpumask."

on_each_cpu() disables preemption in master as well...

Gilad




Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
