Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0GIPZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:25:04 -0400
Received: from stinky.trash.net ([213.144.137.162]:38848 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0GIPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:25:00 -0400
Message-ID: <4C373F48.8080504@trash.net>
Date: Fri, 09 Jul 2010 17:24:56 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
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
References: <20100704113246.562399500@vergenet.net> <20100704114808.932594876@vergenet.net> <4C3316F0.2030807@trash.net> <20100707065324.GC20424@verge.net.au>
In-Reply-To: <20100707065324.GC20424@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.07.2010 08:53, schrieb Simon Horman:
> On Tue, Jul 06, 2010 at 01:43:44PM +0200, Patrick McHardy wrote:
>> Simon Horman wrote:
>>> @@ -219,19 +358,23 @@ static int ip_vs_ftp_out(struct ip_vs_ap
>>> 		buf_len = strlen(buf);
>>> +		ct = nf_ct_get(skb, &ctinfo);
>>> +		ret = nf_nat_mangle_tcp_packet(skb,
>>> +					       ct,
>>> +					       ctinfo,
>>> +					       start-data,
>>> +					       end-start,
>>> +					       buf,
>>> +					       buf_len);
>>> +
>>> +		if (ct && ct != &nf_conntrack_untracked)
>> This does not make sense, you're already using the conntrack above
>> in the call to nf_nat_mangle_tcp_packet(), so the check should
>> probably happen before that. You also should be checking the
>> return value of nf_nat_mangle_tcp_packet() before setting up the
>> expectation.
>>
>>> +			ip_vs_expect_related(skb, ct, n_cp,
>>> +					     IPPROTO_TCP, NULL, 0);
> 
> Good point. Is this better?
> 
> 		ct = nf_ct_get(skb, &ctinfo);
> 		if (ct && !nf_ct_is_untracked()) {
> 			ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
> 						       start-data, end-start,
> 						       buf, buf_len);
> 			if (ret)
> 				ip_vs_expect_related(skb, ct, n_cp,
> 						     IPPROTO_TCP, NULL, 0);

Yes, that's better, although we're usually dropping packets
when mangling fails. This can only happen under memory pressure,
the assumption is that we might be able to properly mangle
the packet when it is retransmitted.
