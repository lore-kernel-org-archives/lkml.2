Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab1CCWAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:00:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:27033 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab1CCWAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mM+NP0GeJNbmKKAVgTb6ad3ZwVPC777OfqFo/3BtlilJabYzpz6tVLryIT9AE4padg
         eWbfdpUjDfGh2GOWJhcg==
Date: Thu, 3 Mar 2011 14:00:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        yinghai@kernel.org, brgerst@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
In-Reply-To: <4D700B93.2080807@gmail.com>
Message-ID: <alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org> <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com> <20110221083511.GC31267@htj.dyndns.org> <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
 <4D700B93.2080807@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Cyrill Gorcunov wrote:

> > This patch cleans initmem_init() so that it is more readable and doesn't
> > use an unnecessary array of function pointers to convolute the flow of
> > the code.  It also makes it obvious that dummy_numa_init() will always
> > succeed (and documents that requirement) so that the existing BUG() is
> > never actually reached.
> > 
> > No functional change.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  arch/x86/mm/numa_64.c |   92 ++++++++++++++++++++++++++++---------------------
> >  1 files changed, 53 insertions(+), 39 deletions(-)
> > 
> ...
> > +void __init initmem_init(void)
> > +{
> > +	int ret;
> >  
> > -			if (nid == NUMA_NO_NODE)
> > -				continue;
> > -			if (!node_online(nid))
> > -				numa_clear_node(j);
> > -		}
> > -		numa_init_array();
> > -		return;
> > +	if (!numa_off) {
> > +#ifdef CONFIG_ACPI_NUMA
> > +		ret = numa_init(x86_acpi_numa_init);
> > +		if (!ret)
> > +			return;
> > +#endif
> > +#ifdef CONFIG_AMD_NUMA
> > +		ret = numa_init(amd_numa_init);
> > +		if (!ret)
> > +			return;
> > +#endif
> >  	}
> > -	BUG();
> > +
> > +	numa_init(dummy_numa_init);
> >  }
> >  
> >  unsigned long __init numa_free_all_bootmem(void)
> 
> Divid, I suspect it's due to diff format and we still need "ret" here, right?
> 

Not sure what you mean.  "ret" is a temporary variable to test the return 
values of numa_init() and return from initmem_init() on success.
