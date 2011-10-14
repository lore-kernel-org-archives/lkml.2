Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab1JNMw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:52:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37446 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1JNMw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:52:56 -0400
Message-ID: <1318596791.2223.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] dev: use ifindex hash for dev_seq_ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mihai Maruseac <mihai.maruseac@gmail.com>
Cc: davem@davemloft.net, mirq-linux@rere.qmqm.pl, therbert@google.com,
        jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbaluta@ixiacom.com,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Date: Fri, 14 Oct 2011 14:53:11 +0200
In-Reply-To: <1318586017-17207-1-git-send-email-mmaruseac@ixiacom.com>
References: <1318413446-22258-1-git-send-email-mmaruseac@ixiacom.com>
	 <1318586017-17207-1-git-send-email-mmaruseac@ixiacom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 octobre 2011 à 12:53 +0300, Mihai Maruseac a écrit :
> Instead of using the dev->next chain and trying to resync at each call to
> dev_seq_start, use the ifindex, keeping the last index in seq->private field.
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
>  net/core/dev.c |   55 ++++++++++++++++++++++++++++++++++---------------------
>  1 files changed, 34 insertions(+), 21 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 70ecb86..ea24445 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4041,6 +4041,37 @@ static int dev_ifconf(struct net *net, char __user *arg)
>  }
>  
>  #ifdef CONFIG_PROC_FS
> +
> +struct dev_iter_state {
> +	struct seq_net_private p;
> +	int ifindex;
> +};
> +
> +static struct net_device *__dev_seq_next(struct seq_file *seq, loff_t *pos)
> +{
> +	struct dev_iter_state *state = seq->private;
> +	struct net *net = seq_file_net(seq);
> +	struct net_device *dev;
> +	loff_t off;
> +
> +	dev = dev_get_by_index_rcu(net, state->ifindex);
> +	if (likely(dev))
> +		goto found;
> +
> +	off = 0;
> +	for_each_netdev_rcu(net, dev)
> +		if (off++ == *pos) {
> +			state->ifindex = dev->ifindex;
> +			goto found;
> +		}
> +
> +	return NULL;
> +found:
> +	state->ifindex++;

This assumes device ifindexes are contained in a small range 
[N .. N + X]

I understand this can help some benchmarks, but in real world this wont
help that much once ifindexes are 'fragmented' (If really this multi
thousand devices stuff is for real)

Listen, we currently have 256 slots in the hash table.

Can we try to make 'offset' something like  (slot_number<<24) +
(position in hash chain [slot_number]), instead of (position in devices
global list)



