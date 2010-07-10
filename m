Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0GJBy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 21:54:29 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40383 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0GJBy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 21:54:27 -0400
Date: Sat, 10 Jul 2010 10:54:21 +0900
From: Simon Horman <horms@verge.net.au>
To: Patrick McHardy <kaber@trash.net>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
       netfilter-devel@vger.kernel.org,
       Malcolm Turnbull <malcolm@loadbalancer.org>,
       Wensong Zhang <wensong@linux-vs.org>,
       Julius Volz <julius.volz@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Hannes Eder <heder@google.com>
Subject: Re: [patch v2.3 3/4] IPVS: make FTP work with full NAT support
Message-ID: <20100710015420.GK5443@verge.net.au>
References: <20100704113246.562399500@vergenet.net>
 <20100704114808.932594876@vergenet.net>
 <4C3316F0.2030807@trash.net>
 <20100707065324.GC20424@verge.net.au>
 <4C373F48.8080504@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C373F48.8080504@trash.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 05:24:56PM +0200, Patrick McHardy wrote:
> Am 07.07.2010 08:53, schrieb Simon Horman:
> > On Tue, Jul 06, 2010 at 01:43:44PM +0200, Patrick McHardy wrote:
> >> Simon Horman wrote:
> >>> @@ -219,19 +358,23 @@ static int ip_vs_ftp_out(struct ip_vs_ap
> >>> 		buf_len = strlen(buf);
> >>> +		ct = nf_ct_get(skb, &ctinfo);
> >>> +		ret = nf_nat_mangle_tcp_packet(skb,
> >>> +					       ct,
> >>> +					       ctinfo,
> >>> +					       start-data,
> >>> +					       end-start,
> >>> +					       buf,
> >>> +					       buf_len);
> >>> +
> >>> +		if (ct && ct != &nf_conntrack_untracked)
> >> This does not make sense, you're already using the conntrack above
> >> in the call to nf_nat_mangle_tcp_packet(), so the check should
> >> probably happen before that. You also should be checking the
> >> return value of nf_nat_mangle_tcp_packet() before setting up the
> >> expectation.
> >>
> >>> +			ip_vs_expect_related(skb, ct, n_cp,
> >>> +					     IPPROTO_TCP, NULL, 0);
> > 
> > Good point. Is this better?
> > 
> > 		ct = nf_ct_get(skb, &ctinfo);
> > 		if (ct && !nf_ct_is_untracked()) {
> > 			ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
> > 						       start-data, end-start,
> > 						       buf, buf_len);
> > 			if (ret)
> > 				ip_vs_expect_related(skb, ct, n_cp,
> > 						     IPPROTO_TCP, NULL, 0);
> 
> Yes, that's better, although we're usually dropping packets
> when mangling fails. This can only happen under memory pressure,
> the assumption is that we might be able to properly mangle
> the packet when it is retransmitted.

I didn't notice this either, but ret will be end up being the return value
of ip_vs_ftp_out(), and if that is zero the packet will be dropped.

