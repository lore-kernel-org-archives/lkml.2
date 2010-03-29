Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0C2VW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:22:28 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:53143 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0C2VW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:22:26 -0400
Subject: Re: [2.6.34-rc2 NFS4 oops] open error path failure...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, linux-nfs@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100329190307.GJ30031@ZenIV.linux.org.uk>
References: <6278d2221003291136p6481fe8emfb039403343c082@mail.gmail.com>
	 <20100329190307.GJ30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 17:22:20 -0400
Message-ID: <1269897740.15895.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 2 sum rcpts/h 9 sum msgs/h 3 total rcpts 2681 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: F69F25C7E333C2692AA498BA9DCF1292EC7B440C
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 281 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 20:03 +0100, Al Viro wrote: 
> On Mon, Mar 29, 2010 at 07:36:45PM +0100, Daniel J Blueman wrote:
> > Hi Trond,
> > 
> > When open fails and should return EPERM [1], instead we see an oops
> > [2]. I see this on 2.6.34-rc1 and -rc2 mainline; NFS4 server is
> > mainline 2.6.33.1.
> > 
> > Let me know if you can't reproduce it and I'll provide some analysis
> > from this end.
> 
> Joy...  ERR_PTR(-EPERM) in nd.intent.file, and whoever had called
> lookup_instantiate_filp() hadn't bothered to check the return value.
> 
> OK, I think I see what's going on.  Replace
>                                 lookup_instantiate_filp(nd, (struct dentry *)state, NULL);
>                                 return 1;
> with
>                                 lookup_instantiate_filp(nd, (struct dentry *)state, NULL);
>                                 return state;
> in fs/nfs/nfs4proc.c:nfs4_open_revalidate() and see if everything works
> properly (or just lose the lookup_instantiate_filp() in there and simply
> return state).
> 

So this raises a point. Originally, the d_revalidate() call was required
to return a boolean 0 or 1. Nowadays it allows the filesystem to return
an error value instead.

Should we therefore rewrite the NFS implementation to propagate errors
like ESTALE (when it means the parent directory is gone), EACCES, EPERM
and EIO instead of the current behaviour of just dropping the dentry and
hence forcing a lookup?

Trond

