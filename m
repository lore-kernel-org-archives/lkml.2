Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0JEODw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:03:52 -0400
Received: from kroah.org ([198.145.64.141]:52657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab0JEODv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:03:51 -0400
Date: Tue, 5 Oct 2010 06:57:50 -0700
From: Greg KH <greg@kroah.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Potential kobject functionality (two stage delete,
 single delete)
Message-ID: <20101005135750.GA4414@kroah.com>
References: <4CAB26C7.2020109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAB26C7.2020109@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 06:23:19AM -0700, Kent Overstreet wrote:
> I've been working on reference counting in my own code, and it
> seemed to me that some of this stuff would be best added to the
> generic code - I can't be the only one who's needed to solve these
> particular problems. But kobjects aren't new, maybe someone knows if
> any of this has been tried before?

Oh yeah, it's come up lots of times before, see the lkml archives :)

> The easy one would be a flag marking an object as deleted when
> there's still references. The idea is if you've got multiple
> unserialized ways of closing/deleting something - error handling
> paths and/or a way for a user to request that it be closed - you
> need to make sure you drop only one reference.

Yes, very common.

> This is trivial to handle without adding to the kobject code,

Yes, and in the end, it should be handled by the code needing it, not in
the kobject code itself.  That's why it hasn't been added.

> but it
> seems to me it ought to be common enough to warrant adding it - I
> wouldn't be surprised if there's driver code that doesn't handle it
> correctly, it's easy enough to miss if you don't think about the
> particular case. We need to add an atomic bitflag to struct kobject;
> another callback in struct kobj_type might be useful too. Then
> something like the following should be it:
> 
> void kobject_delete(struct kobject *k)
> {
> 	if (!test_and_set_bit(deleted)) {
> 		if (delete_fn)
> 			delete_fn(k);
> 		kobject_put(k);
> 	}
> }

Every time we have tried to do something like this, it ends up not being
correct, and missused, so we don't.

> The more annoying one is two stage delete. Unless my google-fu has
> failed me, I don't see a reasonable way of using kobject refcounting
> if you need to drop a refcount from atomic context.

You can't call kfree from atomic context?

Anyway, code does handle this properly, look at the scsi code for
example, we have a waitqueue-like infrastructure to do this somewhere,
perhaps it's within the driver core, I can't remember it this early in
the morning.

thanks,

greg k-h
