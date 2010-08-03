Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0HCGy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 02:54:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:8703 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab0HCGyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 02:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,308,1278313200"; 
   d="scan'208";a="644167277"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 3 Aug 2010 07:53:38 +0100
Subject: RE: [RFC] BTS based perf user callchains
Thread-Topic: [RFC] BTS based perf user callchains
Thread-Index: AcsycXb+VmNmP/nbRG6bnNHlpO9O/wAY9Tqw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E010C699E26@irsmsx504.ger.corp.intel.com>
References: <20100802183506.GA8962@nowhere>
In-Reply-To: <20100802183506.GA8962@nowhere>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: FFF3 KZhD KtpF OZbq a3IJ gOhK iEBK jokv kfNJ k+hd zMEw
 6S/Y ACkJwg== ADRQLQ== AD1gnw==
 AEQ0oQ==;8;YQAuAHAALgB6AGkAagBsAHMAdAByAGEAQABjAGgAZQBsAGwAbwAuAG4AbAA7AGEAYwBtAGUAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAZQByAGEAbgBpAGEAbgBAAGcAbwBvAGcAbABlAC4AYwBvAG0AOwBmAHcAZQBpAHMAYgBlAGMAQABnAG0AYQBpAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGkAbgBnAG8AQABlAGwAdABlAC4AaAB1ADsAcABhAHUAbAB1AHMAQABzAGEAbQBiAGEALgBvAHIAZwA7AHIAbwBiAGUAcgB0AC4AcgBpAGMAaAB0AGUAcgBAAGEAbQBkAC4AYwBvAG0A;Sosha1_v1;7;{75BF279C-C0DE-4901-9207-F630AC1E4EFC};bQBhAHIAawB1AHMALgB0AC4AbQBlAHQAegBnAGUAcgBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Tue,
 03 Aug 2010 06:53:38
 GMT;UgBFADoAIABbAFIARgBDAF0AIABCAFQAUwAgAGIAYQBzAGUAZAAgAHAAZQByAGYAIAB1AHMAZQByACAAYwBhAGwAbABjAGgAYQBpAG4AcwA=
x-cr-puzzleid: {75BF279C-C0DE-4901-9207-F630AC1E4EFC}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Frederic Weisbecker [mailto:fweisbec@gmail.com]
>Sent: Monday, August 02, 2010 8:35 PM
>To: Ingo Molnar; Peter Zijlstra; Arnaldo Carvalho de Melo; Paul Mackerras; Stephane Eranian; Metzger,
>Markus T; Robert Richter
>Cc: LKML
>Subject: [RFC] BTS based perf user callchains
>
>Hi,
>
>As you may know there is an issue with user stacktraces: it requires
>userspace apps to be built with frame pointers.

It requires DWARF to correctly describe how to unwind a frame. You can also
generate ESP-based frames and still get a correct backtrace, provided you
have debug information.


>So there is something we can try: dump a piece of the top user stack page
>each time we have an event hit and let the tools deal with that later using
>the dwarf informations.
>
>But before trying that, which might require heavy copies, I would like to
>try something based on BTS. The idea is to look at the branch buffer and
>only pick addresses of branches that originated from "call" instructions.

You would also need to track returns.


>So we want BTS activated, only in user ring, without the need of interrupts
>once we reach the limit of the buffer, we can just run in a kind of live
>mode and read on need. This could be a secondary perf event that has no mmap
>buffer. Something only used by the kernel internally by others true perf events
>in a given context. Primary perf events can then read on this BTS buffer when
>they want.
>
>Now there are two ways:
>
>- record the whole branch buffer each time we overflow on another perf event
>and let post processing userspace deal with "call" instruction filtering to
>build the stacktrace on top of the branch trace.

If you only care about backtrace, there will be too much noise in the data.
I doubt that you will get a very deep backtrace.

On the other hand, the trace data might be useful for other purposes. But
then, what you would want is BTS and perf events collected in the same buffer.


>- do the "call" filtering on record time. That requires to inspect each
>recorded branches and look at the instruction content from the fast path.

You can try to use LBR for that. Core i7 adds LBR filters that allow you to
only record calls and returns. You will be limited to a handful of records, but
I doubt that you will get much more out of a page of BTS.


With both approaches, the backtrace will not be very deep. There is so much
traffic at the top of the stack that you won't find entries further down.


>I'm not even sure that will work. Also, while looking at the BTS implementation
>in perf, I see we have one BTS buffer per cpu. But that doesn't look right as
>the code flow is not linear per cpu but per task. Hence I suspect we need
>one BTS buffer per task. But may be someone tried that and encountered a
>problem?


When BTS was stand-alone, there had been one buffer per task. It now uses the perf
ring buffer. The per-cpu buffers are only used to collect the data. On context
switch or buffer overflow, the data is copied into the perf ring buffer.


regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

