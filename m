Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1CVULH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:11:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48033 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1CVULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:11:04 -0400
Date: Tue, 22 Mar 2011 20:11:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
Message-ID: <20110322201101.GZ22723@ZenIV.linux.org.uk>
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
 <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
 <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu>
 <20110322190002.GW22723@ZenIV.linux.org.uk>
 <E1Q27U5-0001eO-AL@pomaz-ex.szeredi.hu>
 <20110322195331.GY22723@ZenIV.linux.org.uk>
 <E1Q27qg-0001kq-IO@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Q27qg-0001kq-IO@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 09:06:38PM +0100, Miklos Szeredi wrote:
> On Tue, 22 Mar 2011, Al Viro wrote:
> > Proceeding with rename is not interesting; proceeding with copyup is.
> > 
> > Who said that by the time we get to copy_up_locked you will still have
> > dentry (and upper) match lowerpath?  Or that ->d_parent on overlay and
> > on upper will change in sync, for that matter - there are two d_move()
> > calls involved...
> 
> If rename is involved, than rename itself already did the copy up.
> And that's checked before proceeding with the actual copy up.  If
> there was no rename, then that guarantees that things are in sync, at
> least for the duration of the copy up.

What do you mean, before?  It's not atomic...  What happens if e.g.
you get

A: decided to do copy_up_locked
   blocked on i_mutex

B: did copy_up
   did rename(), complete with d_move()
   did unlink() in new place

A: got CPU back, got i_mutex
   proceeded to copy lower into new location
   set dentry to very odd (upper,lower) pair
