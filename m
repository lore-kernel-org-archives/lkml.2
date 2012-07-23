Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2GWUrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:47:20 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:17909 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2GWUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:47:18 -0400
Date: Mon, 23 Jul 2012 22:47:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: st_size of a symlink
In-Reply-To: <20120723202224.GH31729@ZenIV.linux.org.uk>
Message-ID: <alpine.LNX.2.00.1207232243110.1922@swampdragon.chaosbits.net>
References: <500D73FF.1070504@nod.at> <alpine.LNX.2.00.1207231959410.1922@swampdragon.chaosbits.net> <20120723202224.GH31729@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Al Viro wrote:

> On Mon, Jul 23, 2012 at 08:09:14PM +0200, Jesper Juhl wrote:
> > So, from my point of view it looks like procfs is the one who has got it 
> > wrong.
> > We should probably fix that (IMVHO).
> 
> Fix it _how_?  

By returning the size as the number of bytes in the name the link is 
currently pointing at.

> Try to rename a binary you have running in a process.
> Or rename its cwd.  Or rename an opened file.  Watch the corresponding
> procfs symlink (still pointing to the swame object) change.  With
> no way to tell that some sucker had looked at st_size some time ago
> and might get surprised by the change.
> 
Sure, length's may change and an app needs to be prepared for that, but 
that's no reason to always return 0 (zero) for length for links in procfs.
We can do better and return the actual length of whatever the link is 
pointing to currently - just like other filesystems do.

> The fact is, st_size is just a useful hint for symlink target length.

Sure.

> It tells you the likely sufficient size of buffer.  There's a reason
> why readlink(2) returns what it returns; you *can't* rely on the
> earlier lstat() results or, for that matter, any prior information.

I know that. That's not the issue. The issue is that procfs *could* return 
more useful info than it does currently.

> If nothing else, I could rm that symlink and create a new one in
> the meanwhile.  You need to check what it had returned and deal with
> insufficient buffer size.

Of course.

>  By retrying readlink() with bigger buffer.
> With procfs there's just a few more ways the readlink() output can
> change, that's all.
> 
Still not a good reason to just return 0 IMHO.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

