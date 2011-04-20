Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1DTVmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:42:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1DTVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kBv3U6iiG4EeWBlKjmuWqcYyjI0n7ycg+5SEeREfYsjlFxIGn0YBJKkEvDc3w1R6gs
         GzaV0ZTHYOJftFQI8hSw==
Date: Wed, 20 Apr 2011 14:42:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
        linux-arch@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <alpine.DEB.2.00.1104201018360.9266@router.home>
Message-ID: <alpine.DEB.2.00.1104201437180.31768@chino.kir.corp.google.com>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com>  <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>  <20110420161615.462D.A69D9226@jp.fujitsu.com>  <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>  <20110420112020.GA31296@parisc-linux.org>
 <BANLkTim+m-v-4k17HUSOYSbmNFDtJTgD6g@mail.gmail.com>  <1303308938.2587.8.camel@mulgrave.site>  <alpine.DEB.2.00.1104200943580.9266@router.home> <1303311779.2587.19.camel@mulgrave.site> <alpine.DEB.2.00.1104201018360.9266@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Christoph Lameter wrote:

> There is barely any testing going on at all of this since we have had this
> issue for more than 5 years and have not noticed it. The absence of bug
> reports therefore proves nothing. Code inspection of the VM shows
> that this is an issue that arises in multiple subsystems and that we have
> VM_BUG_ONs in the page allocator that should trigger for these situations.
> 
> Usage of DISCONTIGMEM and !NUMA is not safe and should be flagged as such.
> 

We don't actually have any bug reports in front of us that show anything 
else in the VM other than slub has issues with this configuration, so 
marking them as broken is probably premature.  The parisc config that 
triggered this debugging enables CONFIG_SLAB by default, so it probably 
has gone unnoticed just because nobody other than James has actually tried 
it on hppa64.

Let's see if KOSAKI-san's fixes to Kconfig (even though I'd prefer the 
simpler and implicit "config NUMA def_bool ARCH_DISCONTIGMEM_ENABLE" over 
his config NUMA) and my fix to parisc to set the bit in N_NORMAL_MEMORY 
so that CONFIG_SLUB initializes kmem_cache_node correctly works and then 
address issues in the core VM as they arise.  Presumably someone has been 
running DISCONTIGMEM on hppa64 in the past five years without issues with 
defconfig, so the issue here may just be slub.
