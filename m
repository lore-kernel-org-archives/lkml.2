Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab0GFLnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:43:46 -0400
Received: from stinky.trash.net ([213.144.137.162]:65085 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab0GFLno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:43:44 -0400
Message-ID: <4C3316F0.2030807@trash.net>
Date: Tue, 06 Jul 2010 13:43:44 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
       netfilter-devel@vger.kernel.org,
       Malcolm Turnbull <malcolm@loadbalancer.org>,
       Wensong Zhang <wensong@linux-vs.org>,
       Julius Volz <julius.volz@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Hannes Eder <heder@google.com>
Subject: Re: [patch v2.3 3/4] IPVS: make FTP work with full NAT support
References: <20100704113246.562399500@vergenet.net> <20100704114808.932594876@vergenet.net>
In-Reply-To: <20100704114808.932594876@vergenet.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> @@ -219,19 +358,23 @@ static int ip_vs_ftp_out(struct ip_vs_ap
>  
>  		buf_len = strlen(buf);
>  
> +		ct = nf_ct_get(skb, &ctinfo);
> +		ret = nf_nat_mangle_tcp_packet(skb,
> +					       ct,
> +					       ctinfo,
> +					       start-data,
> +					       end-start,
> +					       buf,
> +					       buf_len);
> +
> +		if (ct && ct != &nf_conntrack_untracked)
>   
This does not make sense, you're already using the conntrack above
in the call to nf_nat_mangle_tcp_packet(), so the check should
probably happen before that. You also should be checking the
return value of nf_nat_mangle_tcp_packet() before setting up the
expectation.

> +			ip_vs_expect_related(skb, ct, n_cp,
> +					     IPPROTO_TCP, NULL, 0);

