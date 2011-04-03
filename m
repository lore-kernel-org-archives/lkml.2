Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1DCSzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 14:55:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1DCSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 14:55:31 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=wom5GMh1gUkA:10 a=2CNd72YyuroA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=ybZZDoGAAAAA:8 a=VnNF1IyMAAAA:8 a=fxJcL_dCAAAA:8 a=Z4Rwk6OoAAAA:8 a=n-EpmKeHZulskYzUyDcA:9 a=dJKWLJ7rVRdC0mBRZ6sA:7 a=CjuIK1q_8ugA:10 a=qIVjreYYsbEA:10 a=2eKvNQJKnqYA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Sun, 3 Apr 2011 13:55:29 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: ntl@pobox.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 03/10] Introduce has_locks_with_owner() helper
Message-ID: <20110403185529.GB15044@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-4-git-send-email-ntl@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298936432-29607-4-git-send-email-ntl@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting ntl@pobox.com (ntl@pobox.com):
> From: Nathan Lynch <ntl@pobox.com>
> 
> Support for file locks is in the works, but until that is done
> checkpoint needs to fail when an open file has locks.
> 
> Based on original "find_locks_with_owner" patch by Dave Hansen.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> [ntl: changed name and return type to clearly express semantics]
> Signed-off-by: Nathan Lynch <ntl@pobox.com>

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/locks.c         |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |    6 ++++++
>  2 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 8729347..961e17f 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2037,6 +2037,41 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
>  
>  EXPORT_SYMBOL(locks_remove_posix);
>  
> +bool has_locks_with_owner(struct file *filp, fl_owner_t owner)
> +{
> +	struct inode *inode = filp->f_path.dentry->d_inode;
> +	struct file_lock **inode_fl;
> +	bool ret = false;
> +
> +	lock_flocks();
> +	for_each_lock(inode, inode_fl) {
> +		struct file_lock *fl = *inode_fl;
> +		/*
> +		 * We could use posix_same_owner() along with a 'fake'
> +		 * file_lock.  But, the fake file will never have the
> +		 * same fl_lmops as the fl that we are looking for and
> +		 * posix_same_owner() would just fall back to this
> +		 * check anyway.
> +		 */
> +		if (IS_POSIX(fl)) {
> +			if (fl->fl_owner == owner) {
> +				ret = true;
> +				break;
> +			}
> +		} else if (IS_FLOCK(fl) || IS_LEASE(fl)) {
> +			if (fl->fl_file == filp) {
> +				ret = true;
> +				break;
> +			}
> +		} else {
> +			WARN(1, "unknown file lock type, fl_flags: %x",
> +				fl->fl_flags);
> +		}
> +	}
> +	unlock_flocks();
> +	return ret;
> +}
> +
>  /*
>   * This function is called on the last close of an open file.
>   */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 090f0ea..315ded4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1138,6 +1138,7 @@ extern void locks_remove_posix(struct file *, fl_owner_t);
>  extern void locks_remove_flock(struct file *);
>  extern void locks_release_private(struct file_lock *);
>  extern void posix_test_lock(struct file *, struct file_lock *);
> +extern bool has_locks_with_owner(struct file *filp, fl_owner_t owner);
>  extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
>  extern int posix_lock_file_wait(struct file *, struct file_lock *);
>  extern int posix_unblock_lock(struct file *, struct file_lock *);
> @@ -1208,6 +1209,11 @@ static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
>  	return;
>  }
>  
> +static inline bool has_locks_with_owner(struct file *filp, fl_owner_t owner)
> +{
> +	return false;
> +}
> +
>  static inline void locks_remove_flock(struct file *filp)
>  {
>  	return;
> -- 
> 1.7.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
