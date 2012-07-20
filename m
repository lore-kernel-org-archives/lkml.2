Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2GTXfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:35:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48487 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2GTXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:35:42 -0400
Message-ID: <5009EB4B.5030107@gmail.com>
Date: Fri, 20 Jul 2012 17:35:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>  <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com> <1341845268.3462.80.camel@twins>
In-Reply-To: <1341845268.3462.80.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/12 8:47 AM, Peter Zijlstra wrote:
> On Mon, 2012-07-09 at 17:39 +0300, Avi Kivity wrote:
>>> Disabling PEBS events for guests isn't pretty though..
>>
>> We already have atomic MSR switching at guest entry/exit time.  So it's
>> not pretty in terms of not getting full profiling, but the code won't be
>> too hard.  Basically we just have to exclude_guest any pebs event.
>
> OK, so ideally we'd do something like the below, except of course that
> that isn't backwards compatible and will break the world :/
>
> bugger that
>
> ---
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -336,6 +338,9 @@ int x86_setup_perfctr(struct perf_event *event)
>                  /* BTS is currently only allowed for user-mode. */
>                  if (!attr->exclude_kernel)
>                          return -EOPNOTSUPP;
> +
> +               if (!attr->exclude_guest)
> +                       return -EOPNOTSUPP;
>          }
>
>          hwc->config |= config;
> @@ -378,6 +383,9 @@ int x86_pmu_hw_config(struct perf_event *event)
>          if (event->attr.precise_ip) {
>                  int precise = 0;
>
> +               if (!event->attr.exclude_guest)
> +                       return -EOPNOTSUPP;
> +
>                  /* Support for constant skid */
>                  if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
>                          precise++;
>

Tested-by: David Ahern <dsahern@gmail.com>

Gleb's patch is required as well. It takes both to fix the problem. And 
my userspace patch keeps compatibility for users who currently use -e 
cycles:pp (they won't be forced to add 'H'). (lkml is slow to show it so 
I can't pull a link for reference, but it's in your email ahead of this 
one).

Be nice to get this set into stable releases as well.
