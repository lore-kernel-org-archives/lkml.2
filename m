Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab2L3WD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 17:03:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab2L3WDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 17:03:24 -0500
Message-ID: <1356904987.9725.10.camel@localhost>
Subject: Re: [PATCH] prctl: fix validation of an address
From: Eric Paris <eparis@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>
Date: Sun, 30 Dec 2012 17:03:07 -0500
In-Reply-To: <1356778810-20879-1-git-send-email-avagin@openvz.org>
References: <1356778810-20879-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-29 at 15:00 +0400, Andrey Vagin wrote:
> The address should be bigger than dac_mmap_min_addr, because
> a process with CAP_RAWIO can map a vma bellow mmap_min_addr.

NAK

This doesn't make any sense.  dac_mmap_min_addr should ONLY be used in
security/min_addr.c and security/commoncap.c.  Period.  You should not
be allowed to circumvent LSM protections.  Maybe you are missing that
mmap_min_addr = max(dac_mmap_min_addr, CONFIG_LSM_MMAP_MIN_ADDR)  ?

But this patch is absolutely unacceptable.  Maybe you can help me
understand what problem you had and what you were hoping for?

-Eric
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  kernel/sys.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 265b376..e0e1bbd 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1868,7 +1868,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
>  	if (opt == PR_SET_MM_EXE_FILE)
>  		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
>  
> -	if (addr >= TASK_SIZE || addr < mmap_min_addr)
> +	if (addr >= TASK_SIZE || addr < dac_mmap_min_addr)
>  		return -EINVAL;
>  
>  	error = -EINVAL;


