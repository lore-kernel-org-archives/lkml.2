Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1DQPAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 11:00:15 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:29042
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab1DQPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 11:00:09 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK936eK1432N98dKzz1202hzzz32i637h668h839h34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJSXNW-01-06X-02
X-M-MSG: 
Date: Sun, 17 Apr 2011 13:23:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
Message-ID: <20110417112325.GN31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <1302943877.32491.9.camel@twins>
 <20110417081540.GL31407@erda.amd.com>
 <20110417081827.GC29733@elte.hu>
 <1303030412.2035.52.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Uu2n37VG4rOBDVuR"
Content-Disposition: inline
In-Reply-To: <1303030412.2035.52.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On 17.04.11 04:53:32, Peter Zijlstra wrote:
> On Sun, 2011-04-17 at 10:18 +0200, Ingo Molnar wrote:
> > So with 6 counters it would be a loop of 720, with 8 counters a loop of 40320, 
> > with 10 counters a loop of 3628800 ... O(n!) is not fun.
> 
> Right, and we'll hit this case at least once when scheduling a
> over-committed system. Intel Sandy Bridge can have 8 counters per core +
> 3 fixed counters, giving an n=11 situation. You do _NOT_ want to have
> one 39916800 cycle loop before we determine the PMU isn't schedulable,
> that's simply unacceptable.

Of course it is not that much as the algorithm is already optimized
and we only walk through possible ways. Also, the more constraints we
have the less we have to walk. So lets assume a worst case of 8
unconstraint counters, I reimplemented the algorithm in the perl
script attached and counted 251 loops, following numbers I got
depending on the number of counters:

 $ perl counter-scheduling.pl | grep Num
 Number of counters:  2, loops:  10, redos:   4, ratio: 2.5
 Number of counters:  3, loops:  26, redos:   7, ratio: 3.7
 Number of counters:  4, loops:  53, redos:  11, ratio: 4.8
 Number of counters:  5, loops:  89, redos:  15, ratio: 5.9
 Number of counters:  6, loops: 134, redos:  19, ratio: 7.1
 Number of counters:  7, loops: 188, redos:  23, ratio: 8.2
 Number of counters:  8, loops: 251, redos:  27, ratio: 9.3
 Number of counters:  9, loops: 323, redos:  31, ratio: 10.4
 Number of counters: 10, loops: 404, redos:  35, ratio: 11.5
 Number of counters: 11, loops: 494, redos:  39, ratio: 12.7
 Number of counters: 12, loops: 593, redos:  43, ratio: 13.8

It seems the algorithm is about number-of-counter times slower than
the current. I think this is worth some further considerations. There
is also some room for improvement with my algorithm.

-Robert


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

--Uu2n37VG4rOBDVuR
Content-Type: text/x-perl; charset="us-ascii"; name="counter-scheduling.pl"
Content-Disposition: attachment; filename="counter-scheduling.pl"
Content-Description: counter-scheduling.pl

#! /usr/bin/perl

#$num_ctrs = 11;

for ($num_ctrs = 2; $num_ctrs <= 12; $num_ctrs++) {

$num_events = $num_ctrs + 1;

@sched_log = ();
$scheduled = 0;
$used_mask = 0;

$loops = 0;
$redos = 0;
$scheduled = 0;

while ($scheduled < $num_events) {
    for ($idx = $sched_log[$scheduled] || 0; $idx < $num_ctrs; $idx++)
    {
	$loops++;
	last if !((1 << $idx) & $used_mask);
    }

    if ($idx == $num_ctrs) {
	printf "Failed to schedule event #%d\n", $scheduled;
	last if (!$scheduled);
	$sched_log[$scheduled] = 0;
	$scheduled--;
	$idx = $sched_log[$scheduled];
	$sched_log[$scheduled]++;
	$used_mask &= ~(1 << $idx);
	printf "Rollback event #%d on counter #%d\n", $scheduled, $idx;
	$redos++;
	redo;
    }

    $used_mask |= (1 << $idx);
    push @sched_log, $idx;
    printf "Scheduling event #%d on counter #%d\n", $scheduled, $idx;
    $scheduled++;
}

printf("Number of counters: %2d, loops: %3d, redos: %3d, ratio: %.1f\n",
       $num_ctrs, $loops, $redos, $loops / $redos);

}

--Uu2n37VG4rOBDVuR--
