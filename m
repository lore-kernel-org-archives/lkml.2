Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3ACWsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:48:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3ACWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:48:41 -0500
Date: Thu, 3 Jan 2013 14:48:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-Id: <20130103144839.7a514924.akpm@linux-foundation.org>
In-Reply-To: <1356573611-18590-26-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-26-git-send-email-koverstreet@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012 18:00:02 -0800
Kent Overstreet <koverstreet@google.com> wrote:

> This implements a refcount with similar semantics to
> atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> but dynamically switches to per cpu refcounting when the rate of
> gets/puts becomes too high.
> 
> It also implements two stage shutdown, as we need it to tear down the
> percpu counts. Before dropping the initial refcount, you must call
> percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> switches back to a single atomic refcount with the appropriate barriers
> (synchronize_rcu()).
> 
> It's also legal to call percpu_ref_kill() multiple times - it only
> returns true once, so callers don't have to reimplement shutdown
> synchronization.
> 
> For the sake of simplicity/efficiency, the heuristic is pretty simple -
> it just switches to percpu refcounting if there are more than x gets
> in one second (completely arbitrarily, 4096).
> 
> It'd be more correct to count the number of cache misses or something
> else more profile driven, but doing so would require accessing the
> shared ref twice per get - by just counting the number of gets(), we can
> stick that counter in the high bits of the refcount and increment both
> with a single atomic64_add(). But I expect this'll be good enough in
> practice.

I still don't "get" why this code exists.  It is spectacularly,
stunningly undocumented and if someone were to ask me "under what
circumstances should I use percpu-refcount", I would not be able to
help them.

