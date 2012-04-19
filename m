Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2DSTUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:20:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab2DSTUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:20:48 -0400
Date: Thu, 19 Apr 2012 21:20:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: khlebnikov@openvz.org, gorcunov@openvz.org, keescook@chromium.org,
        kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, tj@kernel.org,
        xemul@parallels.com, linux-kernel@vger.kernel.org
Subject: Re: +
	c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
	num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419192005.GA13558@redhat.com>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Andrew Morton wrote:
>
> From: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Subject: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal
>
> [ fix for "c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2" from mm tree ]
>
> After removing mm->num_exe_file_vmas kernel keeps mm->exe_file until final
> mmput(), it never becomes NULL while task is alive.
>
> We can check for other mapped files in mm instead of checking
> mm->num_exe_file_vmas, and mark mm with flag MMF_EXE_FILE_CHANGED in order
> to forbid second changing of mm->exe_file.

I lost the track a long ago.

Just one question, what does this "forbid second changing" actually mean?

>  	 * The symlink can be changed only once, just to disallow arbitrary
>  	 * transitions malicious software might bring in. This means one
>  	 * could make a snapshot over all processes running and monitor
>  	 * /proc/pid/exe changes to notice unusual activity if needed.
>  	 */
> -	down_write(&mm->mmap_sem);
> -	if (likely(!mm->exe_file))
> -		set_mm_exe_file(mm, exe_file);
> -	else
> -		err = -EBUSY;
> +	err = -EPERM;
> +	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
> +		goto exit_unlock;
> +
> +	set_mm_exe_file(mm, exe_file);
> +exit_unlock:

OK, I am not arguing, but looking at this code I suspect that you
also want to forbid the second change after fork too?

If yes, then you probably need to include MMF_EXE_FILE_CHANGED in
MMF_INIT_MASK.

But at the same time, then it should be probably cleared somewhere
in bprm_mm_init() paths.

Oleg.

