Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0E0HWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 03:22:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:42051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0E0HWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 03:22:44 -0400
Date: Thu, 27 May 2010 17:22:40 +1000
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100527072240.GM22536@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
 <20100527065041.GA31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527065041.GA31073@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:50:41AM +0100, Al Viro wrote:
> On Tue, May 25, 2010 at 04:49:12PM +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > 
> > The 'sync_supers' thread wakes up every 5 seconds (by default) and
> > writes back all super blocks. It keeps waking up even if there
> > are no dirty super-blocks. For many file-systems the superblock
> > becomes dirty very rarely, if ever, so 'sync_supers' does not do
> > anything most of the time.
> > 
> > This patch improves 'sync_supers' and makes sleep if all superblocks
> > are clean and there is nothing to do. This helps saving the power.
> > This optimization is important for small battery-powered devices.
> 
> > +void mark_sb_dirty(struct super_block *sb)
> > +{
> > +	sb->s_dirty = 1;
> > +
> > +	spin_lock(&supers_timer_lock);
> > +	if (!supers_timer_armed) {
> > +		bdi_arm_supers_timer();
> > +		supers_timer_armed = 1;
> > +	} else if (supers_timer_armed == -1)
> > +		supers_timer_armed = 1;
> > +	spin_unlock(&supers_timer_lock);
> > +}
> > +EXPORT_SYMBOL(mark_sb_dirty);
> 
> Ouch...   That turns a previously trivial operation into something
> much heavier; moreover, I'd rather see serious review of s_dirt
> uses.

Yeah, we definitely don't want to add global cacheline writes in the
common case. Also I don't know why you do the strange -1 value. I
couldn't seem to find where you defined bdi_arm_supers_timer();

But why doesn't this work?

  sb->s_dirty = 1;
  smp_mb(); /* corresponding MB is in test_and_clear_bit */
  if (unlikely(!supers_timer_armed)) {
    if (!test_and_set_bit(0, &supers_timer_armed))
        bdi_arm_supers_timer();
  }
    
  vs

  supers_timer_armed = 0;
again:
  sync_supers();
  if (test_and_clear_bit(0, &supers_timer_armed))
    goto again;
  
