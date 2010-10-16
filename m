Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0JPBmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:42:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58414 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0JPBmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:42:07 -0400
Date: Sat, 16 Oct 2010 02:41:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH 1/4] m32r: restore _BLOCKABLE
Message-ID: <20101016014158.GR19804@ZenIV.linux.org.uk>
References: <20101016010952.GQ8332@bombadil.infradead.org>
 <20101016011645.GS8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016011645.GS8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:16:45PM -0400, Kyle McMartin wrote:
> Commit a7f8388e accidentally removed it...
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> ---
>  arch/m32r/kernel/signal.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
> index 7bbe386..cc36fe1 100644
> --- a/arch/m32r/kernel/signal.c
> +++ b/arch/m32r/kernel/signal.c
> @@ -28,6 +28,8 @@
>  
>  #define DEBUG_SIG 0
>  
> +#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
> +

Grrr...   Sorry, reordering breakage.  In the signals tree here I have

static inline void sig_set_blocked(struct sigset_t *set)
{
        sigdelsetmask(set, sigmask(SIGKILL) | sigmask(SIGSTOP));
        spin_lock_irq(&current->sighand->siglock);
        current->blocked = *set;
        recalc_sigpending();
        spin_unlock_irq(&current->sighand->siglock);
}

and it's used all over the place (including quite a few places where
we currently have sigprocmask(SIG_SETMASK, set, NULL), which is what
it's equivalent to).  With that done, m32r doesn't use _BLOCKABLE
anywhere, so it got removed.  And that chunk got picked when I'd been
reordering the queue to pull the arch-specific fixes in front.  Sorry.

