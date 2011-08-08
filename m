Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1HHOf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:35:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58472 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1HHOf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:35:27 -0400
Date: Mon, 8 Aug 2011 07:35:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: fix rcu annotations noise in cred.h
Message-ID: <20110808143524.GA2331@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110808123442.GF2385@linux.vnet.ibm.com>
 <20110807175511.GZ2203@ZenIV.linux.org.uk>
 <13248.1312791509@redhat.com>
 <13642.1312808048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13642.1312808048@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:54:08PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This is indeed what rcu_dereference_protected() is intended for.
> 
> How about the attached patch?
> 
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] CRED: Restore const to current_cred()
> 
> Commit 3295514841c2112d94451ba5deaf54f5afb78ea9 accidentally dropped the const
> of current->cred inside current_cred() by the insertion of a cast to deal with
> an RCU annotation loss warning from sparce.
> 
> Use an appropriate RCU wrapper instead so as not to lose the const.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
> 
>  include/linux/cred.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index 98f46ef..8e2fd44 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -269,7 +269,7 @@ static inline void put_cred(const struct cred *_cred)
>   * since nobody else can modify it.
>   */
>  #define current_cred() \
> -	(*(__force struct cred **)&current->cred)
> +	rcu_dereference_protected(current->cred, 1)
> 
>  /**
>   * __task_cred - Access a task's objective credentials
