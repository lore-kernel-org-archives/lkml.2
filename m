Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1AGAmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:42:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab1AGAmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:42:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NV4wiOEsMiNu1QD1Wm44UqyMW+e5nsYKqZ1HXRIm/1l/jmKvXhoJzDzhzOsJTJxjsC
         Y0GEhNVyNosl8k0508/Q==
Date: Thu, 6 Jan 2011 16:42:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: mm-commits@vger.kernel.org, mhocko@suse.cz, caiqian@redhat.com,
        nacc@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: + hugetlb-handle-nodemask_alloc-failure-correctly.patch added
 to -mm tree
In-Reply-To: <201101062039.p06Kd3ZL014025@imap1.linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1101061641370.9419@chino.kir.corp.google.com>
References: <201101062039.p06Kd3ZL014025@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, akpm@linux-foundation.org wrote:

> diff -puN mm/hugetlb.c~hugetlb-handle-nodemask_alloc-failure-correctly mm/hugetlb.c
> --- a/mm/hugetlb.c~hugetlb-handle-nodemask_alloc-failure-correctly
> +++ a/mm/hugetlb.c
> @@ -1374,14 +1374,19 @@ static ssize_t nr_hugepages_store_common
>  	struct hstate *h;
>  	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
>  
> +	if (!nodes_allowed) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
>  	err = strict_strtoul(buf, 10, &count);
>  	if (err)
> -		goto out;
> +		goto out_free_mask;
>  
>  	h = kobj_to_hstate(kobj, &nid);
>  	if (h->order >= MAX_ORDER) {
>  		err = -EINVAL;
> -		goto out;
> +		goto out_free_mask;
>  	}
>  
>  	if (nid == NUMA_NO_NODE) {
> @@ -1409,8 +1414,9 @@ static ssize_t nr_hugepages_store_common
>  		NODEMASK_FREE(nodes_allowed);
>  
>  	return len;
> -out:
> +out_free_mask:
>  	NODEMASK_FREE(nodes_allowed);
> +out:
>  	return err;
>  }
>  
> @@ -1886,6 +1892,12 @@ static int hugetlb_sysctl_handler_common
>  	if (write) {
>  		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
>  						GFP_KERNEL | __GFP_NORETRY);
> +
> +		if (!nodes_allowed) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +
>  		if (!(obey_mempolicy &&
>  			       init_nodemask_of_mempolicy(nodes_allowed))) {
>  			NODEMASK_FREE(nodes_allowed);

This patch is wrong, both functions may handle a NULL nodes_allowed, which 
is why the __GFP_NORETRY is explicitly part of the gfp mask.

In both functions, init_nodemask_of_mempolicy() will immediately return 
false if the mask is NULL.  If so, it is set to node_states[N_HIGH_MEMORY] 
in the caller and we're careful to avoid calling the NODMASK_FREE() in 
that case.  They are carefully coded in this way so they operate over all 
nodes with memory rather than failing with -ENOMEM.

 [ On a seperate topic, all users of NODEMASK_ALLOC() that may gracefully 
   fail and have error handling should also use __GFP_NORETRY, such as in
   all the cpuset users. ]
