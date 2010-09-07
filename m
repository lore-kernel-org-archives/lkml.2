Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab0IGTWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:22:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41024 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab0IGTWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Jv6wWkznfcsruiiUXWZC8eXTRalrbF2z5k8QBSjCM5zSTC9lKYFF1ziBWysQqsO5qB
         +XG0mTUF1ZlMaPT+2qpKsPlwMB1a5vS2tja9H1d0/XDEaADxTqtt1jfupvX6RTphvojj
         8q+dIC4KA+W+IZCsJQ5MwtBTSprf+6aLi/CDM=
Date: Tue, 7 Sep 2010 23:21:55 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100907192154.GA14214@albatros>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
 <201009062210.56824.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201009062210.56824.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 22:10 +0200, Arnd Bergmann wrote:
> On Sunday 05 September 2010 20:32:18 Kulikov Vasiliy wrote:
> > From: Vasiliy Kulikov <segooon@gmail.com>
> > 
> > rcu_dereference() is macro, so it might use its argument twice.
> > Argument must not has side effects.
> > 
> > It was found by compiler warning:
> > drivers/md/raid1.c: In function ‘read_balance’:
> > drivers/md/raid1.c:445: warning: operation on ‘new_disk’ may be undefined
> 
> I think the rcu_dereference macro should really not evaluate its argument
> twice, and I don't see where it does.
> As a general rule, we try to write macros in Linux such that they behave
> like functions and don't have surprising side-effects.
> 
> Which kernel and gcc version do you see the warning with?
> 
> 	Arnd

gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5), linux-next.

#define __rcu_dereference_check(p, c, space) \
	({ \
		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
                                                                   ^
		rcu_lockdep_assert(c); \
		(void) (((typeof (*p) space *)p) == p); \
                                      ^     ^
		smp_read_barrier_depends(); \
		((typeof(*p) __force __kernel *)(_________p1)); \
	})

If I understand this, it is evaluated three times, right?


-- 
Vasiliy
