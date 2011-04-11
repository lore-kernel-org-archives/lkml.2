Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1DKNgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 09:36:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52841 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1DKNgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 09:36:04 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=wom5GMh1gUkA:10 a=E9nxKCRpsdYA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=tmtSDGaQAAAA:8 a=UPoBF927PvZLZBnHicoA:9 a=CjuIK1q_8ugA:10 a=jkObVMfX7fAA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 11 Apr 2011 08:36:02 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Rob Landley <rlandley@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Tim Spriggs <tims@uahirise.org>, Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 3/3] Compare namespaces when comparing addresses in
 auth_unix cache.
Message-ID: <20110411133602.GA5321@hallyn.com>
References: <4D9431B3.2070305@parallels.com>
 <20110405034641.GC6764@hallyn.com>
 <4D9F24F2.9020603@parallels.com>
 <4DA30222.5040902@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA30222.5040902@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rob Landley (rlandley@parallels.com):
> On 04/08/2011 10:08 AM, Rob Landley wrote:
> > On 04/04/2011 10:46 PM, Serge E. Hallyn wrote:
> >> Does this need to take a reference?  Or is there no way for an
> >> entry to outlive its netns?  It sort of looks like
> >> svcauth_unix_info_release will ensure that doesn't happen, but
> >> I'm not convinced because other parts of the kernel can get
> >> to ip_map_init through the struct cache_detail.
> > 
> > When I wrote this I thought the transport's get_net() and put_net()
> > would pin it, but after re-reading, the sunrpc code is disgustingly
> > convoluted enough that I can't easily reconstruct my earlier reasoning.
> >  I'll add a get_net() and put_net() just to not have to worry about it.
> 
> Ah-ha!
> 
> Stanislav Kinsbursky helped me reconstruct some of the reasoning: we
> don't need to take a reference because we never actually dereference the
> struct net *, all we do is feed them to net_eq() which just compares the
> pointers for equality.  (The inline function exists so it can compile to
> a constant "return 1" when configured out.)
> 
> So if the network context did go away (which still shouldn't happen
> between the rpc_xprt and the struct nfs_client having references to it)
> we still wouldn't have a use-after-free problem because we're not
> looking at the memory, just the pointer.

Besides use-after-free, the other concern is an invalid net_eq()
result due to the * being re-used for a new netns.  I assume that's
deemed "super-duper impossible" again bc of the rpc_xprt/nfs_client
references to it?

> So I shouldn't need to add get_net() and put_net() to the cache.  Sound
> about right?

thanks,
-serge
