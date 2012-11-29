Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2K2Tb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:31:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51663 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2K2Tb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:31:58 -0500
Date: Thu, 29 Nov 2012 11:31:54 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 14/25] aio: Make aio_read_evt() more efficient
Message-ID: <20121129193154.GI15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-15-git-send-email-koverstreet@google.com>
 <20121129003816.GJ18574@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129003816.GJ18574@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 04:38:16PM -0800, Zach Brown wrote:
> > We can't use cmpxchg() on the ring buffer's head pointer directly, since
> > it's modded to nr_events and would be susceptible to ABA. So instead we
> > maintain a shadow head that uses the full 32 bits, and cmpxchg() that
> > and then updated the real head pointer.
> 
> Time to update this comment to reflect the mutex instead of the shadow
> head? :)

Yeah :P

> > +		ev = kmap(page);
> > +		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
> > +		kunmap(page);
> 
> For lack of a better time: do we want to bring up the missing
> flush_dcache_page() calls around the kernel mappings of ring pages that
> are also mapped to user addresses?

Well, it's mainly aio_complete() that needs to be doing
flush_dcache_page()... technically io_getevents should be too, but only
because it's updating the head pointer. Should probably do it now and
not forget about it again, but I think it should be its own patch.

> >  		prepare_to_wait_exclusive(&ctx->wait, &wait,
> >  					  TASK_INTERRUPTIBLE);
> >  
> > +		ret = aio_read_events(ctx, event + i, nr - i);
> > +		if (ret < 0)
> >  			break;
> 
> As mentioned offlist: we don't want to be blocking under
> TASK_INTERRUPTIBLE.  Is the plan to do a non-blocking check and pop
> outside the wait loop to do a blocking copy?

Argh. This thing is getting irritating. Gonna mull this over on irc
more.
