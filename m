Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2I0Kot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:44:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab2I0Kor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:44:47 -0400
Message-ID: <50642E0C.6030105@redhat.com>
Date: Thu, 27 Sep 2012 12:44:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, dlaor@redhat.com,
        Chegu Vinod <chegu_vinod@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <505C691D.4080801@hp.com> <505CA5BA.4020801@linux.vnet.ibm.com> <50601CE7.60801@redhat.com> <50604BF0.1070607@linux.vnet.ibm.com> <5061C70E.2090308@redhat.com> <50642139.80309@linux.vnet.ibm.com> <20120927102832.GA4106@turtle.usersys.redhat.com>
In-Reply-To: <20120927102832.GA4106@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 12:28 PM, Andrew Jones wrote:

>> No, I am not there yet.
>> 
>> So In summary, we are suffering with inconsistent benchmark result,
>> while measuring the benefit of our improvement in PLE/pvlock etc..
> 
> Are you measuring the combined throughput of all running guests, or
> just looking at the results of the benchmarks in a single test guest?
> 
> I've done some benchmarking as well and my stddevs look pretty good for
> kcbench, ebizzy, dbench, and sysbench-memory. I do 5 runs for each
> overcommit level (1.0 - 3.0, stepped by .25 or .5), and 2 runs of that
> full sequence of tests (one with the overcommit levels in scrambled
> order). The relative stddevs for each of the sets of 5 runs look pretty
> good, and the data for the 2 runs match nicely as well.
> 
> To try and get consistent results I do the following 
> - interleave the memory of all guests across all numa nodes on the
>   machine
> - echo 0 > /proc/sys/kernel/randomize_va_space on both host and test
>   guest
> - echo 3 > /proc/sys/vm/drop_caches on both host and test guest before
>   each run
> - use a ramdisk for the benchmark output files on all running guests
> - no periodically running services installed on the test guest
> - HT is turned off as you do, although I'd like to try running again
>   with it turned back on
> 
> Although, I still need to run again measuring the combined throughput
> of all running vms (including the ones launched just to generate busy
> vcpus). Maybe my results won't be as consistent then...
> 


Another way to test is to execute

 perf stat -e 'kvm_exit exit_reason==40' sleep 10

to see how many PAUSEs were intercepted in a given time (except I just
invented the filter syntax).  The fewer we get, the more useful work the
system does.  This ignores kvm_vcpu_on_spin overhead though, so it's
just a rough measure.

-- 
error compiling committee.c: too many arguments to function
