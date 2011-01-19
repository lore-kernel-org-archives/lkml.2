Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1ASQuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:50:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:57605 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1ASQuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:50:14 -0500
Date: Wed, 19 Jan 2011 17:50:11 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
Message-ID: <20110119165011.GA16682@quack.suse.cz>
References: <x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
 <AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
 <x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
 <20110118190114.GA5070@quack.suse.cz>
 <AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
 <20110118235236.GA14087@quack.suse.cz>
 <AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
 <20110119132123.GC4246@quack.suse.cz>
 <AANLkTi=Z0eyXBkWL6YYdUVzA16hs=WjC7u=wfEHzAozC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Z0eyXBkWL6YYdUVzA16hs=WjC7u=wfEHzAozC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-01-11 03:03:23, Nick Piggin wrote:
> On Thu, Jan 20, 2011 at 12:21 AM, Jan Kara <jack@suse.cz> wrote:
> >  Well, we are not required to cancel all the outstanding AIO because of the
> > API requirement, that's granted. But we must do it because of the way how
> > the code is written. Outstanding IO requests reference ioctx but they are
> > not counted in ctx->users but in ctx->reqs_active. So the code relies on
> > the fact that the reference held by the hash table protects ctx from being
> > freed and io_destroy() waits for requests before dropping the last
> > reference to ctx. But there's the second race I describe making it possible
> > for new IO to be created after io_destroy() has waited for all IO to
> > finish...
> 
> Yes there is that race too I agree. I just didn't follow through the code far
> enough to see it was a problem -- I thought it was by design.
> 
> I'd like to solve it without synchronize_rcu() though.
  Ah, OK. I don't find io_destroy() performance critical but I can
understand that you need not like synchronize_rcu() there. ;) Then it
should be possible to make IO requests count in ctx->users which would
solve the race as well. We'd just have to be prepared that request
completion might put the last reference to ioctx and free it but that
shouldn't be an issue. Do you like that solution better?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
