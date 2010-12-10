Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0LJQFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:05:39 -0500
Received: from canuck.infradead.org ([134.117.69.58]:48420 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab0LJQFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:05:37 -0500
Subject: Re: [PATCH] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1291865039.2795.46.camel@edumazet-laptop>
References: <1291863926.2965.1.camel@Dan>
	 <1291865039.2795.46.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 17:05:32 +0100
Message-ID: <1291997132.13513.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 04:23 +0100, Eric Dumazet wrote:
> > +             if (kptr_restrict) {
> > +                     if (in_interrupt())
> > +                             WARN(1, "%%pK used in interrupt context.\n");
> 
> So caller can not block BH ?
> 
> This seems wrong to me, please consider :
> 
> normal process context :
> 
> spin_lock_bh() ...
> 
> for (...)  
>         {xxx}printf( ...   "%pK"   ...)
> 
> spin_unlock_bh(); 

That's a bug in in_interrupt(), one I've been pointing out for a long
while. Luckily we recently grew the infrastructure to deal with it.

If you write it as: if (in_irq() || in_serving_softirq() || in_nmi())
you'll not trigger for the above example.

Ideally in_serving_softirq() wouldn't exist and in_softirq() would do
what in_server_softirq() does -- which would make it symmetric with the
hardirq functions -- but nobody has found time to audit all in_softirq()
users.


