Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2CUNEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:04:23 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:54655 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538Ab2CUNEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:04:21 -0400
X-IronPort-AV: E=Sophos;i="4.73,624,1325462400"; 
   d="scan'208";a="11443176"
Message-ID: <4F69D1D9.9080107@citrix.com>
Date: Wed, 21 Mar 2012 13:04:25 +0000
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH RFC V6 1/11]  x86/spinlock: replace pv spinlocks with
 pv ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <20120321102052.473.40193.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120321102052.473.40193.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/12 10:20, Raghavendra K T wrote:
> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>
> Rather than outright replacing the entire spinlock implementation in
> order to paravirtualize it, keep the ticket lock implementation but add
> a couple of pvops hooks on the slow patch (long spin on lock, unlocking
> a contended lock).
>
> Ticket locks have a number of nice properties, but they also have some
> surprising behaviours in virtual environments.  They enforce a strict
> FIFO ordering on cpus trying to take a lock; however, if the hypervisor
> scheduler does not schedule the cpus in the correct order, the system can
> waste a huge amount of time spinning until the next cpu can take the lock.
>
> (See Thomas Friebel's talk "Prevent Guests from Spinning Around"
> http://www.xen.org/files/xensummitboston08/LHP.pdf  for more details.)
>
> To address this, we add two hooks:
>   - __ticket_spin_lock which is called after the cpu has been
>     spinning on the lock for a significant number of iterations but has
>     failed to take the lock (presumably because the cpu holding the lock
>     has been descheduled).  The lock_spinning pvop is expected to block
>     the cpu until it has been kicked by the current lock holder.
>   - __ticket_spin_unlock, which on releasing a contended lock
>     (there are more cpus with tail tickets), it looks to see if the next
>     cpu is blocked and wakes it if so.
>
> When compiled with CONFIG_PARAVIRT_SPINLOCKS disabled, a set of stub
> functions causes all the extra code to go away.
>    

I've made some real world benchmarks based on this serie of patches 
applied on top of a vanilla Linux-3.3-rc6 (commit 
4704fe65e55fb088fbcb1dc0b15ff7cc8bff3685), with both 
CONFIG_PARAVIRT_SPINLOCK=y and n, which means essentially 4 versions 
compared:
* vanilla - CONFIG_PARAVIRT_SPINLOCK - patch
* vanilla + CONFIG_PARAVIRT_SPINLOCK - patch
* vanilla - CONFIG_PARAVIRT_SPINLOCK + patch
* vanilla + CONFIG_PARAVIRT_SPINLOCK + patch

(you can check out the monolithic kernel configuration I used, and 
verify the sole difference, here):
http://xenbits.xen.org/people/attilio/jeremy-spinlock/kernel-configs/

Tests, information and results are summarized below.

== System used information:
* Machine is a XEON x3450, 2.6GHz, 8-ways system:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/dmesg
* System version, a Debian Squeeze 6.0.4:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/debian-version
* gcc version, 4.4.5:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/gcc-version

== Tests performed
* pgbench based on PostgreSQL 9.2 (development version) as it has a lot 
of scalability improvements in it:
http://www.postgresql.org/docs/devel/static/install-getsource.html

I used a stock installation, with only this simple configuration change:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/postsgresql.conf.patch

For collecting data I used this simple scripts, which runs the test 10 
times every time with a different set of threads (from 1 to 64). Please 
note that the first 8 runs cache all the data in memory in order to 
avoid subsequent I/O, thus they are discarded in sampling and calculation:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/pgbench_script

Here is the crude data (please remind this is tps, thus the higher the 
better):
http://xenbits.xen.org/people/attilio/jeremy-spinlock/pgbench-crude-datas/

And here are data chartered with ministat tool, comparing all the 4 
kernel configuration for every thread configuration:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/pgbench-9.2-total.bench

As you can see, the patch doesn't really show a statistically meaningful 
difference for this workload, excluding the single-thread run for the 
patched + CONFIG_PARAVIRT_SPINLOCK=y case, which seems 5% faster.


* pbzip2, which is a parallel version of bzip2, supposed to reproduce a 
CPU-intensive, multithreaded, application.
The file choosen for compression is 1GB sized, got from /dev/urandom 
(this is not published but I may have it, so if you need it for more 
tests please just ask), and all the I/O is done on a tmpfs volume in 
order to avoid I/O floaty effects.

For collecting data I used this simple scripts, which runs the test 10 
times every time with a different set of threads (from 1 to 64):
http://xenbits.xen.org/people/attilio/jeremy-spinlock/pbzip2bench_script

Here is the crude data (please remind this is time(1) output, thus the 
lower the better):
http://xenbits.xen.org/people/attilio/jeremy-spinlock/pbzip2-crude-datas/

And here are data chartered with ministat tool, comparing all the 4 
kernel configuration for every thread configuration:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/pbzip2-1.1.1-total.bench

As you can see, the patch doesn't really show a statistically meaningful 
difference for this workload.


* kernbench-0.50 run, doing I/O on a 10GB tmpfs volume (thus no actual  
I/O involved), with the following invokation:
./kernbench -n10 -s -c16 -M -f

(I had to do that because kernbench wasn't getting a good maximum value 
at all, thus I disabled default maximum and forced for 16 threads).

Here is the crude data (please remind this is time(1) output, thus the 
lower the better):
http://xenbits.xen.org/people/attilio/jeremy-spinlock/kernbench-crude-datas/

Please note that kernbench already calculates std deviation for them. 
However I also wanted a ministat summary in order to quickly display any 
possible difference, thus I just replicated 3 times any value (the 
minimum requested by ministat) and charted them:
http://xenbits.xen.org/people/attilio/jeremy-spinlock/kernbench-0.50-total.bench

Again, it doesn't seem to be any meaningful statistical difference.

== Results
This test points in the direction that Jeremy's rebased patches don't 
introduce a peformance penalty at all, but also that we could likely 
consider CONFIG_PARAVIRT_SPINLOCK option removal, or turn it on by 
default and suggest disabling just on very old CPUs (assuming a 
performance regression can be proven there).

If you have questions please let me know.

Thanks,
Attilio
