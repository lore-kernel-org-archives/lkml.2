Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0GGGx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 02:53:29 -0400
Received: from koto.vergenet.net ([210.128.90.7]:50245 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab0GGGx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 02:53:27 -0400
Date: Wed, 7 Jul 2010 15:53:24 +0900
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
Message-ID: <20100707065324.GC20424@verge.net.au>
References: <20100704113246.562399500@vergenet.net>
 <20100704114808.932594876@vergenet.net>
 <4C3316F0.2030807@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3316F0.2030807@trash.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 01:43:44PM +0200, Patrick McHardy wrote:
> Simon Horman wrote:
> >@@ -219,19 +358,23 @@ static int ip_vs_ftp_out(struct ip_vs_ap
> > 		buf_len = strlen(buf);
> >+		ct = nf_ct_get(skb, &ctinfo);
> >+		ret = nf_nat_mangle_tcp_packet(skb,
> >+					       ct,
> >+					       ctinfo,
> >+					       start-data,
> >+					       end-start,
> >+					       buf,
> >+					       buf_len);
> >+
> >+		if (ct && ct != &nf_conntrack_untracked)
> This does not make sense, you're already using the conntrack above
> in the call to nf_nat_mangle_tcp_packet(), so the check should
> probably happen before that. You also should be checking the
> return value of nf_nat_mangle_tcp_packet() before setting up the
> expectation.
> 
> >+			ip_vs_expect_related(skb, ct, n_cp,
> >+					     IPPROTO_TCP, NULL, 0);

Good point. Is this better?

		ct = nf_ct_get(skb, &ctinfo);
		if (ct && !nf_ct_is_untracked()) {
			ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
						       start-data, end-start,
						       buf, buf_len);
			if (ret)
				ip_vs_expect_related(skb, ct, n_cp,
						     IPPROTO_TCP, NULL, 0);
		}

