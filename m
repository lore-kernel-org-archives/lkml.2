Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2IXQap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:30:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41638 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab2IXQao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:30:44 -0400
MIME-Version: 1.0
In-Reply-To: <1348503163.11847.97.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic> <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com> <1348503163.11847.97.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2012 09:30:05 -0700
X-Google-Sender-Auth: 9P163Iv8cPMhfyOds4xVn4yl_9I
Message-ID: <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 9:12 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> So we're looking for an idle cpu around @target. We prefer a cpu of an
> idle core, since SMT-siblings share L[12] cache. The way we do this is
> by iterating the topology tree downwards starting at the LLC (L3) cache
> level. Its groups are either the SMT-siblings or singleton groups.

So if it'sally guaranteed to be SMT-siblings or singleton groups, then
the whole "for_each_cpu()" is a total disaster. That's a truly
expensive way to look up adjacent CPU's. Is there no saner way to look
up that thing? Like a simple circular list of SMT siblings (I realize
that on x86 that list is either one or two, but other SMT
implementations are groups of four or more).

So I suspect your patch largely makes things faster (avoid those
insane cpumask operations), but the for_each_cpu() one is still an
absolutely horrible way to find a couple of basically statically known
(modulo hotplug, which is disabled here anyway) CPU's. So even if the
algorithm makes sense at some higher level, it doesn't really seem to
make sense from an implementation standpoint.

Also, do we really want to spread things out that aggressively?
How/why do we know that we don't want to share L2 caches, for example?
It sounds like a bad idea from a power standpoint, and possibly
performance too.

                    Linus
