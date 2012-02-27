Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2B0LFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:05:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:58651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2B0LFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:05:06 -0500
Message-ID: <1330340694.11248.64.camel@twins>
Subject: Re: [PATCH] hw breakpoint: Fix possible memory leak
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 27 Feb 2012 12:04:54 +0100
In-Reply-To: <20120227104452.GA6082@elte.hu>
References: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
	 <1330338785.11248.49.camel@twins> <20120227104452.GA6082@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 11:44 +0100, Ingo Molnar wrote:
> I edited that code earlier today - is the form below OK, or can 
> you see a simpler method? It's not yet pushed out so can still 
> edit it. 

I think something like the below should do, but then I didn't really
think much about it, my thoughts went like:

... *shees* that's ugly
  ... that error path already does a loop
    ... what the problem is!? -- reread changelog
      ... err_cpu == cpu is placed wrong!


So I replied and marked read.. waiting to either hear if there's a good
reason to do ugly or find a new (tested) patch in my inbox.. :-)

---
 kernel/events/hw_breakpoint.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b0309f7..3330022 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -658,10 +658,10 @@ int __init init_hw_breakpoint(void)
 
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
-		if (err_cpu == cpu)
-			break;
 		for (i = 0; i < TYPE_MAX; i++)
 			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
+		if (err_cpu == cpu)
+			break;
 	}
 
 	return -ENOMEM;

