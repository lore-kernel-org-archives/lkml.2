Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1K2UT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:19:58 -0500
Received: from smtp.outflux.net ([198.145.64.163]:32800 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab1K2UT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:19:57 -0500
Date: Tue, 29 Nov 2011 12:19:38 -0800
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111129201938.GP5169@outflux.net>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.912537377@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129191638.912537377@openvz.org>
Organization: Google
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:12:55PM +0400, Cyrill Gorcunov wrote:
> At restore time we need a mechanism to restore those values
> back and for this sake PR_SET_MM prctl code is introduced.
> 
> Note at moment this inteface is allowed for CAP_SYS_ADMIN
> only.

NAK from me; this needs more bounds checking. Though, yes, it absolutely
must be a privileged action since this is potentially very dangerous. Can
we invent something stronger than CAP_SYS_ADMIN? ;)

> @@ -1841,6 +1841,58 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
>  			else
>  				error = PR_MCE_KILL_DEFAULT;
>  			break;
> +		case PR_SET_MM: {
> +			struct mm_struct *mm;
> +			struct vm_area_struct *vma;
> +
> +			if (arg4 | arg5)
> +				return -EINVAL;
> +
> +			if (!capable(CAP_SYS_ADMIN))
> +				return -EPERM;
> +
> +			error = -ENOENT;
> +			mm = get_task_mm(current);
> +			if (!mm)
> +				return error;
> +
> +			down_read(&mm->mmap_sem);
> +			vma = find_vma(mm, arg3);
> +			if (!vma)
> +				goto out;

arg3 needs to be significantly more carefully validated. find_vma() doesn't
say that vm_start <= addr, only that vm_end > addr. This effectively
bypasses all the vma checks (mmap_min_addr, max process size, etc), with
some pretty crazy side-effects, I think.

-Kees

-- 
Kees Cook
