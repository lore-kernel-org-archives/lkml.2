Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967239Ab2EPDUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 23:20:11 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54045 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab2EPDUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 23:20:06 -0400
Message-ID: <4FB31CA4.5070908@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 08:49:00 +0530
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
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com> <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com> <4FB0014A.90604@linux.vnet.ibm.com>
In-Reply-To: <4FB0014A.90604@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12051603-4790-0000-0000-000002B78C9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 12:15 AM, Raghavendra K T wrote:
> On 05/07/2012 08:22 PM, Avi Kivity wrote:
>
> I could not come with pv-flush results (also Nikunj had clarified that
> the result was on NOn PLE
>
>> I'd like to see those numbers, then.
>>
>> Ingo, please hold on the kvm-specific patches, meanwhile.
>>
>
> 3 guests 8GB RAM, 1 used for kernbench
> (kernbench -f -H -M -o 20) other for cpuhog (shell script with while
> true do hackbench)
>
> 1x: no hogs
> 2x: 8hogs in one guest
> 3x: 8hogs each in two guest
>
> kernbench on PLE:
> Machine : IBM xSeries with Intel(R) Xeon(R) X7560 2.27GHz CPU with 32
> core, with 8 online cpus and 4*64GB RAM.
>
> The average is taken over 4 iterations with 3 run each (4*3=12). and
> stdev is calculated over mean reported in each run.
>
>
> A): 8 vcpu guest
>
> BASE BASE+patch %improvement w.r.t
> mean (sd) mean (sd) patched kernel time
> case 1*1x: 61.7075 (1.17872) 60.93 (1.475625) 1.27605
> case 1*2x: 107.2125 (1.3821349) 97.506675 (1.3461878) 9.95401
> case 1*3x: 144.3515 (1.8203927) 138.9525 (0.58309319) 3.8855
>
>
> B): 16 vcpu guest
> BASE BASE+patch %improvement w.r.t
> mean (sd) mean (sd) patched kernel time
> case 2*1x: 70.524 (1.5941395) 69.68866 (1.9392529) 1.19867
> case 2*2x: 133.0738 (1.4558653) 124.8568 (1.4544986) 6.58114
> case 2*3x: 206.0094 (1.3437359) 181.4712 (2.9134116) 13.5218
>
> B): 32 vcpu guest
> BASE BASE+patch %improvementw.r.t
> mean (sd) mean (sd) patched kernel time
> case 4*1x: 100.61046 (2.7603485) 85.48734 (2.6035035) 17.6905
>
> It seems while we do not see any improvement in low contention case,
> the benefit becomes evident with overcommit and large guests. I am
> continuing analysis with other benchmarks (now with pgbench to check if
> it has acceptable improvement/degradation in low contenstion case).

Here are the results for pgbench and sysbench. Here the results are on a 
single guest.

Machine : IBM xSeries with Intel(R) Xeon(R)  X7560 2.27GHz CPU with 32 
core, with 8
          online cpus and 4*64GB RAM.

Guest config: 8GB RAM

pgbench
==========

   unit=tps (higher is better)
   pgbench based on pgsql 9.2-dev:
	http://www.postgresql.org/ftp/snapshot/dev/ (link given by Attilo)

   tool used to collect benachmark: 
git://git.postgresql.org/git/pgbench-tools.git
   config: MAX_WORKER=16 SCALE=32 run for NRCLIENTS = 1, 8, 64

Average taken over 10 iterations.

      8 vcpu guest	

      N  base	   patch	improvement
      1  5271       5235    	-0.687679
      8  37953      38202    	0.651798
      64 37546      37774    	0.60359


      16 vcpu guest	

      N  base	   patch	improvement
      1  5229       5239  	0.190876
      8  34908      36048    	3.16245
      64 51796      52852   	1.99803

sysbench
==========
sysbench 0.4.12 cnfigured for postgres driver ran with
sysbench --num-threads=8/16/32 --max-requests=100000 --test=oltp 
--oltp-table-size=500000 --db-driver=pgsql --oltp-read-only run
annalysed with ministat with
x patch
+ base

