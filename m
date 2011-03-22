Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1CVTn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:43:27 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38598 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1CVTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:43:21 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
In-reply-to: <20110322190002.GW22723@ZenIV.linux.org.uk> (message from Al Viro
	on Tue, 22 Mar 2011 19:00:02 +0000)
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
 <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
 <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu> <20110322190002.GW22723@ZenIV.linux.org.uk>
Message-Id: <E1Q27U5-0001eO-AL@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 20:43:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Al Viro wrote:
> On Tue, Mar 22, 2011 at 07:58:17PM +0100, Miklos Szeredi wrote:
> > On Tue, 22 Mar 2011, Linus Torvalds wrote:
> > > On Tue, Mar 22, 2011 at 11:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > >
> > > > Locking analysis would be really nice; AFAICS, it violates locking order
> > > > when called from e.g. ->setattr()
> > 
> > Locking order is always:
> > 
> > -> overlayfs locks
> >    -> upper fs locks
> >    -> lower fs locks
> > 
> > So it's really pretty simple and easy to validate.
> 
> In which *order* on the upper fs?

In copy up it does:

-> lock parent on upper
  -> lock child on upper

So a setattr with copy up would go like this:

-> lock child on overlayfs
  -> lock parent on upper
     ->lock child on upper
  -> lock child on upper

> > Protection is exactly as for userspace callers.  AFAICT.
> 
> Pardon?  You traverse the chain of ancestors; fine, but who says it stays
> anywhere near being relevant as you go?

Not quite sure I understand.

There are no assumptions about locks in overlayfs keeping anything
relevant in upper/lower fs.  Everything is re-checked and re-locked on
the upper layer before proceeding with the rename.

Thanks,
Miklos

