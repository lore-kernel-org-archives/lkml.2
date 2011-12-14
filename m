Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1LND2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:28:50 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32680 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab1LND2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:28:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPMV6E55LOCn/2dsb2JhbABDqyGBBoFyAQEFJxMcIxAIAxguFCUDIRO+XROLYASUcZI+
Date: Wed, 14 Dec 2011 14:28:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Curt Wohlgemuth <curtw@google.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] writeback: Unduplicate writeback reason
Message-ID: <20111214032844.GL3179@dastard>
References: <20111214003150.GA14520@localhost>
 <1323825240.23971.11.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323825240.23971.11.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 08:14:00PM -0500, Steven Rostedt wrote:
> Names of the writeback reasons are used in both the main kernel as well
> as for parsing the tracepoint format file. Instead of duplicating the
> names in two locations making it likely that they may become out of
> sync, use some macro magic to make sure all the names stay in sync. Any
> update only needs to happen in one spot for it to take place in all
> locations.
> 
> Note, this is an RFC patch, and it probably needs much better comments
> (well, it currently has no comments), and the C() macro probably should
> have a different name too.

I'm not sure this is a pattern we want to repeat all over the place -
print_symbolic() is quite widely used and adding macro redefinitions
all over the place doesn't fill me with joy.

AFAICT this code doesn't need a declared array to work so you can
just use a preprocessor construct like this (as used in XFS):

#define value_1 	1
#define value_2		2
.....

or

enum {
	value_1	= 1,
	value_2 = 2,
	.....
}

followed by:

#define VALUES	\
	{ value_1,	"Value 1" }, \
	{ value_2,	"Value 2" }, \
	.....

And it just uses print_symbolic(__entry->value, VALUES); to print
them out.

If this construct does everything requiredi, then I think it is a
much better pattern to use because it's easy to maintain, doesn't
require an array to be declared in a C file and doesn't require
macro tricks to do it's job....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
