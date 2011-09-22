Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1IVXOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:14:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1IVXOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:14:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=B05ApBM7e8VSE+A4/IWkCxyteiBMcIJDvcNwWPFjJR06A3d86k2DTreXLE/ubAba+
	pR/2XTMKMrkf2YgF7iG1w==
Date: Thu, 22 Sep 2011 16:13:25 -0700
From: Andrew Morton <akpm@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/8] idle page tracking / working set estimation
Message-Id: <20110922161325.f94f9c9e.akpm@google.com>
In-Reply-To: <1316230753-8693-1-git-send-email-walken@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 20:39:05 -0700
Michel Lespinasse <walken@google.com> wrote:

> Please comment on the following patches (which are against the v3.0 kernel).
> We are using these to collect memory utilization statistics for each cgroup
> accross many machines, and optimize job placement accordingly.

Please consider updating /proc/kpageflags with the three new page
flags.  If "yes": update.  If "no": explain/justify.

Which prompts the obvious: the whole feature could have been mostly
implemented in userspace, using kpageflags.  Some additional kernel
support would presumably be needed, but I'm not sure how much.

If you haven't already done so, please sketch down what that
infrastructure would look like and have a think about which approach is
preferable?



What bugs me a bit about the proposal is its cgroups-centricity.  The
question "how much memory is my application really using" comes up
again and again.  It predates cgroups.  One way to answer that question
is to force a massive amount of swapout on the entire machine, then let
the system recover and take a look at your app's RSS two minutes later.
This is very lame.

It's a legitimate requirement, and the kstaled infrastructure puts a
lot of things in place to answer it well.  But as far as I can tell it
doesn't quite get over the line.  Then again, maybe it _does_ get
there: put the application into a memcg all of its own, just for
instrumentation purposes and then use kstaled to monitor it?

<later> OK, I'm surprised to discover that kstaled is doing a physical
scan and not a virtual one.  I assume it works, but I don't know why. 
But it makes the above requirement harder, methinks.



How does all this code get along with hugepages, btw?
