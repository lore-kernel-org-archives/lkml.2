Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1LEVLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:11:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab1LEVLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:11:47 -0500
Message-ID: <1323119457.32012.36.camel@twins>
Subject: Re: [PATCH 09/12] perf_events: add hook to flush branch_stack on
 context switch (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Mon, 05 Dec 2011 22:10:57 +0100
In-Reply-To: <1318595833-29984-10-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-10-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> + * When sampling the branck stack in system-wide, it may be necessary
> + * to flush the stack on context switch. This happens when the branch
> + * stack does not tag its entries with the pid of the current task.
> + * Otherwise it becomes impossible to associate a branch entry with a
> + * task. This ambiguity is more likely to appear when the branch stack
> + * supports priv level filtering and the user sets it to monitor only
> + * at the user level (which could be a useful measurement in system-wide
> + * mode). In that case, the risk is high of having a branch stack with
> + * branch from multiple tasks. Flushing may mean dropping the existing
> + * entries or stashing them somewhere in the PMU specific code layer. 

It doesn't need to tag stuff with PID to solve that problem, making the
TOS a full 64bit wide counter will work equally well, we'd simply record
the TOS value at context switch time and discard everything prior to the
last switch-in.

But yeah, we need to flush this stuff under the current scheme.
