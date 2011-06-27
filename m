Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1F0Jhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:37:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34550 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab1F0JfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:35:10 -0400
Subject: Re: [PATCH 3/3] events: Ensure that timers are updated without
 requiring read() call
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric B Munson <emunson@mgebm.net>
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com
In-Reply-To: <20110624124921.GB3727@mgebm.net>
References: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
	 <1308861279-15216-3-git-send-email-emunson@mgebm.net>
	 <1308908656.27849.21.camel@twins>  <20110624124921.GB3727@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 11:34:08 +0200
Message-ID: <1309167248.6701.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 08:49 -0400, Eric B Munson wrote:

> Now that I think about it, this will just mask the problem.  I have a test
> program uses the mmap'd user space page to access event counters (it never
> calls read()).  In this case, the timer values in the event will never be
> updated.  It will display "properly" but the structure won't ever be correct.
> Given that, how can we keep the event values current?

Well the idea is that you do a userspace read of the counter, on x86
that would be using rdpmc and use the provided event count as base. See
the comment in struct perf_event_mmap_page.

Currently we don't have rdpmc support for x86, but it shouldn't be hard.
We should poke at CR4 in our CPU_STARTING callback, and fix up the mess
called perf_event_index() to deal with the strange and wonderful
encoding rdpmc needs (might want an event->pmu->index callback or so).

Currently all this only works on PowerPC.
