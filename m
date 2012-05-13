Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2EMSqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:46:12 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55981 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2EMSqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:46:09 -0400
Message-ID: <4FB0014A.90604@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 00:15:30 +0530
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
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com> <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com>
In-Reply-To: <4FA7E1C8.7010509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12051318-8878-0000-0000-000002700AA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 08:22 PM, Avi Kivity wrote:

I could not come with pv-flush results (also Nikunj had clarified that
the result was on NOn PLE

> I'd like to see those numbers, then.
>
> Ingo, please hold on the kvm-specific patches, meanwhile.
>

3 guests 8GB RAM, 1 used for kernbench
(kernbench -f -H -M -o 20) other for cpuhog (shell script with  while
true do hackbench)

1x: no hogs
2x: 8hogs in one guest
3x: 8hogs each in two guest

kernbench on PLE:
Machine : IBM xSeries with Intel(R) Xeon(R)  X7560 2.27GHz CPU with 32 
core, with 8 online cpus and 4*64GB RAM.

The average is taken over 4 iterations with 3 run each (4*3=12). and 
stdev is calculated over mean reported in each run.


A): 8 vcpu guest

                  BASE                    BASE+patch 
%improvement w.r.t
                  mean (sd)               mean (sd)              patched 
kernel time
case 1*1x:	61.7075  (1.17872)	60.93     (1.475625)    1.27605
case 1*2x:	107.2125 (1.3821349)	97.506675 (1.3461878)   9.95401
case 1*3x:	144.3515 (1.8203927)	138.9525  (0.58309319)  3.8855


B): 16 vcpu guest
                  BASE                    BASE+patch 
%improvement w.r.t
                  mean (sd)               mean (sd)              patched 
kernel time
case 2*1x:	70.524   (1.5941395)	69.68866  (1.9392529)   1.19867
case 2*2x:	133.0738 (1.4558653)	124.8568  (1.4544986)   6.58114
case 2*3x:	206.0094 (1.3437359)	181.4712  (2.9134116)   13.5218

B): 32 vcpu guest
                  BASE                    BASE+patch 
%improvementw.r.t
                  mean (sd)               mean (sd)              patched 
kernel time
case 4*1x:	100.61046 (2.7603485)	 85.48734  (2.6035035)  17.6905

It seems while we do not see any improvement in low contention case,
the benefit becomes evident with overcommit and large guests. I am
continuing analysis with other benchmarks (now with pgbench to check if
it has acceptable improvement/degradation in low contenstion case).

Avi,
Can patch series go ahead for inclusion into tree with following
reasons:

The patch series brings fairness with ticketlock ( hence the
predictability, since during contention, vcpu trying
  to acqire lock is sure that it gets its turn in less than total number 
of vcpus conntending for lock), which is very much desired irrespective
of its low benefit/degradation (if any) in low contention scenarios.

Ofcourse ticketlocks had undesirable effect of exploding LHP problem,
and the series addresses with improvement in scheduling and sleeping 
instead of burning cpu time.

Finally a less famous one, it brings almost PLE equivalent capabilty to
all the non PLE hardware (TBH I always preferred my experiment kernel to 
be compiled in my pv guest that saves more than 30 min of time for each 
run).

It would be nice to see any results if somebody got benefited/suffered 
with patchset.

