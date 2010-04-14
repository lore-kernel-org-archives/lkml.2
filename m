Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0DNPec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:34:32 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:42501 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0DNPea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FT3k82HkG0VXTcbjHBK28hZ4JURa+j3F+zrHTqdIFA4BkTUj+AH6B1wrvNTTP1FXSZ
         6Wk4gOwLt0IqAz+06ualqH4m1tfr90xIqlgknDOD2fc10snM3rZ7Q5oqvMEqWQli0mI8
         J/ya3C5EdGEl3oMr8Ji/HQTjU1e6dbe9O5VsM=
Subject: Re: [PATCH net-next-2.6] fasync: RCU locking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1271257027.16881.1663.camel@edumazet-laptop>
References: <1271230961.16881.630.camel@edumazet-laptop>
	 <4BC57E7D.9060706@cn.fujitsu.com>
	 <1271257027.16881.1663.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 17:34:24 +0200
Message-ID: <1271259264.16881.1703.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 avril 2010 à 16:57 +0200, Eric Dumazet a écrit :
> Le mercredi 14 avril 2010 à 16:36 +0800, Lai Jiangshan a écrit :
> 
> > Since rcu_read_lock() protects fasync_struct *fa for us, we can access
> > to @fa safely even fasync_remove_entry() is just called.
> > 
> > But this patch does not ensure 'fa->fa_file is not freed' nor
> > 'fa->fa_fd is not released', so kill_fasync_rcu() may do wrong thing
> > if there is no other code ensure it.
> 
> You are 100% right, I forgot my old attempt to RCUified struct files
> failed...
> 
> Maybe its time to finally move f_owner out of struct file, and use RCU
> to free it.
> 
> In the mean time, adding a lock in fasync_struct is more than enough.
> 
> Thanks !
> 
> [PATCH net-next-2.6 v2] fasync: fine grained locking
> 
> kill_fasync() uses a central rwlock, candidate for RCU conversion, to
> avoid cache line ping pongs on SMP.
> 
> fasync_remove_entry() and fasync_add_entry() can disable IRQS on a short
> section instead during whole list scan.
> 
> Use a spinlock per fasync_struct to synchronize fasync_{remove|
> add}_entry() and kill_fasync_rcu()
> 
> We can remove __kill_fasync() direct use in net, and rename it to
> kill_fasync_rcu().
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Please wait for a v3 version, as net/socket.c sock_fasync() should be
updated too...



