Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab0JYRjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:39:49 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54126 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758937Ab0JYRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:39:48 -0400
Date: Mon, 25 Oct 2010 13:39:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Goulet <david.goulet@polymtl.ca>
Cc: Nils Carlson <nils.carlson@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        ltt-dev@lists.casi.polymtl.ca
Subject: [RFC] TRACE_EVENT: mapping "=" and memcpy to macros
Message-ID: <20101025173943.GA29970@Krystal>
References: <4CC1BAA1.9070202@polymtl.ca> <913BC6918ED247478A38326BC12AAECE04D399B2@ESESSCMS0358.eemea.ericsson.se> <913BC6918ED247478A38326BC12AAECE04D399CF@ESESSCMS0358.eemea.ericsson.se> <913BC6918ED247478A38326BC12AAECE04D39AD7@ESESSCMS0358.eemea.ericsson.se> <4CC5AA98.7020308@polymtl.ca> <20101025171954.GD11891@Krystal> <4CC5BDC2.9020401@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC5BDC2.9020401@polymtl.ca>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:30:14 up 32 days, 21:32,  3 users,  load average: 0.20, 0.16,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng needs to override the assignment primitives to deal with cross-page
writes. A first step needed to move LTTng to TRACE_EVENT is to introduce the
following macros:

for ftrace and perf:

#define __assign(dest, src)                  (dest) = (src)
#define __assign_memcpy(dest, src, len)      memcpy(dest, src, len)

which would turn (e.g.)

        TP_fast_assign(
                memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
                __entry->pid    = t->pid;
        ),

into

        TP_fast_assign(
                __assign_memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
                __assign(__entry->pid, t->pid);
        ),

So LTTng (and other tracers) can override these with their own primitives. This
is a basic step required to bring the LTTng tree closer to mainline.

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
