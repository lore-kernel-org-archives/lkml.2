Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2AIBt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:49:57 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60476 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab2AIBtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:49:55 -0500
Date: Sun, 8 Jan 2012 17:49:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] block: block_bio_complete tracepoint was missing
Message-ID: <20120109014949.GA16360@mtj.dyndns.org>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
 <1325806974-23486-4-git-send-email-tj@kernel.org>
 <4F0A431E.3090106@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0A431E.3090106@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 09, 2012 at 10:30:06AM +0900, Namhyung Kim wrote:
> Just adding the TP unconditionally will produce duplicated (in some
> sense) reports about the completion. For example, normal request
> based IO reports whole request completion prior to its bio's, and
> further

Request and bio completions are separate events.  There's nothing
wrong with reporting them separately.  In fact, I think they should be
reported separately.

>, some of nested block IO handling routines - bounced bio and
> btrfs with compression, etc - call bio_endio() more than once. Also
> there are cases that bio fails before it's enqueued for some reason.

They are actually separate bio's being completed.  I don't think
trying to put extra semantics on TP itself is a good idea.  In
general, TP signals that such event happened with sufficient
information and it's the consumers' responsibility to make sense of
what's going on.  BIO_CLONED/BOUNCED are there.

> I have no idea about the ioblame can deal with all of such corner
> cases. However it might confuse blktrace somewhat, I guess.

Unless someone is doing memcpy() on bio's, ioblame should be okay.  It
only considers bio's which went through actual submission.

> I already posted similar patch a couple of weeks ago, but didn't
> receive a comment yet. [1] Please take a look this too :)

I'll reply there but don't think imposing such extra logic on TP is a
good idea.

> After a quick glance, the ioblame seems to carry all IO accounting
> info through the first bio in the request. If so, why don't you use
> the request structure for that?

Because there are bio based drivers which don't use requests at all.

Thanks.

--
tejun
