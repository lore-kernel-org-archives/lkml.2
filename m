Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3AJIUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:20:24 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43241 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3AJIUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:20:23 -0500
Message-ID: <50EE798F.4080108@linux.vnet.ibm.com>
Date: Thu, 10 Jan 2013 13:49:27 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org> <50ED286C.6070601@linux.vnet.ibm.com> <87obgxpoz6.fsf@sejong.aot.lge.com>
In-Reply-To: <87obgxpoz6.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011008-2000-0000-0000-00000A8B8431
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 11:19 AM, Namhyung Kim wrote:
> Hi Preeti,
> 
> On Wed, 09 Jan 2013 13:51:00 +0530, Preeti U. Murthy wrote:
>> On 01/09/2013 12:20 PM, Namhyung Kim wrote:
>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>
>>> AFAICS @target cpu of select_idle_sibling() is always either prev_cpu
>>> or this_cpu.  So no need to check it again and the conditionals can be
>>> consolidated.
> [snip]
>> If NUMA_TTWU_BIAS or NUMA_TTWU_TO is true(it is false by
> 
> I can't find those bits in the code.  I've checked v3.8-rc2,
> next-20130110, tip/master and tip/numa/core but there's nothing like
> above.  Which tree are you saying?
> 
> 
>> default),cpu/prev_cpu can be changed to be a random node_cpu(the node
>> that 'this_cpu' is on). In which case even if the node cpu is idle,it
>> would not be a viable target,looks like.Maybe that is why
>> select_idle_sibling() makes the check if the target is prev_cpu/this cpu.
> 
> Looking into tip/numa/core, I can see that there's a code added for
> CONFIG_NUMA_BALANCING.  But still, it seems nothing changed on a path
> from select_task_rq_fair() to select_idle_sibling() - i.e. if the
> select_idle_sibling called, the target would be either prev_cpu or this
> cpu.  Am I missing something?

Hi Namhyung,
Sorry about this.I did a git pull on the tip/master.You are right this
piece of code is not there any more.So not an issue.

You can go ahead and add my Reviewed-by.I don't find any potential
problems now.

For your information however, the code piece which was earlier there, is
given below which aimed to pull the tasks towards the node of the waking
cpu,if NUMA_TTWU_BIAS is enabled.

   if (sched_feat_numa(NUMA_TTWU_BIAS) && node != -1) {
               /*
                * For fork,exec find the idlest cpu in the home-node.
                */
               if (sd_flag & (SD_BALANCE_FORK|SD_BALANCE_EXEC)) {
                       int node_cpu = numa_select_node_cpu(p, node);
                       if (node_cpu < 0)
                               goto find_sd;

                       new_cpu = cpu = node_cpu;
                       sd = per_cpu(sd_node, cpu);
                       goto pick_idlest;
               }

               /*
                * For wake, pretend we were running in the home-node.
                */
               if (cpu_to_node(prev_cpu) != node) {
                       int node_cpu = numa_select_node_cpu(p, node);
                       if (node_cpu < 0)
                               goto find_sd;

                       if (sched_feat_numa(NUMA_TTWU_TO))
                               cpu = node_cpu;
                       else
                               prev_cpu = node_cpu;
               }
       }

> 
> Thanks,
> Namhyung
> 
I apologise once again for the wrong feedback.

Thank you

Regards
Preeti U Murthy

