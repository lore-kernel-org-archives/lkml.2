Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1EFGUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:20:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57023 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1EFGUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U/L6jC8EoXoV/CJFnF0nrkcRDBHuUtf4f3Me9KOHM97Uphd+v0NOU2rUKKiZRGLtoJ
         k9jHWAvDHuZBAzyX7FjusuV7qxfOVDDrmqJKkYgJQZFnEzmCIchLurUrBOkM4kUsL3fh
         4K57ktEc/R4nwzF5XjgPftPsGUhaEKUCgeBhQ=
Subject: Re: [PATCH] RCU: remove alignment padding from rcu_data on 64 bit
 builds
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
In-Reply-To: <1304610604.1984.6.camel@castor.rsk>
References: <1304610604.1984.6.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 08:20:45 +0200
Message-ID: <1304662845.3131.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 05 mai 2011 à 16:50 +0100, Richard Kennedy a écrit :
> Reorder rcu_data to remove 8 bytes of alignment padding on 64 bit builds
> so saving a total of 16 bytes per cpu, (rcu_sched_data & rcu_bh_data).
>     
> When CONFIG_NO_HZ is set, it shrinks the size of this structure from 264
> to 256 bytes allowing it to fit into one fewer cache lines.
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ---
> 
> patch against v2.6.39-rc6
> compiled & tested on x86_64
> 
> I've been running with this patch for some weeks and have not seen any
> issues.
> 
> regards
> Richard
> 
> 
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index e8f057e..fcced0f 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -176,6 +176,9 @@ struct rcu_data {
>  	bool		qs_pending;	/* Core waits for quiesc state. */
>  	bool		beenonline;	/* CPU online at least once. */
>  	bool		preemptable;	/* Preemptable RCU? */
> +
> +	int cpu;
> +
>  	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
>  	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
>  
> @@ -238,8 +241,6 @@ struct rcu_data {
>  	unsigned long n_rp_gp_started;
>  	unsigned long n_rp_need_fqs;
>  	unsigned long n_rp_need_nothing;
> -
> -	int cpu;
>  };
>  

We could shrink this structure more, converting some 64bit fields to
32bit ones.

Rationale is the algo is working well on 32bit arches, no need to use
64bit fields.

candidates : completed, gpnum, passed_quiesc_completed, qlen,
qlen_last_fqs_check, blimit.

Counters might be converted too.



