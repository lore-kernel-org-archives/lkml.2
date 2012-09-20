Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2ITXlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:41:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43751 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2ITXlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:41:37 -0400
Date: Thu, 20 Sep 2012 16:41:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 03/26] block: Refactor blk_update_request()
Message-ID: <20120920234133.GM7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-4-git-send-email-koverstreet@google.com>
 <20120920232000.GG7264@google.com>
 <20120920233632.GC5519@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920233632.GC5519@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Sep 20, 2012 at 04:36:32PM -0700, Kent Overstreet wrote:
> > Other than that, I definitely like this.  It would be nice to note
> > that the custom partial bio advancing in blk_update_request() is
> > replaced with multiple calls to req_bio_endio().  I don't think it has
> > any meaningful performance implications.  It's just nice to future
> > readers of the commit.
> 
> The number of calls to req_bio_endio() isn't changing...
> blk_update_request() called it for partial completions before. It's just
> where the bio itself is updated that's getting shuffled around.
>
> Or did you mean that bio_advance() is getting called on every bio
> instead of the custom advancing in blk_update_request() before? That is
> different, yeah - it's now always looping over the iovec, not just for
> partial completions.
> 
> Yeah, I will note that in the commit message, in case Jens sees a
> performance regression from it :)

I don't think there's any performance implication.  It's just nice to
explain how the complexity went away.  If for nothing else, to point
out how silly the original code was. :)

> > Also, it would be really nice if you can verify this actually works
> > with partial blk_update_request().  sector update bug in the previous
> > patch scares me a bit.  Implementing some debug hacks in the
> > completion path might be the easiest way to verify.  A subtle bug here
> > could be pretty painful.
> 
> Any suggestions on how to trigger partial updates?

ide along with many legacy drivers do it.  Any SCSI driver including
libata only does full completion.  I don't know.  Even just trying to
call the function and comparing before & after with the original code
would be good.  I'd like to see at least some form of verification
because the manifested bugs could be extremely nasty and difficult to
track down.

Thanks.

-- 
tejun
