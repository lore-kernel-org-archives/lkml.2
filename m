Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1FTTIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:08:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:36500 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab1FTTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:08:39 -0400
Message-ID: <4DFF9A08.5090609@windriver.com>
Date: Mon, 20 Jun 2011 15:05:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
        Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Graf <tgraf@infradead.org>, Moritz Muehlenhoff <jmm@debian.org>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        <stable-review@kernel.org>, <alan@lxorguk.ukuu.org.uk>
Subject: Re: [stable] [68/74] inet_diag: Make sure we actually run the same
 bytecode we audited.
References: <20110413155150.306533092@clark.kroah.org>
In-Reply-To: <20110413155150.306533092@clark.kroah.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-13 11:51 AM, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.

This introduces new compile warnings, albeit reasonably harmless ones:

net/ipv4/inet_diag.c: In function ‘inet_csk_diag_dump’:
net/ipv4/inet_diag.c:496:10: warning: passing argument 1 of ‘nlmsg_find_attr’ discards qualifiers from pointer target type
include/net/netlink.h:387:30: note: expected ‘struct nlmsghdr *’ but argument is of type ‘const struct nlmsghdr *’

and more instances of the same.  Grabbing the following commit in
conjunction with this existing one fixes it to be quiet again.

commit 6b8c92ba07287578718335ce409de8e8d7217e40
Author: Nelson Elhage <nelhage@ksplice.com>
Date:   Wed Nov 3 16:35:40 2010 +0000

    netlink: Make nlmsg_find_attr take a const nlmsghdr*.
    
    This will let us use it on a nlmsghdr stored inside a netlink_callback.
    
    Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks,
Paul.


> 
> ------------------
> 
> From: Nelson Elhage <nelhage@ksplice.com>
> 
> commit 22e76c849d505d87c5ecf3d3e6742a65f0ff4860 upstream.
> 
> We were using nlmsg_find_attr() to look up the bytecode by attribute when
> auditing, but then just using the first attribute when actually running
> bytecode. So, if we received a message with two attribute elements, where only
> the second had type INET_DIAG_REQ_BYTECODE, we would validate and run different
> bytecode strings.
> 
> Fix this by consistently using nlmsg_find_attr everywhere.
> 
> Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> Signed-off-by: Thomas Graf <tgraf@infradead.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [jmm: Slightly adapted to apply against 2.6.32]
> Cc: Moritz Muehlenhoff <jmm@debian.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> ---
>  net/ipv4/inet_diag.c |   27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -489,9 +489,11 @@ static int inet_csk_diag_dump(struct soc
>  {
>  	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
>  
> -	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
> +	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
>  		struct inet_diag_entry entry;
> -		struct rtattr *bc = (struct rtattr *)(r + 1);
> +		const struct nlattr *bc = nlmsg_find_attr(cb->nlh,
> +							  sizeof(*r),
> +							  INET_DIAG_REQ_BYTECODE);
>  		struct inet_sock *inet = inet_sk(sk);
>  
>  		entry.family = sk->sk_family;
> @@ -511,7 +513,7 @@ static int inet_csk_diag_dump(struct soc
>  		entry.dport = ntohs(inet->dport);
>  		entry.userlocks = sk->sk_userlocks;
>  
> -		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
> +		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
>  			return 0;
>  	}
>  
> @@ -526,9 +528,11 @@ static int inet_twsk_diag_dump(struct in
>  {
>  	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
>  
> -	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
> +	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
>  		struct inet_diag_entry entry;
> -		struct rtattr *bc = (struct rtattr *)(r + 1);
> +		const struct nlattr *bc = nlmsg_find_attr(cb->nlh,
> +							  sizeof(*r),
> +							  INET_DIAG_REQ_BYTECODE);
>  
>  		entry.family = tw->tw_family;
>  #if defined(CONFIG_IPV6) || defined (CONFIG_IPV6_MODULE)
> @@ -547,7 +551,7 @@ static int inet_twsk_diag_dump(struct in
>  		entry.dport = ntohs(tw->tw_dport);
>  		entry.userlocks = 0;
>  
> -		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
> +		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
>  			return 0;
>  	}
>  
> @@ -617,7 +621,7 @@ static int inet_diag_dump_reqs(struct sk
>  	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  	struct listen_sock *lopt;
> -	struct rtattr *bc = NULL;
> +	const struct nlattr *bc = NULL;
>  	struct inet_sock *inet = inet_sk(sk);
>  	int j, s_j;
>  	int reqnum, s_reqnum;
> @@ -637,8 +641,9 @@ static int inet_diag_dump_reqs(struct sk
>  	if (!lopt || !lopt->qlen)
>  		goto out;
>  
> -	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
> -		bc = (struct rtattr *)(r + 1);
> +	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
> +		bc = nlmsg_find_attr(cb->nlh, sizeof(*r),
> +				     INET_DIAG_REQ_BYTECODE);
>  		entry.sport = inet->num;
>  		entry.userlocks = sk->sk_userlocks;
>  	}
> @@ -671,8 +676,8 @@ static int inet_diag_dump_reqs(struct sk
>  					&ireq->rmt_addr;
>  				entry.dport = ntohs(ireq->rmt_port);
>  
> -				if (!inet_diag_bc_run(RTA_DATA(bc),
> -						    RTA_PAYLOAD(bc), &entry))
> +				if (!inet_diag_bc_run(nla_data(bc),
> +						      nla_len(bc), &entry))
>  					continue;
>  			}
>  
> 
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
> 
