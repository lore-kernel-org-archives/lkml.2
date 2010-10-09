Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344Ab0JIRWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 13:22:46 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34708 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0JIRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 13:22:45 -0400
Date: Sat, 9 Oct 2010 11:22:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] fs: Reduce inode I_FREEING and factor inode
	disposal
Message-ID: <20101009172244.GG10421@parisc-linux.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com> <1286515292-15882-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-19-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:32PM +1100, Dave Chinner wrote:
>  /*
> - * dispose_list - dispose of the contents of a local list
> - * @head: the head of the list to free
> + * Free the inode passed in, removing it from the lists it is still connected
> + * to but avoiding unnecessary lock round-trips for the lists it is no longer
> + * on.
>   *
> - * Dispose-list gets a local list with local inodes in it, so it doesn't
> - * need to worry about list corruption and SMP locks.
> + * An inode must already be marked I_FREEING so that we avoid the inode being
> + * moved back onto lists if we race with other code that manipulates the lists
> + * (e.g. writeback_single_inode).
>   */
> -static void dispose_list(struct list_head *head)
> +static void dispose_one_inode(struct inode *inode)
>  {
> -	while (!list_empty(head)) {
> -		struct inode *inode;
> +	BUG_ON(!(inode->i_state & I_FREEING));

I think this may be my favourite comment in this whole patch set.  It's a
real pain to hit BUG_ONs and not know why it's there.  Thank you.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
