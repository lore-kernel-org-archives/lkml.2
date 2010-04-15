Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0DOFR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:17:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:60037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753558Ab0DOFR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:17:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NynoBk7PN5taeF5AbHFl+higZ/O05nPO/+G7j0z
	cnjlLrfGMWwh+c
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1271277923.2875.35.camel@sbs-t61.sc.intel.com>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
	 <1270099940.6707.148.camel@marge.simson.net>
	 <1270155872.2762.310.camel@sbs-t61.sc.intel.com>
	 <1270189239.6513.78.camel@marge.simson.net>
	 <1271277923.2875.35.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Thu, 15 Apr 2010 07:17:21 +0200
Message-Id: <1271308641.14779.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 13:45 -0700, Suresh Siddha wrote:
> On Thu, 2010-04-01 at 23:20 -0700, Mike Galbraith wrote:
> > Do you have a compute load bouncing painfully which this patch cures?
> > 
> > I have no strong objections, and the result is certainly easier on the
> > eye.  If I were making the decision, I'd want to see some numbers.
> 
> Mike, PeterZ,
> 
> Finally got sometime to get back to this and provide some data backing
> up my patch under discussion. Here are my test results:
> 
> System is a two socket quad-core NHM-EP with SMT enabled and the
> workload is specjbb2005.
> 
> Warehouses    	Throughput
> 	     tip   tip+proposed-fix
>     1	    35142   35027
>     2	    73563   75977
>     3	   105806  109836
>     4	   133421  142490
>     5	   152151  168888
>     6	   164936  195392
>     7	   184763  208155
>     8	   192419  223846
> 
> PeterZ, I think the above clearly shows that we have a problem with the
> current -tip code. Please consider the proposed patch (which can be
> found at http://marc.info/?l=linux-kernel&m=127007936408754&w=2)
> 
> Mike, with the above data, can I have your Ack for the patch?

Sure (not that you need it).  A bit of abbreviated testing this morning
showed no big hairy differences.  A bit of loss to very fast switchers,
but OTOH it improved ramp a bit for mysql/pgsql+oltp.

tip = v2.6.34-rc4-937-gba0b2c9
tip-x = tip + your patches

netperf TCP_RR
unpinned
tip          102877.39   102860.66   103210.25   avg 102982.76   1.000
tip-x        100926.59   100380.26   100536.35   avg 100614.40    .977

pinned
tip          100181.70   100288.34    99711.16   avg 100060.40   1.000
tip-x         99347.12   100551.80    99827.22   avg  99908.71    .998

tbench 8
tip          1195.51   1194.49   1197.46   avg 1195.82   1.000
tip-x        1183.19   1188.00   1188.13   avg 1186.44    .992

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          10424.24   20417.42   37151.84   36777.79   36442.06   36122.14   33803.15   30109.81   28368.75
             11196.80   20443.43   37560.39   37358.14   36822.26   36132.95   34411.88   30349.47   28909.04
             11204.02   20513.21   37550.11   37219.52   36840.44   36150.47   34445.02   30975.95   28840.59
tip avg      10941.68   20458.02   37420.78   37118.48   36701.58   36135.18   34220.01   30478.41   28706.12

tip-x        10331.62   20981.89   36768.45   36556.19   36069.56   35612.24   34100.70   30459.80   29043.76
             11101.77   21153.77   37622.83   37228.68   36845.37   36256.04   34606.37   31287.36   28635.98
             11076.66   21153.41   37703.80   37242.89   36842.93   36296.27   34733.06   30578.00   29313.10
tip-x avg    10836.68   21096.35   37365.02   37009.25   36585.95   36054.85   34480.04   30775.05   28997.61
vs tip           .990      1.031       .998       .997       .996       .997      1.007      1.009      1.010

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          14683.30   30452.18   53826.68   53793.77   52931.67   51959.47   51326.82   49205.13   46884.50
             16154.17   30811.46   54277.20   53916.07   52792.89   52031.80   50967.99   48757.04   46259.84
             16151.36   29913.89   54071.21   53499.94   52707.50   51867.73   50887.40   49310.96   46544.42
tip avg      15662.94   30392.51   54058.36   53736.59   52810.68   51953.00   51060.73   49091.04   46562.92

tip-x        14641.30   31402.11   54267.43   53835.83   53024.57   51992.08   50336.10   49083.58   46662.24
             16167.44   31427.53   54008.47   53685.56   52709.81   52131.85   50848.08   48824.32   45973.29
             16259.76   31381.42   54327.51   53791.91   52857.70   51912.42   50941.33   49028.19   45938.22
tip-x avg    15689.50   31403.68   54201.13   53771.10   52864.02   52012.11   50708.50   48978.69   46191.25
vs tip          1.001      1.033      1.002      1.000      1.001      1.001       .993       .997       .992