8 vcpu guest
---------------
1) num_threads = 8
     N           Min           Max        Median           Avg        Stddev
x  10       20.7805         21.55       20.9667      21.03502    0.22682186
+  10        21.025       22.3122      21.29535      21.41793    0.39542349
Difference at 98.0% confidence
	1.82035% +/- 1.74892%

2) num_threads = 16
     N           Min           Max        Median           Avg        Stddev
x  10       20.8786       21.3967       21.1566      21.14441    0.15490983
+  10       21.3992       21.9437      21.46235      21.58724     0.2089425
Difference at 98.0% confidence
	2.09431% +/- 0.992732%

3) num_threads = 32
     N           Min           Max        Median           Avg        Stddev
x  10       21.1329       21.3726      21.33415       21.2893    0.08324195
+  10       21.5692       21.8966       21.6441      21.65679   0.093430003
Difference at 98.0% confidence
	1.72617% +/- 0.474343%


16 vcpu guest
---------------
1) num_threads = 8
     N           Min           Max        Median           Avg        Stddev
x  10       23.5314       25.6118      24.76145      24.64517    0.74856264
+  10       22.2675       26.6204       22.9131      23.50554      1.345386
No difference proven at 98.0% confidence

2) num_threads = 16
     N           Min           Max        Median           Avg        Stddev
x  10       12.0095       12.2305      12.15575      12.13926   0.070872722
+  10        11.413       11.6986       11.4817        11.493   0.080007819
Difference at 98.0% confidence
	-5.32372% +/- 0.710561%

3) num_threads = 32
     N           Min           Max        Median           Avg        Stddev
x  10       12.1378       12.3567      12.21675      12.22703     0.0670695
+  10        11.573       11.7438       11.6306      11.64905   0.062780221
Difference at 98.0% confidence
	-4.72707% +/- 0.606349%


32 vcpu guest
---------------
1) num_threads = 8
     N           Min           Max        Median           Avg        Stddev
x  10       30.5602       41.4756      37.45155      36.43752     3.5490215
+  10       21.1183       49.2599      22.60845      29.61119     11.269393
No difference proven at 98.0% confidence

2) num_threads = 16
     N           Min           Max        Median           Avg        Stddev
x  10       12.2556       12.9023       12.4968      12.55764    0.25330459
+  10       11.7627       11.9959       11.8419      11.86256   0.088563903
Difference at 98.0% confidence
	-5.53512% +/- 1.72448%

3) num_threads = 32
     N           Min           Max        Median           Avg        Stddev
x  10       16.8751       17.0756      16.97335      16.96765   0.063197191
+  10       21.3763       21.8111       21.6799      21.66438    0.13059888
Difference at 98.0% confidence
	27.6805% +/- 0.690056%


To summarise,
with 32 vcpu guest with nr thread=32 we get around 27% improvement. In 
very low/undercommitted systems we may see very small improvement or 
small acceptable degradation ( which it deserves).

(IMO with more overcommit/contention, we can get more than 15% for the 
benchmarks and we do ).

  Please let me know if you have any suggestions for try.
(Currently my PLE machine lease is expired, it may take some time to 
comeback :()

  Ingo, Avi ?


>
> Avi,
> Can patch series go ahead for inclusion into tree with following
> reasons:
>
> The patch series brings fairness with ticketlock ( hence the
> predictability, since during contention, vcpu trying
> to acqire lock is sure that it gets its turn in less than total number
> of vcpus conntending for lock), which is very much desired irrespective
> of its low benefit/degradation (if any) in low contention scenarios.
>
> Ofcourse ticketlocks had undesirable effect of exploding LHP problem,
> and the series addresses with improvement in scheduling and sleeping
> instead of burning cpu time.
>
> Finally a less famous one, it brings almost PLE equivalent capabilty to
> all the non PLE hardware (TBH I always preferred my experiment kernel to
> be compiled in my pv guest that saves more than 30 min of time for each
> run).

