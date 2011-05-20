Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab1ETH7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:59:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59750 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab1ETH7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dtR0Ul7at5wDMo5SZZczk90fsMA1/gflPcJfYOuvUPVzlwjujGwoG5LwhufDrv8yKA
         o4/32yBhxy0DOfEkJglknL70Z96N5JwzqBeGsrI+iaL6KaoPi5gM045+jXoTqd3SxyKa
         vgU1TLAhFzmh9ky9IG9q6VcUdmZNLTCl1Qw7M=
MIME-Version: 1.0
In-Reply-To: <20110520141417.f49bf364.sfr@canb.auug.org.au>
References: <20110520141417.f49bf364.sfr@canb.auug.org.au>
Date: Fri, 20 May 2011 09:59:20 +0200
Message-ID: <BANLkTik=bC1beZWx5eLDMmGcOp5UZ29MUQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree (net tree interaction)
From: Jacek Luczak <difrost.kernel@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> net/sctp/bind_addr.c: In function 'sctp_bind_addr_clean':
> net/sctp/bind_addr.c:148: error: 'sctp_local_addr_free' undeclared (first use in this function)
>
> Caused by commit 1231f0baa547 ("net,rcu: convert call_rcu
> (sctp_local_addr_free) to kfree_rcu()") interacting with commit
> c182f90bc1f2 ("SCTP: fix race between sctp_bind_addr_free() and
> sctp_bind_addr_conflict()") from the net tree.
>
> I applied the following patch as a merge fix:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 20 May 2011 14:11:11 +1000
> Subject: [PATCH] net,rcu: convert another call to call_rcu(sctp_local_addr_free)
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/sctp/bind_addr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
> index 6338413..83e3011 100644
> --- a/net/sctp/bind_addr.c
> +++ b/net/sctp/bind_addr.c
> @@ -145,7 +145,7 @@ static void sctp_bind_addr_clean(struct sctp_bind_addr *bp)
>        /* Empty the bind address list. */
>        list_for_each_entry_safe(addr, temp, &bp->address_list, list) {
>                list_del_rcu(&addr->list);
> -               call_rcu(&addr->rcu, sctp_local_addr_free);
> +               kfree_rcu(addr, rcu);
>                SCTP_DBG_OBJCNT_DEC(addr);
>        }
>  }
> --
> 1.7.5.1
>


Hi

as this is planned to be backported down to stable/longterm, kfree_rcu
was not used here. I guess in meantime the callback has been removed
while introducing kfree_rcu in sctp  module. I have a patch ready to
send for net-next-2.6 converting to kfree_rcu in sctp, only I've been
waiting for it jumping to the tree.

This patch is of course valid.

-Jacek
