Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0CWRkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:40:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43152 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab0CWRkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nbj7NHgTVNjiFX7Qs8Vb6o+GLekl6sNTA7rbkrCV6z3qKLRCYebQY/f59puvRkWcS6
         Ap2PgazD5ZUuBKmRYG9ai/hQBGeoD2rr44tjuErQXiMDd0N8DGFjgIlw7Me6ud/BAoKB
         F6KluVxT2HNBmC+Q8uYCuTUo0eTG5pKygI2ps=
MIME-Version: 1.0
In-Reply-To: <1269316670.8599.101.camel@pasglop>
References: <201003221759.o2MHxEaj015546@hera.kernel.org>
	 <1269316670.8599.101.camel@pasglop>
Date: Tue, 23 Mar 2010 10:40:34 -0700
Message-ID: <7991c5481003231040u3479778dpcb27d9578383afc0@mail.gmail.com>
Subject: Re: ixgbe: Set IXGBE_RSC_CB(skb)->DMA field to zero after unmapping 
	the address
From: Malli <mchilakala@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 8:57 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2010-03-22 at 17:59 +0000, Linux Kernel Mailing List wrote:
>> Gitweb:     http://git.kernel.org/linus/fd3686a842717b890fbe3024b83a616c54d5dba0
>> Commit:     fd3686a842717b890fbe3024b83a616c54d5dba0
>> Parent:     936332b8e00103fc20eb7e915c9a3bcb2835a11a
>> Author:     Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>
>> AuthorDate: Fri Mar 19 04:41:33 2010 +0000
>> Committer:  David S. Miller <davem@davemloft.net>
>> CommitDate: Fri Mar 19 21:00:44 2010 -0700
>>
>>     ixgbe: Set IXGBE_RSC_CB(skb)->DMA field to zero after unmapping the address
>>
>>     As per Simon Horman's feedback set IXGBE_RSC_CB(skb)->dma to zero
>>     after unmapping HWRSC DMA address to avoid double freeing.
>>
>
> Note that this whole code is bogus :-) You cannot just assume that 0 is
> a invalid DMA address. It is not. In fact, while you can check if a
> dma_addr_t is invalid using dma_mapping_error(), the generic APIs
> don't provide you with a magic "bad" value you can use for what you are
> trying to do.
>
> Granted, I think we should make our iommu code reserve the first page
> for the sake of everybody's sanity and to avoid such pitfalls, but
> this code is wrong with today iommu implementations.
>
> Cheers,
> Ben.

Yes. I just realized that i can't assign a zero magic "bad" value. It is only
valid in x86/arm/m68k/alpha architecures and not in spark & PowerPC arch,
(it should be ~0). In some other architecutres it throws a BUG() on with
dma_mapping_error() checks. So the patch is not a total bogus in some
architectures :(.

May be it is best to create an internal FLAG in IXGBE_RSC_CB(skb)
which can be used to avoid this double freeing.
