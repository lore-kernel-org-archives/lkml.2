Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1IUSvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:51:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab1IUSvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:51:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=uvjlF8xm3HEXefWSmmnb8rIEZdb1SrqvWYVlYvGMdERYsjEQfJOROcGNSjypid8QB
	h8Kif5AHPWhtgXCiRkF7Q==
MIME-Version: 1.0
In-Reply-To: <1316393805-3005-3-git-send-email-glommer@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-3-git-send-email-glommer@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 21 Sep 2011 11:47:29 -0700
Message-ID: <CAHH2K0YgkG2J_bO+U9zbZYhTTqSLvr6NtxKxN8dRtfHs=iB8iA@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] socket: initial cgroup code.
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 5:56 PM, Glauber Costa <glommer@parallels.com> wrote:
> We aim to control the amount of kernel memory pinned at any
> time by tcp sockets. To lay the foundations for this work,
> this patch adds a pointer to the kmem_cgroup to the socket
> structure.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
...
> +void sock_update_memcg(struct sock *sk)
> +{
> +       /* right now a socket spends its whole life in the same cgroup */
> +       BUG_ON(sk->sk_cgrp);
> +
> +       rcu_read_lock();
> +       sk->sk_cgrp = mem_cgroup_from_task(current);
> +
> +       /*
> +        * We don't need to protect against anything task-related, because
> +        * we are basically stuck with the sock pointer that won't change,
> +        * even if the task that originated the socket changes cgroups.
> +        *
> +        * What we do have to guarantee, is that the chain leading us to
> +        * the top level won't change under our noses. Incrementing the
> +        * reference count via cgroup_exclude_rmdir guarantees that.
> +        */
> +       cgroup_exclude_rmdir(mem_cgroup_css(sk->sk_cgrp));

This grabs a css_get() reference, which prevents rmdir (will return
-EBUSY).  How long is this reference held?  I wonder about the case
where a process creates a socket in memcg M1 and later is moved into
memcg M2.  At that point an admin would expect to be able to 'rmdir
M1'.  I think this rmdir would return -EBUSY and I suspect it would be
difficult for the admin to understand why the rmdir of M1 failed.  It
seems that to rmdir a memcg, an admin would have to kill all processes
that allocated sockets while in M1.  Such processes may not still be
in M1.

> +       rcu_read_unlock();
> +}
