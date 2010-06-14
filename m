Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0FNHnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:43:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41743 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0FNHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:43:14 -0400
Date: Mon, 14 Jun 2010 09:43:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100614074309.GA17092@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111052.3DDC5B1A2B@basil.firstfloor.org> <20100614042700.GC6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614042700.GC6590@dastard>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 02:27:00PM +1000, Dave Chinner wrote:
> > Unused statements were mostly related to stub macros for disabled
> > features like QUOTA or RT ALLOC. I replace those with
> > inlines.
> 
> Did you compile with/without XFS_DEBUG (I don't think so)? when

No.

I merely made my own config work with relatively little warnings.

> changing code that affects ASSERT statements, CONFIG_XFS_DEBUG needs to
> be selected to test that this code compiles. Most XFs developers
> build with XFS_CONFIG_DEBUG for everything other than performance
> testing, so ensuring this builds is definitely required. ;)

Ok fair enough.

> 
> I'd also be interested if any fixes are needed with all options
> enabled. Seems silly just to fix a few warnings in just one
> particular configuration rather than all of them...

There are tons more warnings with allyesconfig I'm sure,
not only in xfs.  They will need time to work out.

This will happen over time as people eventually move
to gcc 4.6 (after it's released)

Some of the warnings are also related
to not enabling everything (e.g. no quota)

> 
> > There were also some problems with variables used in ASSERT()
> > I partly moved those into the ASSERT itself and partly
> > used a new QASSERT that always evaluates.
> 
> That's a pretty ugly hack for a single occurrence of a warning.
> Re-arrnaging the code is a much better idea than introducing a new
> ASSERT type. e.g:

I originally planned to use it for more, but then ended up
changing other code in other ways.

I still don't think it's a ugly hack, it's a relatively
simple way to handle this. But I can change this single occurrence.

> FWIW, we've now got a situation where external static code checkers
> will tell us that we are not handling an error case (which is where
> this code and comment came from), and now the compiler will warn us
> we are assigning but not using the return value. It's a bit of a
> Catch-22 situation. Hence my question is this - how are we supposed
> to "safely" ignore a return value seeing as the compiler is now
> making the current method rather noisy?

Fix the problem?  

Otherwise you can use a (void) cast, but that's a bad way
if there's a real problem.

> >  	dp->i_d.di_size = 0;
> >  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
> >  	/*
> 
> Just remove the buf_len variable in this case.

I think the code looks cleaner when using buf_len

> These are all "unused" because they are used in debug code only. i.e.
> in XFS_FILESTREAMS_TRACE configs. This is manual debug code that
> needs to be converted to the trace infrastructure - the compiler may

I have no plans to do that.

> say it is unused, but it is not dead code, so shoul dnot be removed.

I did not remove anything.

> >  			(uint)(msbp - msb), rsvd);
> >  		ASSERT(error == 0);
> > +		/* FIXME: need real error handling here, error can be ENOSPC */
> 
> That comment is wrong and hence is not needed.  By design, we should
> never, ever get an error here because we've already reserved all the
> space we need and this is just an accounting call.  That's what the
> ASSERT(error == 0) is documenting. It's ben placed there to catch

Ok. But I must say ASSERT() is not really a good way to 
document things like that. Whoever wrote this gets
what he deserves now ...

> function head comment during development.  Anyway, if we do get an
> error here, we cannot handle it anyway - it's too late to do
> anything short of a complete shutdown as we've already written the
> transaction to the log.

Well I guess it should be unconditional BUG_ON then.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
