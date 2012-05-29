Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2E2FZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 01:25:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35730 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2E2FZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 01:25:08 -0400
Date: Tue, 29 May 2012 14:24:58 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com
Subject: Re: [PATCH 3/3] block: convert elevator to generic rb tree code
Message-ID: <20120529052458.GA17366@google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <1337979461-19654-4-git-send-email-koverstreet@google.com>
 <20120528231717.GB20954@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120529032502.GA10175@dhcp-172-18-216-138.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529032502.GA10175@dhcp-172-18-216-138.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Mon, May 28, 2012 at 11:25:02PM -0400, Kent Overstreet wrote:
> On Tue, May 29, 2012 at 08:17:17AM +0900, Tejun Heo wrote:
> > This is dangerous.  You can't put things like struct request on stack.
> > It might look like it's working ok on the tested setup but archs
> > differ in stack pressure and more importantly people may add
> > arbitrarily sized fields, including debugging stuff, to struct
> > request.  So, no, please don't do that.
> 
> I was telling you about this exact issue before - and I looked at the
> assembly to make sure that when the inlined version of rb_search() was
> used the struct request on the stack was optimized away, and it was.
> 
> So in practice there's no extra stack usage. Whether this is an
> optimization we want to depend I'm not going to say; I suspect it's
> pretty safe w.r.t. the optimizer but it's definitely sketchy and if at
> some point someone came along and switched it to the uninline version
> we'd have problems.

I don't think we can depend on that.  Note that compiler may as well
decide not to inline an inline function (e.g. if it sees many calling
instances).  Depending on such behavior is way too fragile.

> So we might want to leave this one open coded. Which would make me sad,
> but I can't think of a sane way of implementing generic rb_search() that
> doesn't require passing it a type t to compare against.

I don't know either.  Open coding isn't the end of the world but I
suspect a lot of data structures which go on rbtree wouldn't be stack
friendly, so having common helper which can't handle that might not be
too helpful.

Thanks.

--
tejun
