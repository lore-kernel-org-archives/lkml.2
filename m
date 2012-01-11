Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2AKRDC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:03:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39608 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2AKRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:02:57 -0500
Date: Wed, 11 Jan 2012 09:02:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        namhyung@gmail.com
Subject: Re: [RFC PATCHSET take#2] ioblame: IO tracer with origin tracking
Message-ID: <20120111170252.GD26832@google.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <20120111144012.GB7991@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111144012.GB7991@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Wed, Jan 11, 2012 at 03:40:14PM +0100, Frederic Weisbecker wrote:
> I think this has been asked before. So sorry for asking twice.

I thought Namhyung was primarily asking about stat gathering which is
chopped now.

> But I'm wondering why the post processing is made from the kernel. Do you think
> it would be possible to pull that out in userspace. We have some nice scripting
> framework for post processing of trace events in perf tools for example.
>
> If it's not possible please tell us why. We really would like to avoid adding such
> a big piece of code in the tracing subsystem if possible.

I suppose you're talking about the state tracking by post-processing,
right?

* ioblame tracks stack trace for each dirtying operation.  If we don't
  want further state tracking in kernel, we would have to exort the
  whole stack trace on each dirtying operation which can be high
  frequency.  Also, is there an efficient way to export variable
  length data via TPs?  If so, it can be somewhat better but still not
  very good.
  
* Even if we track dirtying state in userland, when an io is issued,
  it needs to be mapped back to the dirtying actions.  If the dirtier
  state is in userland, we have to export all physaddrs of pages in
  the IO so that userland can match them up and clear dirtied states.
  Again, the same problem.

* As implemented, most of state tracking should be fairly stable and
  shouldn't require much modification as code base evolves but it's
  still trying to extract pretty high level semantics from disjoint
  events across multiple layers.  It's reasonable to expect future
  changes would require updates to how those semantics are
  established.  Exporting higher level semantics, we don't get tied to
  keeping the relevant raw tracepoints and, more importantly, their
  exact interactions stable.

* It isn't trivial but still pretty straight-forward.  Most of what it
  does is abbreviating strack trace to an identifier (which BTW could
  be useful for other tracing purposes and may be worthwhile to
  generalize) and tracking page and inode dirtiers using those
  identifiers.  It stays mostly out of the way and doesn't noticeably
  harm maintainability.  It fits the role of in-kernel tracers -
  building information from domain knowledge and states and exporting
  to userland in sensible form.

Thanks.

-- 
tejun
