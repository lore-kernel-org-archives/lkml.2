Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0IGUuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:50:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55167 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab0IGUuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:50:18 -0400
Date: Tue, 7 Sep 2010 13:50:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100907205015.GJ2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
 <201009062210.56824.arnd@arndb.de>
 <20100907192154.GA14214@albatros>
 <201009072200.59509.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009072200.59509.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 10:00:58PM +0200, Arnd Bergmann wrote:
> On Tuesday 07 September 2010 21:21:55 Kulikov Vasiliy wrote:
> > #define __rcu_dereference_check(p, c, space) \
> >         ({ \
> >                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> >                                                                    ^
> >                 rcu_lockdep_assert(c); \
> >                 (void) (((typeof (*p) space *)p) == p); \
> >                                       ^     ^
> >                 smp_read_barrier_depends(); \
> >                 ((typeof(*p) __force __kernel *)(_________p1)); \
> >         })
> > 
> > If I understand this, it is evaluated three times, right?
> 
> Yes, that looks like my own fault, I added that :(
> 
> This patch seems to fix it, but I need to think about it some more
> to make sure it still does everything we need.

Let me know when you are satisfied with it, and then I will pick it up.

							Thanx, Paul

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 89414d6..743bc3f 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -313,21 +313,21 @@ extern int rcu_my_thread_group_empty(void);
>  #define __rcu_access_pointer(p, space) \
>  	({ \
>  		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> -		(void) (((typeof (*p) space *)p) == p); \
> +		(void) (((typeof (*p) space *)NULL) == (typeof(p))NULL); \
>  		((typeof(*p) __force __kernel *)(_________p1)); \
>  	})
>  #define __rcu_dereference_check(p, c, space) \
>  	({ \
>  		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
>  		rcu_lockdep_assert(c); \
> -		(void) (((typeof (*p) space *)p) == p); \
> +		(void) (((typeof (*p) space *)NULL) == (typeof(p))NULL); \
>  		smp_read_barrier_depends(); \
>  		((typeof(*p) __force __kernel *)(_________p1)); \
>  	})
>  #define __rcu_dereference_protected(p, c, space) \
>  	({ \
>  		rcu_lockdep_assert(c); \
> -		(void) (((typeof (*p) space *)p) == p); \
> +		(void) (((typeof (*p) space *)NULL) == (typeof(p))NULL); \
>  		((typeof(*p) __force __kernel *)(p)); \
>  	})
> 
