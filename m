Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1LOFYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:24:48 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:54613 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215Ab1LOFYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:24:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKmD6U55LOCn/2dsb2JhbABEqyaBBoFyAQEEAScTHCMQCAMYLhQlAyETh3q3VROLdASUdJI/
Date: Thu, 15 Dec 2011 16:24:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] writeback: Unduplicate writeback reason
Message-ID: <20111215052422.GO3179@dastard>
References: <20111214003150.GA14520@localhost>
 <1323825240.23971.11.camel@gandalf.stny.rr.com>
 <20111214032844.GL3179@dastard>
 <20111214131619.GA17225@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214131619.GA17225@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 09:16:19PM +0800, Wu Fengguang wrote:
> On Wed, Dec 14, 2011 at 11:28:44AM +0800, Dave Chinner wrote:
> > On Tue, Dec 13, 2011 at 08:14:00PM -0500, Steven Rostedt wrote:
> > > Names of the writeback reasons are used in both the main kernel as well
> > > as for parsing the tracepoint format file. Instead of duplicating the
> > > names in two locations making it likely that they may become out of
> > > sync, use some macro magic to make sure all the names stay in sync. Any
> > > update only needs to happen in one spot for it to take place in all
> > > locations.
> > > 
> > > Note, this is an RFC patch, and it probably needs much better comments
> > > (well, it currently has no comments), and the C() macro probably should
> > > have a different name too.
> > 
> > I'm not sure this is a pattern we want to repeat all over the place -
> > print_symbolic() is quite widely used and adding macro redefinitions
> > all over the place doesn't fill me with joy.
> 
> Yeah, unfortunately...
> 
> > AFAICT this code doesn't need a declared array to work so you can
> 
> You mean the string array wb_reason_name[]? Ah it's actually not used
> for now -- until there comes the (planned) writeback stats patch to
> show the reason names in some debugfs/sysfs interface.

Ah, ok. I missed that context.

.....

> > followed by:
> > 
> > #define VALUES	\
> > 	{ value_1,	"Value 1" }, \
> > 	{ value_2,	"Value 2" }, \
> > 	.....
> > 
> > And it just uses print_symbolic(__entry->value, VALUES); to print
> > them out.
> 
> If using the above macros, wb_reason_name[] can be defined as
> 
>         static const struct trace_print_flags wb_reason_name[] = { VALUES };
> 
> and reference it in this way
> 
>         wb_reason_name[reason][1]
> 
> The first element is redundant info and will be ignored, because
> 
>         wb_reason_name[reason][0] == reason

Yeah, that would work, and still place the definitions close
together....

> 
> > If this construct does everything requiredi, then I think it is a
> > much better pattern to use because it's easy to maintain, doesn't
> > require an array to be declared in a C file and doesn't require
> > macro tricks to do it's job....
> 
> Hmm, I looked through XFS tracing code and find no use case like the
> wb_reason_name[]. That is, the XFS symbolic names are only used for
> tracing output and there is no sharing with debugfs/sysfs outputs.

Right. I didn't realise the writeback stuff was eventually going to
be shared with sysfs. Still, it looks like it works better than
playing macro redefinition games with you addition above, so perhaps
it was best I didn't realise this in the first place. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
