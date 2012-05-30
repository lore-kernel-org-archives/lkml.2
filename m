Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2E3L1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:27:20 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52049 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2E3L1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:27:18 -0400
Message-ID: <4FC603D4.20107@linux.vnet.ibm.com>
Date: Wed, 30 May 2012 16:56:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com> <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com> <4FB0014A.90604@linux.vnet.ibm.com> <4FB31CA4.5070908@linux.vnet.ibm.com>
In-Reply-To: <4FB31CA4.5070908@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12053001-1618-0000-0000-000001B8B372
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 08:49 AM, Raghavendra K T wrote:
> On 05/14/2012 12:15 AM, Raghavendra K T wrote:
>> On 05/07/2012 08:22 PM, Avi Kivity wrote:
>>
>> I could not come with pv-flush results (also Nikunj had clarified that
>> the result was on NOn PLE
>>
>>> I'd like to see those numbers, then.
>>>
>>> Ingo, please hold on the kvm-specific patches, meanwhile.
[...]
> To summarise,
> with 32 vcpu guest with nr thread=32 we get around 27% improvement. In
> very low/undercommitted systems we may see very small improvement or
> small acceptable degradation ( which it deserves).
>

For large guests, current value SPIN_THRESHOLD, along with ple_window 
needed some of research/experiment.

[Thanks to Jeremy/Nikunj for inputs and help in result analysis ]

I started with debugfs spinlock/histograms, and ran experiments with 32, 
64 vcpu guests for spin threshold of 2k, 4k, 8k, 16k, and 32k with
1vm/2vm/4vm  for kernbench, sysbench, ebizzy, hackbench.
[ spinlock/histogram  gives logarithmic view of lockwait times ]

machine: PLE machine  with 32 cores.

Here is the result summary.
The summary includes 2 part,
(1) %improvement w.r.t 2K spin threshold,
(2) improvement w.r.t sum of histogram numbers in debugfs (that gives 
rough indication of contention/cpu time wasted)

  For e.g 98% for 4k threshold kbench 1 vm would imply, there is a 98% 
reduction in sigma(histogram values) compared to 2k case

Result for 32 vcpu guest
==========================
+----------------+-----------+-----------+-----------+-----------+
|    Base-2k     |     4k    |    8k     |   16k     |    32k    |
+----------------+-----------+-----------+-----------+-----------+
|     kbench-1vm |       44  |       50  |       46  |       41  |
|  SPINHisto-1vm |       98  |       99  |       99  |       99  |
|     kbench-2vm |       25  |       45  |       49  |       45  |
|  SPINHisto-2vm |       31  |       91  |       99  |       99  |
|     kbench-4vm |      -13  |      -27  |       -2  |       -4  |
|  SPINHisto-4vm |       29  |       66  |       95  |       99  |
+----------------+-----------+-----------+-----------+-----------+
|     ebizzy-1vm |      954  |      942  |      913  |      915  |
|  SPINHisto-1vm |       96  |       99  |       99  |       99  |
|     ebizzy-2vm |      158  |      135  |      123  |      106  |
|  SPINHisto-2vm |       90  |       98  |       99  |       99  |
|     ebizzy-4vm |      -13  |      -28  |      -33  |      -37  |
|  SPINHisto-4vm |       83  |       98  |       99  |       99  |
+----------------+-----------+-----------+-----------+-----------+
|     hbench-1vm |       48  |       56  |       52  |       64  |
|  SPINHisto-1vm |       92  |       95  |       99  |       99  |
|     hbench-2vm |       32  |       40  |       39  |       21  |
|  SPINHisto-2vm |       74  |       96  |       99  |       99  |
|     hbench-4vm |       27  |       15  |        3  |      -57  |
|  SPINHisto-4vm |       68  |       88  |       94  |       97  |
+----------------+-----------+-----------+-----------+-----------+
|    sysbnch-1vm |        0  |        0  |        1  |        0  |
|  SPINHisto-1vm |       76  |       98  |       99  |       99  |
|    sysbnch-2vm |       -1  |        3  |       -1  |       -4  |
|  SPINHisto-2vm |       82  |       94  |       96  |       99  |
|    sysbnch-4vm |        0  |       -2  |       -8  |      -14  |
|  SPINHisto-4vm |       57  |       79  |       88  |       95  |
+----------------+-----------+-----------+-----------+-----------+

result for 64  vcpu guest
=========================
+----------------+-----------+-----------+-----------+-----------+
|    Base-2k     |     4k    |    8k     |   16k     |    32k    |
+----------------+-----------+-----------+-----------+-----------+
|     kbench-1vm |        1  |      -11  |      -25  |       31  |
|  SPINHisto-1vm |        3  |       10  |       47  |       99  |
|     kbench-2vm |       15  |       -9  |      -66  |      -15  |
|  SPINHisto-2vm |        2  |       11  |       19  |       90  |
+----------------+-----------+-----------+-----------+-----------+
|     ebizzy-1vm |      784  |     1097  |      978  |      930  |
|  SPINHisto-1vm |       74  |       97  |       98  |       99  |
|     ebizzy-2vm |       43  |       48  |       56  |       32  |
|  SPINHisto-2vm |       58  |       93  |       97  |       98  |
+----------------+-----------+-----------+-----------+-----------+
|     hbench-1vm |        8  |       55  |       56  |       62  |
|  SPINHisto-1vm |       18  |       69  |       96  |       99  |
|     hbench-2vm |       13  |      -14  |      -75  |      -29  |
|  SPINHisto-2vm |       57  |       74  |       80  |       97  |
+----------------+-----------+-----------+-----------+-----------+
|    sysbnch-1vm |        9  |       11  |       15  |       10  |
|  SPINHisto-1vm |       80  |       93  |       98  |       99  |
|    sysbnch-2vm |        3  |        3  |        4  |        2  |
|  SPINHisto-2vm |       72  |       89  |       94  |       97  |
+----------------+-----------+-----------+-----------+-----------+

 From this, value around 4k-8k threshold seem to be optimal one. [ This 
is amost inline with ple_window default ]
(lower the spin threshold, we would cover lesser % of spinlocks, that 
would result in more halt_exit/wakeups.

[ www.xen.org/files/xensummitboston08/LHP.pdf also has good graphical 
detail on covering spinlock waits ]

After 8k threshold, we see no more contention but that would mean we 
have wasted lot of cpu time in busy waits.

Will get a PLE machine again, and 'll continue experimenting with 
further tuning of SPIN_THRESHOLD.

