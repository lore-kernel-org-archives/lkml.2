Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1LVGiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 01:38:14 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:57604 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab1LVGiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 01:38:11 -0500
Date: Thu, 22 Dec 2011 07:38:06 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Chris Boot <bootc@bootc.net>, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
Message-ID: <20111222063806.GP6348@secunet.com>
References: <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EF2117F.6000803@bootc.net>
 <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EF23BF2.4000601@bootc.net>
 <1324499332.2621.7.camel@edumazet-laptop>
 <1324500775.2621.9.camel@edumazet-laptop>
 <4EF2568C.6040006@bootc.net>
 <AEC29013-98F3-4A16-A88B-AD31C9E88EB8@bootc.net>
 <1324528656.2621.19.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1324528656.2621.19.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Dec 2011 06:38:06.0755 (UTC) FILETIME=[43778F30:01CCC074]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 05:37:36AM +0100, Eric Dumazet wrote:
> Le mercredi 21 décembre 2011 à 23:12 +0000, Chris Boot a écrit :
> > 
> > (gdb) list *ip_fragment+0x9d
> > 0xffffffff812a62e1 is in ip_fragment (include/net/dst.h:209).
> > 204		return dst_metric(dst, RTAX_FEATURES) & feature;
> > 205	}
> > 206	
> > 207	static inline u32 dst_mtu(const struct dst_entry *dst)
> > 208	{
> > 209		return dst->ops->mtu(dst);
> > 210	}
> > 211	
> > 212	/* RTT metrics are stored in milliseconds for user ABI, but used as jiffies */
> 
> This one is different, its not IPv6 related but IPv4 :
> 
> fake_dst_ops lacks a .mtu() field
> 
> Bug added in commit 618f9bc74a039da76 (net: Move mtu handling down to
> the protocol depended handlers)
> 

Before I did this patch, I changed the .default_mtu field of "struct dst_ops"
to .mtu and converted all users of default_mtu to mtu. fake_dst_ops never
had a default_mtu field, so I did not touch it. I guess this bug is arround
since fake_dst_ops exists. It's now just much easier to trigger as commit
618f9bc74a039da76 changed dst_mtu() to call dst->ops->mtu() unconditionally.
