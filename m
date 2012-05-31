Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2EaWgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 18:36:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758456Ab2EaWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 18:36:07 -0400
Date: Fri, 1 Jun 2012 00:35:59 +0200
From: Jan Kara <jack@suse.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>
Subject: Re: [PATCH 2/4] [RFC] Range tree implementation
Message-ID: <20120531223559.GB19050@quack.suse.cz>
References: <1337973456-19533-1-git-send-email-john.stultz@linaro.org>
 <1337973456-19533-3-git-send-email-john.stultz@linaro.org>
 <20120531204806.GB16338@quack.suse.cz>
 <4FC7DCD7.6020800@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC7DCD7.6020800@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31-05-12 14:04:23, John Stultz wrote:
> On 05/31/2012 01:48 PM, Jan Kara wrote:
> >On Fri 25-05-12 12:17:34, John Stultz wrote:
> >>I suspect range-tree isn't a totally accurate name, but I
> >>couldn't quite make out the difference between range trees
> >>and interval trees, so I just picked one to call it. Do
> >>let me know if you have a better name.
> >   Well, interval tree is a data structure for tracking a set of
> >possibly overlapping intervals. Range tree is a data structure tracking
> >points allowing for fast queries on a set of points contained in a given
> >range (gets useful and interesting when dimension>  1). Your data structure
> >is neither so it would be good to have a different name. OTOH there are so
> >many data structures that it's hard to find a reasonable unused name ;)
> 
> Although I'm not sure your interval tree description doesn't match
> what I'm trying to provide. Could you clarify why that doesn't
> match?
  Wikipedia has a good description of Interval trees:
  http://en.wikipedia.org/wiki/Interval_tree

  For example they are tertiary trees.

> >>+ * @root: range_tree root
> >>+ * @start: range start
> >>+ * @end: range end
> >>+ *
> >>+ */
> >>+struct range_tree_node *range_tree_next_in_range(struct range_tree_node *node,
> >>+							u64 start, u64 end)
> >>+{
> >>+	struct rb_node *next;
> >>+	struct range_tree_node *candidate;
> >>+	if (!node)
> >>+		return NULL;
> >>+	next = rb_next(&node->rb);
> >>+	if (!next)
> >>+		return NULL;
> >>+
> >>+	candidate = container_of(next, struct range_tree_node, rb);
> >>+
> >>+	if ((candidate->start>  end) || (candidate->end<  start))
> >>+		return NULL;
> >>+
> >>+	return candidate;
> >>+}
> >>+
> >>+/**
> >>+ * range_tree_add - Add a node to a range tree
> >>+ * @root: range tree to be added to
> >>+ * @node: range_tree_node to be added
> >>+ *
> >>+ * Adds a node to the range tree.
> >   I think you should document here that the added range must not intersect
> >with any other range in the tree.
> 
> So for my usage in the volatile range code, I don't want
> intersecting or overlapping ranges added, but I didn't feel it was
> necessary to add this restriction to my rangetree code as well,
> since someone might want to store overlapping ranges.
  Ok, but then you should define where an interval that is intersecting
other intervals ends up sorted...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
