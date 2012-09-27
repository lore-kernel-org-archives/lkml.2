Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2I0Rot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:44:49 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42578 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2I0Ror (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:44:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120927071011.GA8980@gmail.com>
References: <20120925170058.GC30158@x1.osrc.amd.com> <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com> <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic> <1348722568.7059.115.camel@marge.simpson.net>
 <20120927054742.GA4370@gmail.com> <1348727665.7059.160.camel@marge.simpson.net>
 <20120927064142.GB5996@gmail.com> <1348728852.7059.171.camel@marge.simpson.net>
 <20120927071011.GA8980@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Sep 2012 10:44:26 -0700
X-Google-Sender-Auth: fPOKatNtd1vPlneohFWC3X5LpiE
Message-ID: <CA+55aFyxjdir-LZneBTk1JQV0cVSRFzEK9Jpxje2SJqA6aP3Yg@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 12:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Just in case someone prefers patches to user-space approaches (I
> certainly do!), here's one that turns off wakeup driven
> preemption by default.

Ok, so apparently this fixes performance in a big way, and might allow
us to simplify select_idle_sibling(), which is clearly way too random.

That is, if we could make it automatic, some way. Not the "let the
user tune it" - that's just fundamentally broken.

What is the common pattern for the wakeups for psql?

Can we detect this somehow? Are they sync? It looks wrong to preempt
for sync wakeups, for example, but we seem to do that.

Or could we just improve the heuristics. What happens if the
scheduling granularity is increased, for example? It's set to 1ms
right now, with a logarithmic scaling by number of cpus.

        Linus
