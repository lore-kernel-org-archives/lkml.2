Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3ADVBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:01:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47062 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3ADVBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:01:05 -0500
Date: Fri, 4 Jan 2013 22:01:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 20/31] x86, kexec: replace ident_mapping_init and
 init_level4_page
Message-ID: <20130104210114.GA11611@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-21-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-21-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:40PM -0800, Yinghai Lu wrote:
>  static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
>  {
> +	struct x86_mapping_info info = {
> +		.alloc_pgt_page	= alloc_pgt_page,
> +		.context	= image,
> +		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
> +	};

This is leaving ->kernel_mapping uninitialized to contain a random,
previous stack value. I don't think we want that.

>  	unsigned long mstart, mend;
>  	pgd_t *level4p;
>  	int result;
>  	int i;
>  
>  	level4p = (pgd_t *)__va(start_pgtable);
> -	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
> +	clear_page(level4p);
> +	result = kernel_ident_mapping_init(&info, level4p,
> +						0, max_pfn << PAGE_SHIFT);
>  	if (result)
>  		return result;
>  
> @@ -225,7 +115,8 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
>  		mstart = image->segment[i].mem;
>  		mend   = mstart + image->segment[i].memsz;
>  
> -		result = ident_mapping_init(image, level4p, mstart, mend);
> +		result = kernel_ident_mapping_init(&info,
> +						 level4p, mstart, mend);
>  
>  		if (result)
>  			return result;
> -- 
> 1.7.10.4
> 
> 

-- 
Regards/Gruss,
Boris.
