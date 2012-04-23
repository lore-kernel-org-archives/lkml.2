Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2DWPVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:21:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60534 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2DWPVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
References: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
Date: Mon, 23 Apr 2012 17:21:42 +0200
Message-ID: <CABPqkBQQo4TZVDA4pfujt7X0tTaV+PVOg8epDVS89DONV_XOtg@mail.gmail.com>
Subject: Re: [RFC PATCH V2 0/6] perf: Intel uncore pmu counting support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[+jolsa as it may have something to do with the event parser]

I started testing this on my NHM desktop machine, and I ran into the following
problem:
$ perf stat -a -C 0 -e uncore_nhm/CLOCKTICKS/,cycles,ref-cycles  --
taskset -c 0 noploop 1
noploop for 1 seconds
 Performance counter stats for 'taskset -c 0 noploop 1':
     3,435,695,848 cycles                    #    0.000 GHz
         [100.00%]
     2,803,309,845 ref-cycles
     2,410,926,590 pmu
       1.001391268 seconds time elapsed

First here, the cmdline event order is not respected. uncore events
appear at the end. That's not very
intuitive. Especially when you know that they all show up as 'pmu'. In
other words, you cannot figure
out what each value represents.

$ sudo perf stat -a -C 0 -e uncore_nhm/CLOCKTICKS/  -- taskset -c 0 noploop 1
noploop for 1 seconds
 Performance counter stats for 'taskset -c 0 noploop 1':
     2,410,862,301 pmu
       1.001393218 seconds time elapsed

That looks like the right value, well, minus the 'pmu' event name. But
that's a different problem.

But then, the pathological case:

$ sudo perf stat -a -C 0 -e
uncore_nhm/CLOCKTICKS/,uncore_nhm/QMC_NORMAL_READS_ANY/  -- taskset -c
0 noploop 1
noploop for 1 seconds
 Performance counter stats for 'taskset -c 0 noploop 1':
            10,705 pmu
       1.001395772 seconds time elapsed

If you pass more than one uncore event, all but the last one are
suppressed from the output.
It does not happen with core PMU events.

Looks like something may be wrong in the way the parser adds uncore events.


On Sun, Apr 1, 2012 at 3:41 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> Hi, all
>
> Here is the RFC patches to add uncore counting support for Nehalem,
> Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
> The code is based on Lin Ming's old patches.
>
> For Nehalem and Sandy Bridge-EP, A few general events are exported
> under directory:
> /sys/bus/event_source/devices/uncore_xxx/events/
>
> You can use 'perf stat' to access to the uncore pmu. For example:
> perf stat -a -C 0 -e 'uncore_nhm/QMC_WRITES_FULL_ANY/' sleep 1
>
> Any comment is appreciated.
> Thank you
>
> ---
> Changes since v1:
>  - Modify perf tool to parse events from sysfs
>  - A few minor code cleanup
>
