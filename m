Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0IVTuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:50:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0IVTuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:50:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Y3m52sWPA2Ym0x4eJJLk3irQXH9dLa7gY+mAaZI8dl8zsR5EG19I2UKtkl7JhvWan
	mHuO41YVdEFTY7KF4tkZQ==
Date: Wed, 22 Sep 2010 12:49:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] sysfs: only access bin file vm_ops with the active
 lock
In-Reply-To: <m1vd6026gg.fsf@fess.ebiederm.org>
Message-ID: <alpine.LSU.2.00.1009221231251.29127@tigran.mtv.corp.google.com>
References: <m1aanc3l3e.fsf@fess.ebiederm.org> <m1vd6026gg.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Eric W. Biederman wrote:
> 
> bb->vm_ops is a cached copy of the vm_ops of the underlying
> sysfs bin file, which means that after sysfs_bin_remove_file
> completes it is only longer valid to deference bb->vm_ops.
> 
> So move all of the tests of bb->vm_ops inside of where
> we hold the sysfs active lock.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Good point.  There's a couple of cases (the ones below) where you've
changed the return value from success to failure when the entry point
didn't exist for an object that is no longer active; but on reflection,
I accept that's just not worth worrying about.

Hugh

> @@ -219,13 +222,12 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (!bb->vm_ops)
>  		return VM_FAULT_SIGBUS;
>  
> -	if (!bb->vm_ops->page_mkwrite)
> -		return 0;
> -
>  	if (!sysfs_get_active(attr_sd))
>  		return VM_FAULT_SIGBUS;
>  
> -	ret = bb->vm_ops->page_mkwrite(vma, vmf);
> +	ret = 0;
> +	if (bb->vm_ops->page_mkwrite)
> +		ret = bb->vm_ops->page_mkwrite(vma, vmf);
>  
>  	sysfs_put_active(attr_sd);
>  	return ret;

> @@ -259,13 +263,15 @@ static int bin_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
>  	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
>  	int ret;
>  
> -	if (!bb->vm_ops || !bb->vm_ops->set_policy)
> +	if (!bb->vm_ops)
>  		return 0;
>  
>  	if (!sysfs_get_active(attr_sd))
>  		return -EINVAL;
>  
> -	ret = bb->vm_ops->set_policy(vma, new);
> +	ret = 0;
> +	if (bb->vm_ops->set_policy)
> +		ret = bb->vm_ops->set_policy(vma, new);
>  
>  	sysfs_put_active(attr_sd);
>  	return ret;
