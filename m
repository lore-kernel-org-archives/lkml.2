Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0DHHwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:52:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:9518 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0DHHws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,169,1270450800"; 
   d="scan'208";a="611226150"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev <netdev@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1270710019.2215.4.camel@edumazet-laptop>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
	 <1270542497.2078.123.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004061033330.18750@router.home>
	 <alpine.DEB.2.00.1004061552500.19151@router.home>
	 <1270591841.2091.170.camel@edumazet-laptop>
	 <1270607668.2078.259.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004071130260.13261@router.home>
	 <4BBCB7B7.4040901@cs.helsinki.fi> <4BBCB868.2000705@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004071319320.16159@router.home>
	 <1270665484.8141.47.camel@edumazet-laptop>
	 <1270688747.2078.383.camel@ymzhang.sh.intel.com>
	 <1270702774.8141.49.camel@edumazet-laptop>
	 <1270705153.8141.58.camel@edumazet-laptop>
	 <1270710019.2215.4.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 08 Apr 2010 15:54:50 +0800
Message-Id: <1270713290.2078.402.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 09:00 +0200, Eric Dumazet wrote:
> Le jeudi 08 avril 2010 à 07:39 +0200, Eric Dumazet a écrit :
> > I suspect NUMA is completely out of order on current kernel, or my
> > Nehalem machine NUMA support is a joke
> > 
> > # numactl --hardware
> > available: 2 nodes (0-1)
> > node 0 size: 3071 MB
> > node 0 free: 2637 MB
> > node 1 size: 3062 MB
> > node 1 free: 2909 MB
> > 
> > 
> > # cat try.sh
> > hackbench 50 process 5000
> > numactl --cpubind=0 --membind=0 hackbench 25 process 5000 >RES0 &
> > numactl --cpubind=1 --membind=1 hackbench 25 process 5000 >RES1 &
> > wait
> > echo node0 results
> > cat RES0
> > echo node1 results
> > cat RES1
> > 
> > numactl --cpubind=0 --membind=1 hackbench 25 process 5000 >RES0_1 &
> > numactl --cpubind=1 --membind=0 hackbench 25 process 5000 >RES1_0 &
> > wait
> > echo node0 on mem1 results
> > cat RES0_1
> > echo node1 on mem0 results
> > cat RES1_0
> > 
> > # ./try.sh
> > Running with 50*40 (== 2000) tasks.
> > Time: 16.865
> > node0 results
> > Running with 25*40 (== 1000) tasks.
> > Time: 16.767
> > node1 results
> > Running with 25*40 (== 1000) tasks.
> > Time: 16.564
> > node0 on mem1 results
> > Running with 25*40 (== 1000) tasks.
> > Time: 16.814
> > node1 on mem0 results
> > Running with 25*40 (== 1000) tasks.
> > Time: 16.896
> 
> If run individually, the tests results are more what we would expect
> (slow), but if machine runs the two set of process concurrently, each
> group runs much faster...
If there are 2 nodes in the machine, processes on node 0 will contact MCH of
node 1 to access memory of node 1. I suspect the MCH of node 1 might enter
a power-saving mode when all the cpus of node 1 are free. So the transactions
from MCH 1 to MCH 0 has a larger latency.

> 
> 
> # numactl --cpubind=0 --membind=1 hackbench 25 process 5000
> Running with 25*40 (== 1000) tasks.
> Time: 21.810
> 
> # numactl --cpubind=1 --membind=0 hackbench 25 process 5000
> Running with 25*40 (== 1000) tasks.
> Time: 20.679
> 
> # numactl --cpubind=0 --membind=1 hackbench 25 process 5000 >RES0_1 &
> [1] 9177
> # numactl --cpubind=1 --membind=0 hackbench 25 process 5000 >RES1_0 &
> [2] 9196
> # wait
> [1]-  Done                    numactl --cpubind=0 --membind=1 hackbench
> 25 process 5000 >RES0_1
> [2]+  Done                    numactl --cpubind=1 --membind=0 hackbench
> 25 process 5000 >RES1_0
> # echo node0 on mem1 results
> node0 on mem1 results
> # cat RES0_1
> Running with 25*40 (== 1000) tasks.
> Time: 13.818
> # echo node1 on mem0 results
> node1 on mem0 results
> # cat RES1_0
> Running with 25*40 (== 1000) tasks.
> Time: 11.633
> 
> Oh well...
> 
> 


