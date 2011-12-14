Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab1LNN03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:26:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:36678 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944Ab1LNN01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:26:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85613074"
Date: Wed, 14 Dec 2011 21:16:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] writeback: Unduplicate writeback reason
Message-ID: <20111214131619.GA17225@localhost>
References: <20111214003150.GA14520@localhost>
 <1323825240.23971.11.camel@gandalf.stny.rr.com>
 <20111214032844.GL3179@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214032844.GL3179@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:28:44AM +0800, Dave Chinner wrote:
> On Tue, Dec 13, 2011 at 08:14:00PM -0500, Steven Rostedt wrote:
> > Names of the writeback reasons are used in both the main kernel as well
> > as for parsing the tracepoint format file. Instead of duplicating the
> > names in two locations making it likely that they may become out of
> > sync, use some macro magic to make sure all the names stay in sync. Any
> > update only needs to happen in one spot for it to take place in all
> > locations.
> > 
> > Note, this is an RFC patch, and it probably needs much better comments
> > (well, it currently has no comments), and the C() macro probably should
> > have a different name too.
> 
> I'm not sure this is a pattern we want to repeat all over the place -
> print_symbolic() is quite widely used and adding macro redefinitions
> all over the place doesn't fill me with joy.

Yeah, unfortunately...

> AFAICT this code doesn't need a declared array to work so you can

You mean the string array wb_reason_name[]? Ah it's actually not used
for now -- until there comes the (planned) writeback stats patch to
show the reason names in some debugfs/sysfs interface.

So for the upcoming 3.2, wb_reason_name[] can be removed to avoid the
duplication. However the question still remains how exactly are we
going to re-introduce it in future?

> just use a preprocessor construct like this (as used in XFS):
> 
> #define value_1 	1
> #define value_2		2
> .....
> 
> or
> 
> enum {
> 	value_1	= 1,
> 	value_2 = 2,
> 	.....
> }
> 
> followed by:
> 
> #define VALUES	\
> 	{ value_1,	"Value 1" }, \
> 	{ value_2,	"Value 2" }, \
> 	.....
> 
> And it just uses print_symbolic(__entry->value, VALUES); to print
> them out.

If using the above macros, wb_reason_name[] can be defined as

        static const struct trace_print_flags wb_reason_name[] = { VALUES };

and reference it in this way

        wb_reason_name[reason][1]

The first element is redundant info and will be ignored, because

        wb_reason_name[reason][0] == reason

> If this construct does everything requiredi, then I think it is a
> much better pattern to use because it's easy to maintain, doesn't
> require an array to be declared in a C file and doesn't require
> macro tricks to do it's job....

Hmm, I looked through XFS tracing code and find no use case like the
wb_reason_name[]. That is, the XFS symbolic names are only used for
tracing output and there is no sharing with debugfs/sysfs outputs.
So we may be talking about different situations.

Thanks,
Fengguang
