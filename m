Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1BPQrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:47:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56093 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1BPQru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:47:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kCTrzXnI0aI8flUKWPXr9PqAsB1gAXpLklQ6EBlnOPBrahRs2ln5dHbyfsvXeWiSMb
         CiIlHNm558NvqG2nLo3l09qvIfa1j0A2le5q3OZXbitwOaCgwI7RJ3dKh58fwu8RpVZ9
         clMllZIpfhhOafm0TwYGbvKhOW6tX9cgGeRK4=
Subject: Re: Linux 2.6.38-rc5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        npiggin@kernel.dk
In-Reply-To: <20110216163951.GG22723@ZenIV.linux.org.uk>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	 <1297854842.3201.197.camel@edumazet-laptop>
	 <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
	 <20110216160643.GE22723@ZenIV.linux.org.uk>
	 <20110216161929.GF22723@ZenIV.linux.org.uk>
	 <AANLkTi=8O1ZJZ2dWWwmcdV3G8LtrxSHWp=GgLxAYQE3A@mail.gmail.com>
	 <20110216163951.GG22723@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 17:47:44 +0100
Message-ID: <1297874864.30541.40.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 février 2011 à 16:39 +0000, Al Viro a écrit :
> On Wed, Feb 16, 2011 at 08:33:32AM -0800, Linus Torvalds wrote:
> > Does it make tons of conceptual sense to pass in 'inode' to
> > do_follow_link? No, it's clearly redundant information, which is the
> > whole point of the BUG_ON(). But it does allow that extra shared
> > sanity test, and we _could_ also then do
> > 
> >   -       if (!IS_ERR(cookie) && path->dentry->d_inode->i_op->put_link)
> >   -               path->dentry->d_inode->i_op->put_link(path->dentry,
> > nd, cookie);
> >   +       if (!IS_ERR(cookie) && inode->i_op->put_link)
> >   +               inode->i_op->put_link(path->dentry, nd, cookie);
> > 
> > since we've verified that 'inode' is 'path->dentry->d_inode', and all
> > of those should be stable over all the calls (in the non-RCU case,
> > which we are in).
> > 
> > I dunno. I don't care _deeply_, but I do have to say that I much liked
> > how you moved the
> > 
> >     if (nameidata_dentry_drop_rcu_maybe(nd, path->dentry))
> >       ..
> > 
> > into do_follow_link(). I think it made it clearer that do_follow_link
> > (and __do_follow_link()) aren't done with RCU.
> 
> OK, I can live with that.  Consider me convinced, let's go with your variant.
> Speaking of ugliness: Nick, why the _fuck_ have you reverted non-create case
> in do_filp_open() to do_path_lookup()?

I tested both (Linus/Al) versions, please feel free to add

Tested-by: Eric Dumazet <eric.dumazet@gmail.com>



