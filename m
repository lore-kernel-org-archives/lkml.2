Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1BVKhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:37:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61479 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1BVKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CZT0N056Z3E/A4Q6Wyt1aWTctYKKsOidMVJoic4Y1E5NWub8V+Vi6wxf2dZyOprBoG
         9JbLsEyrNsqCR8fOhVh4/o6dQ9DiCaXj5OvITNgvX79iW3dPAZN5VOuCIqq2ptHpys02
         6hUGr9r9j0YRnk2lmpeU44sJSoDdL2v1GowlU=
Date: Tue, 22 Feb 2011 11:36:53 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for
 early_node_mem()
Message-ID: <20110222103653.GX31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC184.6000505@kernel.org>
 <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com>
 <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com>
 <20110221094318.GG31267@htj.dyndns.org>
 <20110221104443.GJ31267@htj.dyndns.org>
 <4D62CAE4.4040207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D62CAE4.4040207@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 12:28:20PM -0800, Yinghai Lu wrote:
> > Hmmm... thinking more about it, there actually is a difference.
> > Depending on configuration, the new code allows node_data[] to be
> > allocated below DMA boundary.  I think we need to keep the first if().
> > Areas crossing the boundaries is okay, in fact, the original code
> > already allowed that when the NUMA affine allocation failed; however,
> > node_data[] was never allowed below the DMA boundary and I think it
> > shouldn't be.
> 
> No. when those code were added before. it was bottom-up allocation from e820.
> Now with new memblock allocation. it will always try to do top down. 
> will have no chance to get under DMA normally.
> except your first node only has < 16M.

NODE_MIN_SIZE is 4M.  Crazy SRAT isn't unheard of.  Even on a sane
configuration, given how the physical meomory is laid out, an emulated
NUMA node can easily end up with only <= 16M memory.

Also, your patch makes the code inconsistent.  The NUMA aware
allocation doesn't put any restriction but if it fails we do generic
allocation with DMA boundary limit.

So, don't remove the DMA boundary limit.  Even if the current code
wouldn't result in that (and the current code CAN), it is a good
sanity check to have because you don't want memory map under 16MiB no
matter what.

Thanks.

-- 
tejun
