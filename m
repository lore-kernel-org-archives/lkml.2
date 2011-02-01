Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1BASwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:52:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1BASwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:52:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SGV60C3mfhOLJKxyPGY5cqdE1sNHZr0sz/wjKvIryIg9qhZIj6dD03TkVrb7UBhIEW
         fyxPpi+y2cM098GAxX39kx1QbR0qu2jnl7DuudINFxFr7ICgpaA/GmN34Si5U+28Chwr
         DawyA5l95Nno2umORUMHbCTPlZPDstJbcChxw=
Date: Tue, 1 Feb 2011 19:52:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
        neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com, jmoyer@redhat.com
Subject: Re: [RFC PATCH 4/3] block: skip elevator initialization for flush
 requests
Message-ID: <20110201185225.GT14211@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110125204158.GA3013@redhat.com>
 <20110126100322.GC12520@htj.dyndns.org>
 <20110201173846.GA25252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201173846.GA25252@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 12:38:46PM -0500, Mike Snitzer wrote:
> > I thought about doing it this way but I think we're burying the
> > REQ_FLUSH|REQ_FUA test logic too deep.  get_request() shouldn't
> > "magically" know not to allocate elevator data.
> 
> There is already a considerable amount of REQ_FLUSH|REQ_FUA special
> casing magic sprinkled though-out the block layer.  Why is this
> get_request() change the case that goes too far?

After the reimplementation, FLUSH implementation seems to be pretty
well isolated.  Also, having REQ_FLUSH logic in the issue and
completion paths is logical and preventing them from leaking to other
places sounds like a good idea.

> > The decision should
> > be made higher in the stack and passed down to get_request().  e.g. if
> > REQ_SORTED is set in @rw, elevator data is allocated; otherwise, not.
> 
> Considering REQ_SORTED is set in elv_insert(), well after get_request() 
> is called, I'm not seeing what you're suggesting.

I was suggesting using REQ_SORTED in @rw parameter to indicate "this
request may be sorted and thus needs elevator data allocation".

> Anyway, I agree that ideally we'd have a mechanism to explicitly
> short-circuit elevator initialization.  But doing so in a meaningful way
> would likely require a fair amount of refactoring of get_request* and
> its callers.  I'll come back to this and have another look but my gut is
> this interface churn wouldn't _really_ help -- all things considered.

I don't know.  I agree that it's not a critical issue but, to me,
subjectively of course, it feels a bit too subtle.  The sharing of
fields using unions is already subtle enough.  I with that at least
the allocation switching would be obvious and explicit.  The combined
subtleties scare me.

Thank you.

-- 
tejun
