Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab2LVLJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 06:09:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57330 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2LVLJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 06:09:34 -0500
Date: Sat, 22 Dec 2012 12:09:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121222110929.GA3567@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121222022210.GA30177@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 06:22:10PM -0800, Tejun Heo wrote:
> Hello, Andrew.
> 
> On Fri, Dec 21, 2012 at 06:15:23PM -0800, Andrew Morton wrote:
> > On Fri, 21 Dec 2012 17:57:15 -0800 Tejun Heo <tj@kernel.org> wrote:
> > 
> > > There's no need to test whether a (delayed) work item in pending
> > > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > > and quite a few of them are buggy.
> > 
> > > -		if (!work_pending(&ipc_memory_wq))
> > > -			schedule_work(&ipc_memory_wq);
> > > +		schedule_work(&ipc_memory_wq);
> > 
> > Well, the new code is a ton slower than the old code if the work is
> > frequently pending, so some care is needed with such a conversion.
> 
> Yeah, I mentioned it in the head message.  it comes down to
> test_and_set_bit() vs. test_bit() and none of the current users seems
> to be hot enough for that to matter at all.
> 
> In very hot paths, such optimization *could* be valid.  The problem is
> that [delayed_]work_pending() seem to be abused much more than they
> are put to any actual usefulness.  Maybe we should rename them to
> something really ugly.  I don't know.

Hmm, we're also disabling local interrupts for no reason, if there's no
work pending (this is queue_work_on()):

    2d1a:       9c                      pushfq
    2d1b:       41 5c                   pop    %r12
    2d1d:       fa                      cli
    2d1e:       e8 00 00 00 00          callq  2d23 <queue_work_on+0x33>
    2d23:       f0 0f ba 2b 00          lock btsl $0x0,(%rbx)

so there's IRQ disable + locked operation in schedule_work vs a simple
test_bit which doesn't even require the LOCK prefix.

Now you say those paths are not fast paths, but the reverse of
this optimization is also true: what happens if people start using
schedule_work() in fast paths without checking whether work is pending?
A useless IRQ disable + locked operation + IRQ enable.

I don't know but this could hurt in some situations, I'm thinking of RT
folk especially here.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
