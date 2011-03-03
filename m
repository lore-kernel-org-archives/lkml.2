Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab1CCLDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:03:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42457 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab1CCLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:03:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Thu, 03 Mar 2011 20:01:39 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Strange minor page fault repeats when SPECjbb2005 is executed
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>
Message-Id: <20110303200139.B187.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.55 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.

I found an abnormal kernel behavior when I executed SPECjbb2005.
It is that minor page fault repeats even though page table entry is correct.

If you know something about cause of this phenomenon, please let me know.
If nobody knows, please reproduce it and find why it is happen.


The details of this problem are the followings.

When SPECjbb2005 is executed, it sometimes stop displaying message of
progress suddenly.
-------------
          :
          :
116.160: [GC 406278K->193826K(2071552K), 0.0117750 secs]
116.342: [GC 406626K->194122K(2071616K), 0.0118000 secs]
116.522: [GC
            ^
            It stop showing message from here.
--------------------

This condition keeps for some time, then SPECjbb2005 finishes.
The stop time is from about 5 seconds to an hours. It may tend to be longer
on bigger box, but I'm not sure.

In addition, the stop condition is sometimes released when I executed other
unrelated command.



When this phenomenon happen, I saw that too many minor page faults occur
on the java process.

Here is output of /proc/<pid>/stat of the java process.

Usually, the minor fault value is under 1 million on my current environment
like the following.
------------------
1744 (java) S 1742 1742 1721 34816 1742 4202496 968826 0 35834 0 218734 ...
                                                ^^^^^^
                                                minor fault value

------------------

But, when SPECjbb2005 stops with this phenomenon, this value increases
sharply.
----

2065 (java) S 2063 2063 1721 34816 2063 4202496 157573157 0 1 0 .....
                                                ^^^^^^^^^
2065 (java) S 2063 2063 1721 34816 2063 4202496 231388697 0 1 0 ......
                                                ^^^^^^^^^

2065 (java) S 2063 2063 1721 34816 2063 4202496 438851940 0 1 0 ....
                                                ^^^^^^^^^

2065 (java) S 2063 2063 1721 34816 2063 4202496 524209252 0 1 0 ...
                                                ^^^^^^^^^
-----

I checked page table entry status at handle_mm_fault by debugfs,
then even ptes are correct, page fault repeated on same virtual address
and same cpus. And I think page table entry looks correct.

In this log, cpu4 and 6 repeat page faults.
----
handle_mm_fault jiffies64=4295160616 cpu=4 address=40019a38 pmdval=0000000070832067 ptehigh=00000000 ptelow=55171067
handle_mm_fault jiffies64=4295160616 cpu=6 address=40003a38 pmdval=0000000070832067 ptehigh=00000000 ptelow=551ef067
handle_mm_fault jiffies64=4295160616 cpu=6 address=40003a38 pmdval=0000000070832067 ptehigh=00000000 ptelow=551ef067
handle_mm_fault jiffies64=4295160616 cpu=4 address=40019a38 pmdval=0000000070832067 ptehigh=00000000 ptelow=55171067
handle_mm_fault jiffies64=4295160616 cpu=4 address=40019a38 pmdval=0000000070832067 ptehigh=00000000 ptelow=55171067
         :
         :
------------
(Here is the patch to display the above log by debugfs.)

---------------
Index: linux-2.6.38-rc5/mm/memory.c
===================================================================
--- linux-2.6.38-rc5.orig/mm/memory.c
+++ linux-2.6.38-rc5/mm/memory.c
@@ -3333,6 +3333,8 @@ int handle_mm_fault(struct mm_struct *mm
 	 */
 	pte = pte_offset_map(pmd, address);
 
+	pr_debug("%s jiffies64=%lld cpu=%d address=%08lx pmdval=%016llx ptehigh=%08lx ptelow=%08lx\n",__func__, get_jiffies_64(), smp_processor_id(), address, pmd->pmd, pte->pte_high, pte->pte_low);
+
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
---------------

I confirmed this phenomenon is reproduced on 2.6.31 and 2.6.38-rc5
of x86 kernel, and I heard this phenomenon doesn't occur on
x86-64 kernel from another engineer who found this problem first.

In addition, this phenomenon occurred on 4 boxes, so I think the cause
is not hardware malfunction.


Here is the run.sh of SPECjbb2005 when it is reproduced on my current box.
----------
date
echo $CLASSPATH
CLASSPATH=./jbb.jar:./jbb_no_precompile.jar:./check.jar:./reporter.jar:$CLASSPATH
echo $CLASSPATH
export CLASSPATH

/usr/bin/java -XX:+UseParallelGC -ms2032m -mx2032m -XX:-AlwaysPreTouch -verbosegc
spec.jbb.JBBmain -propfile SPECjbb.props_WH1-8

-----------


Though I'll continue to chase the cause of this problem, please help to solve this...

Thanks.

-- 
Yasunori Goto 


