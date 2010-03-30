Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0C3KL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:11:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3KLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:11:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=nnBfClUql1l4AU45L+QBNlZeHQCVve7FDGWUxIVHHqRQyZKbsuZiqme6aXYqWE6du
	SlwAciVhIesmLFgTn8cBw==
MIME-Version: 1.0
In-Reply-To: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
Date: Tue, 30 Mar 2010 12:11:46 +0200
Message-ID: <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 6:36 PM, Robert Richter <robert.richter@amd.com> wrote:
> This patch set unifies performance counter bit masks for x86. All mask
> are almost the same for all x86 models and thus can use the same macro
> definitions in arch/x86/include/asm/perf_event.h. It removes duplicate
> code. There is also a patch that reverts some changes of the big
> perf_counter -> perf_event rename.
>

But there are still fields which are unique to each vendor:
- GUEST vs. HOST on AMD
- ANY_THREAD on Intel.

For instance, I noticed that in

arch/x86/kernel/cpu/perf_event.c:__hw_perf_event_init():

      if (attr->type == PERF_TYPE_RAW) {
                hwc->config |= x86_pmu.raw_event(attr->config);
                if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
                    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
                        return -EACCES;
                return 0;
        }

Assumes ANY also exists on AMD processors. That is not the case.
This check needs to be moved into an Intel specific function.
