Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1JURIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 13:08:10 -0400
Received: from mail.vyatta.com ([76.74.103.46]:60610 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1JURIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 13:08:09 -0400
Date: Fri, 21 Oct 2011 10:07:59 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Mihai Maruseac <mihai.maruseac@gmail.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl,
        therbert@google.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbaluta@ixiacom.com,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Subject: Re: [PATCH] dev: use name hash for dev_seq_ops
Message-ID: <20111021100759.0a6bba45@s6510.linuxnetplumber.net>
In-Reply-To: <1319179510-10715-1-git-send-email-mmaruseac@ixiacom.com>
References: <1319097717-14910-1-git-send-email-mmaruseac@ixiacom.com>
	<1319179510-10715-1-git-send-email-mmaruseac@ixiacom.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011 09:45:10 +0300
Mihai Maruseac <mihai.maruseac@gmail.com> wrote:

> Instead of using the dev->next chain and trying to resync at each call to
> dev_seq_start, use the name hash, keeping the bucket and the offset in
> seq->private field.
> 
> Tests revealed the following results for ifconfig > /dev/null
> 	* 1000 interfaces:
> 		* 0.114s without patch
> 		* 0.089s with patch
> 	* 3000 interfaces:
> 		* 0.489s without patch
> 		* 0.110s with patch
> 	* 5000 interfaces:
> 		* 1.363s without patch
> 		* 0.250s with patch
> 	* 128000 interfaces (other setup):
> 		* ~100s without patch
> 		* ~30s with patch
> 
> Signed-off-by: Mihai Maruseac <mmaruseac@ixiacom.com>
> ---
>  net/core/dev.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 69 insertions(+), 15 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 70ecb86..6edbcc5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4041,6 +4041,60 @@ static int dev_ifconf(struct net *net, char __user *arg)
>  }
>  
>  #ifdef CONFIG_PROC_FS
> +
> +#define BUCKET_SPACE (32 - NETDEV_HASHBITS)
> +
> +struct dev_iter_state {
> +	struct seq_net_private p;
> +	unsigned int pos; /* bucket << BUCKET_SPACE + offset */
> +};
> +
> +#define get_bucket(x) ((x) >> BUCKET_SPACE)
> +#define get_offset(x) ((x) & ((1 << BUCKET_SPACE) - 1))
> +#define set_bucket_offset(b, o) ((b) << BUCKET_SPACE | (o))
> +
> +static inline struct net_device *dev_from_same_bucket(struct seq_file *seq)
>

Why are all these function marked inline? They are big, hardly hot path
and better to not continue the bad practice of inlining too much code.
