Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab2JIUAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:00:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59901 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2JIUAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:00:50 -0400
Date: Tue, 9 Oct 2012 13:00:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
        peterz@infradead.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <5073FAD1.1000403@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210091254220.30555@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.00.1210082308230.360@chino.kir.corp.google.com> <5073E18A.2090203@cn.fujitsu.com> <5073E2BF.9050306@cn.fujitsu.com> <alpine.DEB.2.00.1210090259250.24261@chino.kir.corp.google.com>
 <5073FAD1.1000403@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Wen Congyang wrote:

> I clear cpu-to-node mapping when the cpu is hotremoved. If the cpu is onlined,
> it will be offlined before clearing cpu-to-node mapping.
> 
> Here is the code in driver/acpi/processor_driver.c:
> =============
> static int acpi_processor_handle_eject(struct acpi_processor *pr)
> {
> 	if (cpu_online(pr->id))
> 		cpu_down(pr->id);      <========== cpu is offlined here.
> 
> 	arch_unregister_cpu(pr->id);
> 	acpi_unmap_lsapic(pr->id);     <========== I clear the mapping here.
> 	return (0);
> }
> =============
> 
> The real problem is that: we don't migrate this task to another cpu when
> the cpu is offlined. I guess this task is not in running state, and it
> is not in the cpu's runqueue.
> 

ACPI is not the only way to offline a cpu, this all needs to be 
standardized throughout the kernel for each arch so that generic code like 
sched can use cpu_to_node() in a CPU_DYING callback.  The only way to do 
that is by having arch callbacks to set cpu-to-node to NUMA_NO_NODE only 
at CPU_DEAD.

> This patch is try to fix a bug: the kernel will be panicked after removing a
> node.
> 

That's much more subtle than having a NULL pointer dereference like Tang 
reports during migration.
