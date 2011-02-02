Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1BBB1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:27:46 -0500
Received: from mail.perches.com ([173.55.12.10]:3521 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab1BBB1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 20:27:39 -0500
Subject: Re: [PATCH 2/2] hex_dump_dbg: replace all calls to print_hex_dump
 with level KERN_DEBUG
From: Joe Perches <joe@perches.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201102011348.18978.roman.fietze@telemotive.de>
References: <201012031517.35062.roman.fietze@telemotive.de>
	 <1295029146.4099.71.camel@Joe-Laptop>
	 <201102011345.30618.roman.fietze@telemotive.de>
	 <201102011348.18978.roman.fietze@telemotive.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 17:27:37 -0800
Message-ID: <1296610057.4425.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:48 +0100, Roman Fietze wrote:
> And here, just in case it's wanted or needed, a bigger patch replacing
> all print_hex_dump calls using KERN_DEBUG.

[]

I think a lot of these changes are senseless.

print_hex_dump is a perfectly good call and doesn't
always need to be replaced by something else.

For instance:

> diff --git a/net/atm/lec.c b/net/atm/lec.c
> index 38754fd..6be1be1 100644
> --- a/net/atm/lec.c
> +++ b/net/atm/lec.c
> @@ -318,8 +318,8 @@ static netdev_tx_t lec_start_xmit(struct sk_buff *skb,
>  #if DUMP_PACKETS >= 1
>  	printk(KERN_DEBUG "%s: send datalen:%ld lecid:%4.4x\n",
>  	       dev->name, skb->len, priv->lecid);
> -	print_hex_dump(KERN_DEBUG, "", DUMP_OFFSET, 16, 1,
> -		       skb->data, min(skb->len, MAX_DUMP_SKB), true);
> +	hex_dump_dbg("", DUMP_OFFSET, 16, 1,
> +		     skb->data, min(skb->len, MAX_DUMP_SKB), true);

print_hex_dump is already guarded by an #if block.
Adding another DEBUG guard and optional on/off
control does not add any utility.

> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
[]
> @@ -2390,19 +2390,19 @@ void ceph_msg_dump(struct ceph_msg *msg)
>  {
>  	pr_debug("msg_dump %p (front_max %d nr_pages %d)\n", msg,
>  		 msg->front_max, msg->nr_pages);
> -	print_hex_dump(KERN_DEBUG, "header: ",
> -		       DUMP_PREFIX_OFFSET, 16, 1,
> -		       &msg->hdr, sizeof(msg->hdr), true);
> -	print_hex_dump(KERN_DEBUG, " front: ",
> -		       DUMP_PREFIX_OFFSET, 16, 1,
> -		       msg->front.iov_base, msg->front.iov_len, true);
> +	hex_dump_dbg("header: ",
> +		     DUMP_PREFIX_OFFSET, 16, 1,
> +		     &msg->hdr, sizeof(msg->hdr), true);
> +	hex_dump_dbg(" front: ",
> +		     DUMP_PREFIX_OFFSET, 16, 1,
> +		     msg->front.iov_base, msg->front.iov_len, true);

These are sensible, as there is no other guard and
the immediately preceding message uses pr_debug and so
these uses should not always be output.

Could you please not just do
s/print_hex_dump(KERN_DEBUG, /hex_dump_dbg(/g
and inspect each instance for appropriateness.



