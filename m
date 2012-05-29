Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2E2DZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 23:25:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64076 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2E2DZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 23:25:06 -0400
Date: Mon, 28 May 2012 23:25:02 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com
Subject: Re: [PATCH 3/3] block: convert elevator to generic rb tree code
Message-ID: <20120529032502.GA10175@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <1337979461-19654-4-git-send-email-koverstreet@google.com>
 <20120528231717.GB20954@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528231717.GB20954@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 08:17:17AM +0900, Tejun Heo wrote:
> On Fri, May 25, 2012 at 01:57:41PM -0700, Kent Overstreet wrote:
> > Change-Id: I676968e201f0de9a0d0a7813e2fcc6873343e8c3
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> You know what I was gonna complain about here, right?  :)

Yep :P

> >  struct request *elv_rb_find(struct rb_root *root, sector_t sector)
> >  {
> > -	struct rb_node *n = root->rb_node;
> > -	struct request *rq;
> > -
> > -	while (n) {
> > -		rq = rb_entry(n, struct request, rb_node);
> > +	struct request search = { .__sector = sector };
> 
> This is dangerous.  You can't put things like struct request on stack.
> It might look like it's working ok on the tested setup but archs
> differ in stack pressure and more importantly people may add
> arbitrarily sized fields, including debugging stuff, to struct
> request.  So, no, please don't do that.

I was telling you about this exact issue before - and I looked at the
assembly to make sure that when the inlined version of rb_search() was
used the struct request on the stack was optimized away, and it was.

So in practice there's no extra stack usage. Whether this is an
optimization we want to depend I'm not going to say; I suspect it's
pretty safe w.r.t. the optimizer but it's definitely sketchy and if at
some point someone came along and switched it to the uninline version
we'd have problems.

So we might want to leave this one open coded. Which would make me sad,
but I can't think of a sane way of implementing generic rb_search() that
doesn't require passing it a type t to compare against.

I dunno.
