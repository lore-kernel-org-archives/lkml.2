Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2IQUvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:51:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49197 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab2IQUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:51:48 -0400
Date: Mon, 17 Sep 2012 13:51:39 -0700
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v10 1/8] block: Generalized bio pool freeing
Message-ID: <20120917205139.GB14492@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-2-git-send-email-koverstreet@google.com>
 <20120914182828.GK15728@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914182828.GK15728@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 07:28:28PM +0100, Alasdair G Kergon wrote:
> On Thu, Sep 06, 2012 at 03:34:55PM -0700, Kent Overstreet wrote:
> > With the old code, when you allocate a bio from a bio pool you have to
> > implement your own destructor that knows how to find the bio pool the
> > bio was originally allocated from.
> > 
> > This adds a new field to struct bio (bi_pool) and changes
> > bio_alloc_bioset() to use it. This makes various bio destructors
> > unnecessary, so they're then deleted.
> > 
> > v6: Explain the temporary if statement in bio_put
>  
> This patch also silently reverts 
> commit 4d7b38b7d944a79da3793b6c92d38682f3905ac9
> "dm: clear bi_end_io on remapping failure"
> 
> Why?
> 
> If it's intentional, please explain it in your patch header and
> copy Hannes to reconsider the matter.

Never noticed that was introduced in its own patch until you pointed it
out.

That isn't a very good patch - it says it's clearing bi_end_io as a
precaution, but as a precaution to what?

As far as I can tell, it was never necessary. The bio is about to be
freed - there shouldn't be any other references on it (__bio_map() is
called on freshly allocated bios, and bio_get() is never called in dm.c)
Nothing else should've been looking at bi_end_io, certainly the
destructor didn't.

Now that there's no destructor, it makes even less sense to have it -
after that bio_put() that bio isn't being touched by dm code anymore.
