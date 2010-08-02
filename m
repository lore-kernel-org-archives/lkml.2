Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0HBSfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:35:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58272 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0HBSfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rwSu5bN2NypNbk2JGCN7nCBZdlpq/C2XtG2iZMQm+3zeKja0brQNb84rJre2i2WzU6
         elYZMunhw+aAA5vwGqUad816aZf3NfdeARxrkhqXGjqvqCpGmhQeOX70UlgJPebiI1Er
         l6BrixfTu9uCeW7n9Wu7mPEqGT5n5oz5qfhyI=
Date: Mon, 2 Aug 2010 20:35:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Markus Metzger <markus.t.metzger@intel.com>,
        Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] BTS based perf user callchains
Message-ID: <20100802183506.GA8962@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As you may know there is an issue with user stacktraces: it requires
userspace apps to be built with frame pointers.

So there is something we can try: dump a piece of the top user stack page
each time we have an event hit and let the tools deal with that later using
the dwarf informations.

But before trying that, which might require heavy copies, I would like to
try something based on BTS. The idea is to look at the branch buffer and
only pick addresses of branches that originated from "call" instructions.

So we want BTS activated, only in user ring, without the need of interrupts
once we reach the limit of the buffer, we can just run in a kind of live
mode and read on need. This could be a secondary perf event that has no mmap
buffer. Something only used by the kernel internally by others true perf events
in a given context. Primary perf events can then read on this BTS buffer when
they want.

Now there are two ways:

- record the whole branch buffer each time we overflow on another perf event
and let post processing userspace deal with "call" instruction filtering to
build the stacktrace on top of the branch trace.

- do the "call" filtering on record time. That requires to inspect each
recorded branches and look at the instruction content from the fast path.

I don't know which solution could be the faster one.


I'm not even sure that will work. Also, while looking at the BTS implementation
in perf, I see we have one BTS buffer per cpu. But that doesn't look right as
the code flow is not linear per cpu but per task. Hence I suspect we need
one BTS buffer per task. But may be someone tried that and encountered a
problem?


Tell me your feelings.

Thanks.

