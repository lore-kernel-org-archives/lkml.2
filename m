Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab1BZI5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 03:57:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1BZI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 03:57:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X0ERcVSYKtuqj4plHfPHIR35mnreHvs6Wqpil95cDcaH6O4tmLPkRCwzm5I+h0Vz4W
         YvheJ30zwrGve6dRNKZIZIvJCu4GElTZbPPZMyEb12Gtcn0+VD5iam1BlMGKghUENBr2
         CHYUHTE83fcnD6XUfzPKL64It7OxLUQKLaCac=
Date: Sat, 26 Feb 2011 09:57:37 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86,mm,64bit: Round up memory boundary for
 init_memory_mapping_high()
Message-ID: <20110226085737.GT24828@htj.dyndns.org>
References: <20110223171945.GI26065@htj.dyndns.org>
 <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
 <20110223210326.GB27738@atj.dyndns.org>
 <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
 <20110224091557.GD7840@htj.dyndns.org>
 <4D674A33.8000809@kernel.org>
 <20110225111606.GG24828@htj.dyndns.org>
 <4D680EA4.6050402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D680EA4.6050402@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 12:18:44PM -0800, Yinghai Lu wrote:
> >  Or better, can you please make that explicit?
> > It currently depends on memories being registered in ascending address
> > order, right?  The memblock code already is NUMA aware, I think it
> > would be far better to make the node affine part explicit.
> 
> yes, memblock is numa aware after memblock_x86_register_active_regions().
> and it rely on early_node_map[].
> 
> do you mean let init_memory_mapping to take node id like setup_node_bootmem?
> so find_early_table_space could take nodeid instead of tbl_end? 

Yeap.

> > @@ -550,8 +548,12 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
> >  			end = max(mi->blk[i].end, end);
> >  		}
> >  
> > -		if (start < end)
> > +		if (start < end) {
> > +			init_memory_mapping(
> > +			  ALIGN_DOWN_TO_MAX_MAP_SIZE_AND_CONVERT_TO_PFN(start),
> > +			  ALIGN_UP_SIMILARY_BUT_DONT_GO_OVER_MAX_PFN(end));
> >  			setup_node_bootmem(nid, start, end);
> > +		}
> will have problem with cross node conf. like 0-4g, 8-12g on node0, 4g-8g, 12g-16g on node1.

And how common are they?  This whole cruft is basically meaningless if
1GiB mapping is supported, IOW, basically on all AMD 64s and all
post-nehalem intels.  Why not just cite the limitation in the comment
and stick to something simple?

Thanks.

-- 
tejun
