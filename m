Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2JINnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:43:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab2JINnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:43:23 -0400
Date: Tue, 9 Oct 2012 15:43:20 +0200
From: Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/16] vfs: bogus warnings in fs/namei.c
Message-ID: <20121009134320.GC15790@quack.suse.cz>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
 <20121008115116.GA9243@quack.suse.cz>
 <201210091227.46324.arnd@arndb.de>
 <201210091307.19225.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210091307.19225.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-10-12 13:07:19, Arnd Bergmann wrote:
> On Tuesday 09 October 2012, Arnd Bergmann wrote:
> > On Monday 08 October 2012, Jan Kara wrote:
> > > On Fri 05-10-12 16:55:19, Arnd Bergmann wrote:
> > > > The follow_link() function always initializes its *p argument,
> > > > or returns an error, but not all versions of gcc figure this
> > > > out, so we have to work around this using the uninitialized_var()
> > > > macro.
> > >   Well, I'm somewhat sceptical to this approach. I agree that bogus
> > > warnings are not nice but later when the code is changed and possibly real
> > > use without initialization is added, we won't notice it. Without changing
> > > anything, we'd at least have a chance of catching it with gcc versions
> > > which were clever enough to not warn with the original code. Or
> > > alternatively if we unconditionally initialized the variable that would get
> > > rid of the warning and made the code more future-proof (that's what I
> > > usually end up doing)... I don't really care that much about the chosen
> > > solution, Al is the one to decide. But I wanted to point out there are
> > > downsides to your solution.
> > 
> > I'll drop the patch for now and won't send it from my tree then. I agree
> > that uninitialized_var() is not ideal, but none of the alternatives seemed
> > better.
> > 
> > With my latest compiler, I don't actually see the warnings any more, so
> > maybe someone fixed gcc instead, or this went away after another change.
> > I'll let you know if it comes back so we can discuss about a better fix then.
> > 
> 
> Update: I could actually reproduce the problem now, but it only happens when
> building with 'gcc -s' (i.e. CONFIG_CC_OPTIMIZE_FOR_SIZE). It does happen
> with both gcc-4.6 and with gcc-4.8, and on both x86-64 and ARM. An alternative
> patch that would also make it go away is the variant below, but I think that's
> even worse than the first version I suggested because it makes the binary
> output slightly worse by adding an unnecessary initialization when building with
> 'make -s'.
  Hum, dumb compiler... I like this patch better and since the extra
initialization is on error path only, I don't think it matters. But
whatever Al likes better.

									Honza

> diff --git a/fs/namei.c b/fs/namei.c
> index aa30d19..c3612a5 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -810,6 +810,7 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
>  	return error;
>  
>  out_put_nd_path:
> +	*p = NULL;
>  	path_put(&nd->path);
>  	path_put(link);
>  	return error;
