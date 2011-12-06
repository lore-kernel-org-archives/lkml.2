Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1LFRTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:19:53 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:47832
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab1LFRTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:19:52 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275ch8275bh8275dhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVSLC1-02-7SY-02
X-M-MSG: 
Date: Tue, 6 Dec 2011 18:15:21 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] perf report: Setup browser if stdout is a pipe
Message-ID: <20111206171521.GM15738@erda.amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
 <1323167560-2282-7-git-send-email-robert.richter@amd.com>
 <20111206132910.GG7059@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111206132910.GG7059@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.11 11:29:10, Arnaldo Carvalho de Melo wrote:
> commit 46656ac7fb3252f8a3db29b18638e0e8067849ba
> Author: Tom Zanussi <tzanussi@gmail.com>
> Date:   Thu Apr 1 23:59:17 2010 -0500
> 
>     perf report: Introduce special handling for pipe input
>     
>     Adds special treatment for stdin - if the user specifies '-i -'
>     to perf report, the intent is that the event stream be written
>     to stdin rather than from a disk file.
>     
>     The actual handling of the '-' filename is done by the session;
>     this just adds a signal handler to stop reporting, and turns off
>     interference by the pager.
>     
>     Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
>     Acked-by: Thomas Gleixner <tglx@linutronix.de>
>     Cc: fweisbec@gmail.com
>     Cc: rostedt@goodmis.org
>     Cc: k-keiichi@bx.jp.nec.com
>     Cc: acme@ghostprotocols.net
>     LKML-Reference: <1270184365-8281-4-git-send-email-tzanussi@gmail.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> I can't understand the comment either, as I think it should've read "the
> intent is that the event stream be _read from stdin_ rather than from a
> disk file."
> 
> And I don't know what would be the pager interference there.
> 
> Tom, could you elaborate on this?

This patch is part of a patch set introducing "live mode". I guess the
intention here is to disable the pager for continuously writing to the
terminal and stopping perf with ^C, e.g. (notice the ^C):

 # perf record -e <...> -a | perf report
# perf record -a -e cpu-cycles | perf report -i -   
# ========
# captured on: Tue Dec  6 18:09:07 2011
# ========
#
^C# Events: 9  cycles
#
# Overhead  Command      Shared Object                          Symbol
[ perf record: Woken up 1 times to write data ]
# ........  .......  .................  ..............................
#
[ perf record: Captured and wrote 0.106 MB (null) (~4627 samples) ]
[...]

A pager would catch the ^C, also an appended pipe. So, my version also
does not work for this case, suggest to skip this patch first in favor
of a better solution.

But will have to rework the next patch because a potential null
pointer access to input_name.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

