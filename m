Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab0FQQT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:19:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:30242 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032Ab0FQQTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QTde+BkH5EWIheDEsVi6RTRJ07yoc0k4pmBZBSIxVGXDTVv7CO6iILNuE3VvFJflQp
         X/Y2paXjj7ag2b2Ip5KuEhsyXM7rL91jOqXbeFJbY9o643uUsfNoTsn+cHFrSlEcaWUD
         nNcNd9bNK0m1UFJS7LvrMO1fpVWPs1ACsz4XU=
Date: Thu, 17 Jun 2010 18:17:28 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
Message-ID: <20100617161728.GA2741@joi.lan>
References: <20100617134559.GA29824@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617134559.GA29824@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 03:45:59PM +0200, Dan Carpenter wrote:
> Commit 20413f27163 "x86, pat: Fix memory leak in free_memtype" added an
> error message in free_memtype() if rbt_memtype_erase() returns NULL.  
> The problem is that if CONFIG_X86_PAT is enabled, we use a different
> implimentation of rbt_memtype_erase() that always returns NULL.
> 
> I've modified rbt_memtype_erase() to return an ERR_PTR() on errors and 
> made free_memtype() check for that instead.
> 
> Addresses:  https://bugzilla.kernel.org/show_bug.cgi?id=16205
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

This patch is probably ok, but it does not address my bug.
I have CONFIG_X86_PAT=y, so rbt_memtype_erase does not always return NULL.
 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index acc15b2..81b7735 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -359,10 +359,10 @@ int free_memtype(u64 start, u64 end)
>  	entry = rbt_memtype_erase(start, end);
>  	spin_unlock(&memtype_lock);
>  
> -	if (!entry) {
> +	if (IS_ERR(entry)) {
>  		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
>  			current->comm, current->pid, start, end);
> -		return -EINVAL;
> +		return PTR_ERR(entry);
>  	}
>  
>  	kfree(entry);
> diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
> index f537087..90e5cbe 100644
> --- a/arch/x86/mm/pat_rbtree.c
> +++ b/arch/x86/mm/pat_rbtree.c
> @@ -236,8 +236,10 @@ struct memtype *rbt_memtype_erase(u64 start, u64 end)
>  	struct memtype *data;
>  
>  	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
> -	if (!data)
> +	if (!data) {
> +		data = ERR_PTR(-EINVAL);
>  		goto out;
> +	}
>  
>  	rb_erase(&data->rb, &memtype_rbroot);
>  out:
> 
> 
