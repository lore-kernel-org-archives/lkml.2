Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0CYIid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:38:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:64781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab0CYIib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:38:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,306,1267430400"; 
   d="scan'208";a="783777811"
Subject: hackbench regression due to commit 9dfc6e68bfe6e
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org, ling.ma@intel.com,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain
Organization: intel.com
Date: Thu, 25 Mar 2010 16:40:57 +0800
Message-Id: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hackbench benchmark dropped about 3~7% on our 2 sockets NHM machine
on 34-rc1 kernel. We find it is due to commit 9dfc6e68bfe6e, 

commit 9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Fri Dec 18 16:26:20 2009 -0600

    SLUB: Use this_cpu operations in slub
    
The hackbench is prepared hundreds pair of processes/threads. And each
of pair of processes consists of a receiver and a sender. After all
pairs created and ready with a few memory block (by malloc), hackbench
let the sender do appointed times sending to receiver via socket, then
wait all pairs finished. The total sending running time is the indicator
of this benchmark. The less the better.  
The socket send/receiver generate lots of slub alloc/free. slabinfo
command show the following slub get huge increase from about 81412344 to
141412497, after command "backbench 150 thread 1000" running.

Name                   Objects      Alloc       Free   %Fast Fallb O
:t-0001024                 870  141412497  141412132  94   1     0 3
:t-0000256                1607  141225312  141224177  94   1     0 1 


Via perf tool I collected the L1 data cache miss info of comamnd:
"./hackbench 150 thread 100"

On 33-rc1, about 1303976612 time L1 Dcache missing

On 9dfc6, about 1360574760 times L1 Dcache missing

I also disassemble the mm/built.o file, but seems no special change. 


BRG
Alex 


