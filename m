Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0CZCck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:32:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:10839 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0CZCcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:32:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,310,1267430400"; 
   d="scan'208";a="552284114"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.00.1003250942080.2670@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
Content-Type: text/plain
Organization: intel.com
Date: Fri, 26 Mar 2010 10:35:02 +0800
Message-Id: <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 22:49 +0800, Christoph Lameter wrote:
> On Thu, 25 Mar 2010, Alex Shi wrote:
> 
> >     SLUB: Use this_cpu operations in slub
> >
> > The hackbench is prepared hundreds pair of processes/threads. And each
> > of pair of processes consists of a receiver and a sender. After all
> > pairs created and ready with a few memory block (by malloc), hackbench
> > let the sender do appointed times sending to receiver via socket, then
> > wait all pairs finished. The total sending running time is the indicator
> > of this benchmark. The less the better.
> 
> > The socket send/receiver generate lots of slub alloc/free. slabinfo
> > command show the following slub get huge increase from about 81412344 to
> > 141412497, after command "backbench 150 thread 1000" running.
> 
> The number of frees is different? From 81 mio to 141 mio? Are you sure it
> was the same load?
The slub free number has similar increase, the following is the data
before testing:
name                   Objects      Alloc       Free   %Fast Fallb Onn
:t-0001024                 855   81412344   81411981  93   1     0 3
:t-0000256                1540   81224970   81223835  93   1     0 1

I am sure there is no effective task running when I do testing. 

Just for this info, CONFIG_SLUB_STATS enabled.

> 
> > Name                   Objects      Alloc       Free   %Fast Fallb O
> > :t-0001024                 870  141412497  141412132  94   1     0 3
> > :t-0000256                1607  141225312  141224177  94   1     0 1
> >
> >
> > Via perf tool I collected the L1 data cache miss info of comamnd:
> > "./hackbench 150 thread 100"
> >
> > On 33-rc1, about 1303976612 time L1 Dcache missing
> >
> > On 9dfc6, about 1360574760 times L1 Dcache missing
> 
> I hope this is the same load?
for the same load parameter: ./hackbench 150 thread 1000
on 33-rc1, about 10649258360 times L1 Dcache missing
on 9dfc6, about 11061002507 times L1 Dcahce missing

For this this info, without CONFIG_SLUB_STATS and slub_debug is close. 

> 
> What debugging options did you use? We are now using per cpu operations in
> the hot paths. Enabling debugging for per cpu ops could decrease your
> performance now. Have a look at a dissassembly of kfree() to verify that
> there is no instrumentation.
> 
Basically, slub_debug never opened in booting, some SLUB related kernel
config is here:
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
#CONFIG_SLUB_DEBUG_ON is not set

I just dissemble kfree, but whether the KMEMTRACE enabled or not, the
trace_kfree code stay in kfree function, and in my testing the debugfs
are not mounted.  

> 

