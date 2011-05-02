Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1EBTXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab1EBTW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:22:58 -0400
Date: Mon, 2 May 2011 21:22:56 +0200
From: Jan Kara <jack@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110502192256.GL4556@quack.suse.cz>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
 <20110429162817.2eb26efb.akpm@linux-foundation.org>
 <20110430112937.06024368@lxorguk.ukuu.org.uk>
 <20110430153452.GA21439@suse.de>
 <20110430164141.55d0ef0a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430164141.55d0ef0a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 30-04-11 16:41:41, Alan Cox wrote:
> > > A large vmalloc array is very antisocial on a 32bit x86 box. It looks
> > > like almost all of it would become sane if there was an array of pointers
> > > to raw devices and the devices were initially allocated on need (even if
> > > for now only recovered on rmmod)
> > 
> > In practice, we've never seen a problem with this[1].  Machines that
> > want thousands of raw devices have plenty of memory to handle this
> > situation.
> > 
> > I doubt adding the complexity of dynamically allocating the devices
> > as-needed is worth it for the very few systems that ever use this
> > driver, compounded with the fact that we keep saying that this code
> > isn't to be used by "normal" people anyway.
> 
> That's no excuse for sloppy code. Making it an array populated on demand
> is an improvement for everyone, making it vmalloc hurts every access (in
> TLB misses for one as well as vmalloc overhead).
> 
> I note two of us immediately made the same observation. Doing it
> basically right (array of pointers) is easy. Doing the full works with a
> hash for the lookups is a bit harder and that I would agree is overkill.
  Alan, I might be missing something but is there a significant advantage
in creating the array of pointers? Note that struct raw_device_data which
is what the array is from is:
struct raw_device_data {
        struct block_device *binding;
        int inuse;
};
So 16 bytes on 64-bit arch. You can make it 8 bytes by the
array-of-pointers idea but people requesting this feature want to run with
8192 or even 16384 raw devices in the system (yes, they might be insane).
That gives you 16 to 32 pages for array of pointers which seems too much
to me for kmalloc() anyway.

So if people don't like vmalloc() (which I can understand), then I see no
other option than dynamically allocating struct raw_device_data.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
