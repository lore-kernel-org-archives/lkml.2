Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1DRISJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:18:09 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:27934 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1DRISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:18:06 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2cK98dKzz1202hzzz32i637h668h839h34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJU9Q0-02-2W6-02
X-M-MSG: 
Date: Mon, 18 Apr 2011 10:17:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
Message-ID: <20110418081758.GO31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <1302943877.32491.9.camel@twins>
 <20110417081540.GL31407@erda.amd.com>
 <20110417081827.GC29733@elte.hu>
 <1303030412.2035.52.camel@laptop>
 <20110417112325.GN31407@erda.amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/GPgYEyhnw15BExa"
Content-Disposition: inline
In-Reply-To: <20110417112325.GN31407@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/GPgYEyhnw15BExa
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On 17.04.11 13:23:25, Robert Richter wrote:

>  $ perl counter-scheduling.pl | grep Num
>  Number of counters:  2, loops:  10, redos:   4, ratio: 2.5
>  Number of counters:  3, loops:  26, redos:   7, ratio: 3.7
>  Number of counters:  4, loops:  53, redos:  11, ratio: 4.8
>  Number of counters:  5, loops:  89, redos:  15, ratio: 5.9
>  Number of counters:  6, loops: 134, redos:  19, ratio: 7.1
>  Number of counters:  7, loops: 188, redos:  23, ratio: 8.2
>  Number of counters:  8, loops: 251, redos:  27, ratio: 9.3
>  Number of counters:  9, loops: 323, redos:  31, ratio: 10.4
>  Number of counters: 10, loops: 404, redos:  35, ratio: 11.5
>  Number of counters: 11, loops: 494, redos:  39, ratio: 12.7
>  Number of counters: 12, loops: 593, redos:  43, ratio: 13.8

Wrong, wrong, wrong!

Before wasting your time with this, the script is buggy storing the
correct state:

@@ -35,7 +35,7 @@ while ($scheduled < $num_events) {
     }
 
     $used_mask |= (1 << $idx);
-    push @sched_log, $idx;
+    $sched_log[$scheduled] = $idx;
     printf "Scheduling event #%d on counter #%d\n", $scheduled, $idx;
     $scheduled++;
 }

It's not possible do the calculation for 11 counters in reasonable
time:

 $ perl counter-scheduling.pl | grep Num
 Number of counters:  2, loops:  10, redos:   4, ratio: 2.5
 Number of counters:  3, loops:  48, redos:  15, ratio: 3.2
 Number of counters:  4, loops: 260, redos:  64, ratio: 4.1
 Number of counters:  5, loops: 1630, redos: 325, ratio: 5.0
 Number of counters:  6, loops: 11742, redos: 1956, ratio: 6.0
 Number of counters:  7, loops: 95900, redos: 13699, ratio: 7.0
 Number of counters:  8, loops: 876808, redos: 109600, ratio: 8.0
 Number of counters:  9, loops: 8877690, redos: 986409, ratio: 9.0
 Number of counters: 10, loops: 98641010, redos: 9864100, ratio: 10.0

Updated script attached.

Sorry,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

--/GPgYEyhnw15BExa
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
    $sched_log[$scheduled] = $idx;
    printf "Scheduling event #%d on counter #%d\n", $scheduled, $idx;
    $scheduled++;
}

printf("Number of counters: %2d, loops: %3d, redos: %3d, ratio: %.1f\n",
       $num_ctrs, $loops, $redos, $loops / $redos);

}

--/GPgYEyhnw15BExa--
