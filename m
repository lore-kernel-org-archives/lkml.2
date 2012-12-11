Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2LKMKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:10:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:22609 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab2LKMKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:10:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,259,1355126400"; 
   d="scan'208";a="260464110"
Message-ID: <50C722AC.3080806@intel.com>
Date: Tue, 11 Dec 2012 20:10:20 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <lkml.alex@gmail.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
In-Reply-To: <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 08:51 AM, Alex Shi wrote:
> On Mon, Dec 10, 2012 at 4:22 PM, Alex Shi <alex.shi@intel.com> wrote:
>> This patchset base on tip/sched/core tree temporary, since it is more
>> steady than tip/master. and it's easy to rebase on tip/master.
>>
>> It includes 3 parts changes.
>>
>> 1, simplified fork, patch 1~4, that simplified the fork/exec/wake log in
>> find_idlest_group and select_task_rq_fair. it can increase 10+%
>> hackbench process and thread performance on our 4 sockets SNB EP machine.
>>
>> 2, enable load average into LB, patch 5~9, that using load average in
>> load balancing, with a runnable load value industrialization bug fix and
>> new fork task load contrib enhancement.
>>
>> 3, power awareness scheduling, patch 10~18,
>> Defined 2 new power aware policy balance and
>> powersaving, and then try to spread or shrink tasks on CPU unit
>> according the different scheduler policy. That can save much power when
>> task number in system is no more then cpu number.
> 
> tried with sysbench fileio test rndrw mode, with half thread of LCPU number,
> performance is similar, power can save about 5~10 Watts on 2 sockets SNB EP
> and NHM EP boxes.

Another testing of parallel compress with pigz on Linus' git tree.
results show we get much better performance/power with powersaving and
balance policy:

testing command:
#pigz -k -c  -p$x -r linux* &> /dev/null

On a NHM EP box
         powersaving               balance   	         performance
x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76

On a 2 sockets SNB EP box.
         powersaving               balance   	         performance
x = 4    190.995 /149 35          200.6 /129 38          208.561 /135 35
x = 8    197.969 /108 46          208.885 /103 46        213.96 /108 43
x = 16   205.163 /76 64           212.144 /91 51         229.287 /97 44

data format is: 166.516 /88 68
        166.516: avagerage Watts
        88: seconds(compress time)
        68:  scaled performance/power = 1000000 / time / power


