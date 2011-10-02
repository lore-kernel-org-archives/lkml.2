Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1JBUEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:04:50 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45491 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1JBUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:04:43 -0400
Message-ID: <4E88C3D4.2020300@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 01:34:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <4E88B5E0.6080503@linux.vnet.ibm.com> <20111002195023.GC31799@mtj.dyndns.org>
In-Reply-To: <20111002195023.GC31799@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/03/2011 01:20 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Oct 03, 2011 at 12:35:04AM +0530, Srivatsa S. Bhat wrote:
>> So, this patch addresses this issue by ensuring that microcode is not freed
>> from kernel memory, nor invalidated when a CPU goes offline. Thus once the
>> kernel gets the microcode during boot-up, it will never have to depend on
>> userspace ever again to get microcode, since it never releases the copy it
>> already has. So every run of the microcode callback for CPU online event will
>> now succeed irrespective of whether userspace is frozen or not. As a result,
>> this fixes the task freezing failure encountered while running CPU hotplug
>> stress test along with suspend/resume operations simultaneously.
> 
> I'm not familiar with how microcode is supposed to be managed but is
> it impossible for the newly hotplugged CPU (an actual hot unplug /
> plug) may not like the microcode loaded for the previous CPU?  Isn't
> that why CPU_DEAD was invalidating the microcode?
> 

Actually, looking at the code, I found that a copy of the microcode
is maintained by the kernel for every CPU. 
The relevant lines are:

arch/x86/include/asm/microcode.h:

struct ucode_cpu_info {
        struct cpu_signature    cpu_sig;
        int                     valid;
        void                    *mc;
};
extern struct ucode_cpu_info ucode_cpu_info[];


arch/x86/kernel/microcode_core.h:

struct ucode_cpu_info           ucode_cpu_info[NR_CPUS];


So when a CPU goes offline and comes back online, I don't see why the kernel
should not reuse the microcode that it already has. Anyhow the microcode will
not change. The same microcode would be requested from userspace again if the
kernel has freed its copy.

So what I feel is, earlier, the kernel used to invalidate the microcode for the CPU_DEAD
notification may be just to free the kernel's copy of the microcode as a memory
optimization (thinking that the microcode is not needed any more in kernel memory,
atleast for now).

This is my understanding. Please enlighten me if I am wrong.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
