Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2JIKQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:16:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2JIKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:16:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344182400"; 
   d="scan'208";a="5969188"
Message-ID: <5073FAD1.1000403@cn.fujitsu.com>
Date: Tue, 09 Oct 2012 18:22:09 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
        peterz@infradead.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.00.1210082308230.360@chino.kir.corp.google.com> <5073E18A.2090203@cn.fujitsu.com> <5073E2BF.9050306@cn.fujitsu.com> <alpine.DEB.2.00.1210090259250.24261@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210090259250.24261@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 18:16:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 18:16:25,
	Serialize complete at 2012/10/09 18:16:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/09/2012 06:04 PM, David Rientjes Wrote:
> On Tue, 9 Oct 2012, Tang Chen wrote:
> 
>>>> Eek, the nid shouldn't be -1 yet, though, for cpu hotplug since this
>>>> should be called at CPU_DYING level and migrate_tasks() still sees a valid
>>>> cpu.
>>
>> As Wen said below, nid is now set to -1 when cpu is hotremoved.
>> I reproduce this problem in this situation:
>>
>> all cpus are online, and hot remove a system board directorily, without
>> offlining any cpu.
>>
>> As a result, the removed cpu's nid is set to -1, and this causes
>> problems.
>>
> 
> Let's add Andrew to the cc list then, because I'm nacking 
> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch in the -mm 
> tree for this reason.
> 
> We can only clear a cpu-to-node mapping when the cpu is completely 
> offline, not before or during the CPU_DYING stage.  Kernel code, such as 

I clear cpu-to-node mapping when the cpu is hotremoved. If the cpu is onlined,
it will be offlined before clearing cpu-to-node mapping.

Here is the code in driver/acpi/processor_driver.c:
=============
static int acpi_processor_handle_eject(struct acpi_processor *pr)
{
	if (cpu_online(pr->id))
		cpu_down(pr->id);      <========== cpu is offlined here.

	arch_unregister_cpu(pr->id);
	acpi_unmap_lsapic(pr->id);     <========== I clear the mapping here.
	return (0);
}
=============

The real problem is that: we don't migrate this task to another cpu when
the cpu is offlined. I guess this task is not in running state, and it
is not in the cpu's runqueue.

Thanks
Wen Congyang

> the sched code that you are now trying to "fix", depends on this mapping 
> to work correctly; obviously no audit was done of cpu hotplug code 
> depending on it before the patch was proposed.
> 
> I say "fix" because even this workaround isn't a good solution since it 
> would be much better to pick another cpu on the same node as the offlining 
> cpu for the runqueue before falling back to the set of all allowed nodes.  
> We lose all NUMA affinity information with that patch.  There's no reason 
> why we shouldn't know the node of a cpu that is being offlined.
> 
> So nack to cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch.  
> After it's removed because it's buggy, this "fix" will no longer be 
> necessary.
> 

This patch is try to fix a bug: the kernel will be panicked after removing a
node.
