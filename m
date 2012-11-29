Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2K2T3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:29:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62074 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2K2T32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:29:28 -0500
Date: Thu, 29 Nov 2012 11:29:25 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129192925.GH15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-23-git-send-email-koverstreet@google.com>
 <m28v9kgsen.fsf@firstfloor.org>
 <20121129185720.GE15094@google.com>
 <20121129185953.GW16230@one.firstfloor.org>
 <20121129191214.GG15094@google.com>
 <20121129192003.GX16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129192003.GX16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:20:03PM +0100, Andi Kleen wrote:
> > The trick is that we don't watch for the refcount hitting 0 until we're
> > shutting down - so this only works if you keep track of your initial
> > refcount. As long as we're not shutting down, we know the refcount can't
> > hit 0 because we haven't released the initial refcount.
> 
> This seems dangerous to me: assume you have one CPU which always
> does get and another does put. So there may be 2^32 such operations
> without a kill and you wrap for real in a way that does not get
> corrected.

I don't know how to write a proof that it works (and I should... I
haven't done any real math in ages, argh) but try working out some
examples to see what happens:

cpu 0 does 2^32 gets, cpu 1 does 2^32 - 1 puts, actual ref should be 1:

cpu 0 ref: 0
cpu 1 ref: 1 (it started at 0, and subtracted 1 2^32 - 1 times)


cpu 0 does 2^32 + 1 gets, cpu 1 does 2^32 puts, again ref should be 1:

cpu 0 ref: 1
cpu 1 ref: 0

There's some kind of symmetry going on here, and if I'd been awake more
in college I could probably say exactly why it works, but it does.
