Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1HQOoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab1HQOoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:44:37 -0400
Date: Wed, 17 Aug 2011 16:41:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 40/41] ncpfs: Use set_current_blocked()
Message-ID: <20110817144139.GA17271@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-41-git-send-email-matt@console-pimps.org> <20110816175643.GI29190@redhat.com> <1313528170.3436.200.camel@mfleming-mobl1.ger.corp.intel.com> <20110817120405.GA10709@redhat.com> <1313589483.2311.24.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313589483.2311.24.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Matt Fleming wrote:
>
> On Wed, 2011-08-17 at 14:04 +0200, Oleg Nesterov wrote:
> > On 08/16, Matt Fleming wrote:
> > >
> > > > the sighand->action[] checks are racy anyway in the mt case, siglock
> > > > can't help.
> > >
> > > Hmm.. really? I thought that ->siglock serialised modifications to
> > > sighand->action[] even in the mt case, no?
> >
> > Sure. But another thread can change sighand->action[] right after we
> > drop ->siglock. So how can this lock help? We simply read the word,
> > this is atomic and doesn't need the locking.
>
> Oh right, in the scenario in ncp_do_request(), sure I understand that. I
> thought you were saying that in the general case ->siglock doesn't
> protect sighand->action[]! That's why I was confused ;-)
>
> OK, how about this patch (instead of 40/41) which gets rid of all the
> nasties? I've Cc'd linux-fsdevel so people can hopefully OK this from a
> file system perspective.

Well, of course I am in no position to ack this change ;)

But obviously I like the idea to kill the obviously wrong code.
In particular, the PF_EXITING/SIGKILL logic looks as "must die
in any case" to me.

If maintainers object, you can remove ->siglock and convert the code
to use set_current_blocked(). IOW, simplify your original patch.

Oleg.

> From bb1650295054bdfa96f8f4ff61507d314be8296a Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Wed, 17 Aug 2011 13:59:12 +0100
> Subject: [PATCH] ncpfs: Don't attempt to mask signals during
>  do_ncp_rpc_call()
> 
> Delete the code in ncp_do_request() that attempts to mask signals
> across the call to do_ncp_rpc_call(). This code was racy because it
> dropped ->siglock across do_ncp_rpc_call() so it was possible for
> another thread to modify the signal handlers, which made the code
> pointless.
> 
> Instead of fixing the code to hold the lock across the call let's just
> delete it because, as the FIXME comment (which has been around since
> the beginning of git history) says, trying to block signals doesn't
> seem right at all.
> 
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  fs/ncpfs/sock.c |   32 +-------------------------------
>  1 files changed, 1 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
> index 3a15872..6618402 100644
> --- a/fs/ncpfs/sock.c
> +++ b/fs/ncpfs/sock.c
> @@ -748,38 +748,8 @@ static int ncp_do_request(struct ncp_server *server, int size,
>  	if (!ncp_conn_valid(server)) {
>  		return -EIO;
>  	}
> -	{
> -		sigset_t old_set;
> -		unsigned long mask, flags;
> -
> -		spin_lock_irqsave(&current->sighand->siglock, flags);
> -		old_set = current->blocked;
> -		if (current->flags & PF_EXITING)
> -			mask = 0;
> -		else
> -			mask = sigmask(SIGKILL);
> -		if (server->m.flags & NCP_MOUNT_INTR) {
> -			/* FIXME: This doesn't seem right at all.  So, like,
> -			   we can't handle SIGINT and get whatever to stop?
> -			   What if we've blocked it ourselves?  What about
> -			   alarms?  Why, in fact, are we mucking with the
> -			   sigmask at all? -- r~ */
> -			if (current->sighand->action[SIGINT - 1].sa.sa_handler == SIG_DFL)
> -				mask |= sigmask(SIGINT);
> -			if (current->sighand->action[SIGQUIT - 1].sa.sa_handler == SIG_DFL)
> -				mask |= sigmask(SIGQUIT);
> -		}
> -		siginitsetinv(&current->blocked, mask);
> -		recalc_sigpending();
> -		spin_unlock_irqrestore(&current->sighand->siglock, flags);
> -		
> -		result = do_ncp_rpc_call(server, size, reply, max_reply_size);
>  
> -		spin_lock_irqsave(&current->sighand->siglock, flags);
> -		current->blocked = old_set;
> -		recalc_sigpending();
> -		spin_unlock_irqrestore(&current->sighand->siglock, flags);
> -	}
> +	result = do_ncp_rpc_call(server, size, reply, max_reply_size);
>  
>  	DDPRINTK("do_ncp_rpc_call returned %d\n", result);
>  
> -- 
> 1.7.4.4
> 
> 

