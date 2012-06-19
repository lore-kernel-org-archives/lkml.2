Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2FSUWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:22:25 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56347 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2FSUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:22:24 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 01:50:50 +0530
Message-Id: <20120619202047.26191.40429.sendpatchset@codeblue>
Subject: Regarding improving ple handler (vcpu_on_spin)
x-cbid: 12061910-0260-0000-0000-0000015DCE95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In ple handler code, last_boosted_vcpu (lbv) variable is
serving as reference point to start when we enter.

    lbv = kvm->lbv;
    for each vcpu i of kvm
       if i is eligible
          if yield_to(i) is success
             lbv = i 

currently this variable is per VM and it is set after we do
yield_to(target), unfortunately it may take little longer
than we expect to come back again (depending on its lag in rb tree)
on successful yield and set the value. 

So when several ple_handle entry happens before it is set,
all of them start from same place. (and overall RR is also slower).

Also statistical analysis (below) is showing lbv is not very well
distributed with current approach.

naturally, first approach is to move lbv before yield_to, without
bothering  failure case to make RR fast. (was in Rik's V4
vcpu_on_spin patch series).

But when I did performance analysis, in no-overcommit scenario,
I saw violent/cascaded directed yield happening, leading to
more wastage of cpu in spinning. (huge degradation in 1x and
improvement in 3x,  I assume this was the reason it was moved after 
yield_to in V5 of vcpu_on_spin series.)

Second approach, I tried was, 
(1) get rid of per kvm lbv variable
(2) everybody who enters handler start from a random vcpu as reference
point.

The above gave good distribution of starting point,(and performance
improvement in 32 vcpu guest I tested)  and also IMO, it scales well
for larger VM's.

Analysis
=============
Four 32 vcpu guest running with one of them running kernbench.

PLE handler yield stat is the statistics for successfully
yielded case (for 32 vcpus)

PLE handler start stat is the statistics for frequency of
each vcpu index as starting point (for 32 vcpus)

snapshot1
=============
PLE handler yield stat :
274391  33088  32554  46688  46653  48742  48055  37491
38839  31799  28974  30303  31466  45936  36208  51580
32754  53441  28956  30738  37940  37693  26183  40022
31725  41879  23443  35826  40985  30447  37352  35445  

PLE handler start stat :
433590  383318  204835  169981  193508  203954  175960  139373
153835  125245  118532  140092  135732  134903  119349  149467
109871  160404  117140  120554  144715  125099  108527  125051
111416  141385  94815  138387  154710  116270  123130  173795

snapshot2
============
PLE handler yield stat :
1957091  59383  67866  65474  100335  77683  80958  64073
53783  44620  80131  81058  66493  56677  74222  74974
42398  132762  48982  70230  78318  65198  54446  104793
59937  57974  73367  96436  79922  59476  58835  63547  

PLE handler start stat :
2555089  611546  461121  346769  435889  452398  407495  314403
354277  298006  364202  461158  344783  288263  342165  357270
270887  451660  300020  332120  378403  317848  307969  414282
351443  328501  352840  426094  375050  330016  347540  371819

So questions I have in mind is,

1. Do you think going for randomizing last_boosted_vcpu and get rid
of per VM variable is better? 

2. Can/Do we have a mechanism, from which we will be able to decide
not to yield to vcpu who is doing frequent PLE exit (possibly
because he is doing unnecessary busy-waits) OR doing yield_to better
candidate?

On a side note: With pv patches I have tried doing yield_to a kicked
VCPU, in vcpu_block path and is giving some performance improvement.

Please let me know if you have any comments/suggestions.

