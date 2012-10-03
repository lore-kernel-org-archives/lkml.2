Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2JCMx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:53:59 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54017 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2JCMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:53:57 -0400
Message-ID: <506C3535.3070401@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 18:23:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] CPU hotplug, debug: Detect imbalance between get_online_cpus()
 and put_online_cpus()
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <20121002170149.GC2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210022324050.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022331130.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022356370.23544@pobox.suse.cz> <20121002233138.GD2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030142570.23544@pobox.suse.cz> <20121003001530.GF2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030227430.23544@pobox.suse.cz> <alpine.LNX.2.00.1210031143260.23544@pobox.suse.cz> <506C2E02.9080804@linux.vnet.ibm.com>
In-Reply-To: <506C2E02.9080804@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100312-7014-0000-0000-000001F9F3E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 05:52 PM, Srivatsa S. Bhat wrote:
> On 10/03/2012 03:16 PM, Jiri Kosina wrote:
>> On Wed, 3 Oct 2012, Jiri Kosina wrote:
>>
>>> Good question. I believe it should be safe to drop slab_mutex earlier, as 
>>> cachep has already been unlinked. I am adding slab people and linux-mm to 
>>> CC (the whole thread on LKML can be found at 
>>> https://lkml.org/lkml/2012/10/2/296 for reference).
>>>
[...]
> 
> But, I'm also quite surprised that the put_online_cpus() code as it stands today
> doesn't have any checks for the refcount going negative. I believe that such a
> check would be valuable to help catch cases where we might end up inadvertently
> causing an imbalance between get_online_cpus() and put_online_cpus(). I'll post
> that as a separate patch.
> 


-----------------------------------


From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] CPU hotplug, debug: Detect imbalance between get_online_cpus() and put_online_cpus()

The synchronization between CPU hotplug readers and writers is achieved by
means of refcounting, safe-guarded by the cpu_hotplug.lock.

get_online_cpus() increments the refcount, whereas put_online_cpus() decrements
it. If we ever hit an imbalance between the two, we end up compromising the
guarantees of the hotplug synchronization i.e, for example, an extra call to
put_online_cpus() can end up allowing a hotplug reader to execute concurrently with
a hotplug writer. So, add a BUG_ON() in put_online_cpus() to detect such cases
where the refcount can go negative.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index f560598..00d29bc 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -80,6 +80,7 @@ void put_online_cpus(void)
 	if (cpu_hotplug.active_writer == current)
 		return;
 	mutex_lock(&cpu_hotplug.lock);
+	BUG_ON(cpu_hotplug.refcount == 0);
 	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
 		wake_up_process(cpu_hotplug.active_writer);
 	mutex_unlock(&cpu_hotplug.lock);


