Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2K2S50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:57:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36448 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2K2S5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:57:24 -0500
Date: Thu, 29 Nov 2012 10:57:20 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129185720.GE15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-23-git-send-email-koverstreet@google.com>
 <m28v9kgsen.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m28v9kgsen.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:45:04AM -0800, Andi Kleen wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> 
> > This implements a refcount with similar semantics to
> > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > but dynamically switches to per cpu refcounting when the rate of
> > gets/puts becomes too high.
> 
> This will only work if you put on the same CPU as you get, right?

Nope, no such restriction.

> In this case I would rather use RCU. It's clearly unusable for anything 
> blocking (or not get_cpu) Normally RCU already handles the "ref count for short non
> blocking case"

The kioctx refcount isn't held for short nonblocking duration,
io_getevents() holds it and may block for arbitrarily long. Maybe SRCU
could be made to work for it (I havent' really looked at the RCU
variants) but it doesn't seem like a good idea.

This thing really is just a refcount, the percpu part isn't exposed to
the user at all.
