Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2BAHH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:07:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2BAHHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:07:24 -0500
Message-ID: <1328080039.22641.2.camel@edumazet-laptop>
Subject: Re: [PATCH 6/6] cls_cgroup: remove redundant rcu_read_lock/unlock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 01 Feb 2012 08:07:19 +0100
In-Reply-To: <4F28E22A.703@cn.fujitsu.com>
References: <4F28E1D1.900@cn.fujitsu.com> <4F28E22A.703@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 février 2012 à 14:56 +0800, Li Zefan a écrit :
> We've already used rcu_read_lock/unlock inside task_classid(),
> so don't use the lock/unlock pair twice in this hot path.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  net/core/sock.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 213c856..c0bab23 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1160,9 +1160,7 @@ void sock_update_classid(struct sock *sk)
>  {
>  	u32 classid;
>  
> -	rcu_read_lock();  /* doing current task, which cannot vanish. */
>  	classid = task_cls_classid(current);
> -	rcu_read_unlock();
>  	if (classid && classid != sk->sk_classid)
>  		sk->sk_classid = classid;

Yes, this seems fine.

Then, I wonder why we do the "if (classid && classid != sk->sk_classid)"

before the :

	sk->sk_classid = classid;

This seems unnecessary checks.


