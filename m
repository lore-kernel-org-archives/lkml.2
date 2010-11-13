Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0KMVi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 16:38:26 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:14271 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0KMViW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 16:38:22 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=37qdrPIVUooonMxFi2BWZ8DhoCRe+hJcgJuumZcJ4K8= c=1 sm=1
 a=2t8Q6URn5c0A:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=pGLkceISAAAA:8 a=VuuSF9hqZE5nSP-GydEA:9
 a=LiDzW7wfWwSwv8DxZT4A:7 a=A0Oa0wFDCHhNB-0PrQ_KMukKvA8A:4 a=CjuIK1q_8ugA:10
 a=MSl-tDqOz04A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH] fs: select: fix information leak to userspace
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20101112120834.33062900.akpm@linux-foundation.org>
Date: Sat, 13 Nov 2010 14:38:19 -0700
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com> <20101112120834.33062900.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-12, at 13:08, Andrew Morton wrote:
> On Wed, 10 Nov 2010 23:38:02 +0300
> Vasiliy Kulikov <segooon@gmail.com> wrote:
>> On some architectures __kernel_suseconds_t is int.
> 
> On sparc and parisc.  On all other architectures this patch is a waste
> of cycles.
> 
> --- a/fs/select.c~fs-select-fix-information-leak-to-userspace-fix
> +++ a/fs/select.c
> @@ -306,7 +306,8 @@ static int poll_select_copy_remaining(st
> 		rts.tv_sec = rts.tv_nsec = 0;
> 
> 	if (timeval) {
> -		memset(&rtv, 0, sizeof(rtv));
> +		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
> +			memset(&rtv, 0, sizeof(rtv));
> 		rtv.tv_sec = rts.tv_sec;
> 		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
> 
> _
> 
> 
> The `if' gets eliminated at compile time.  With this approach we add
> four bytes of text to the sparc64 build and zero bytes of text to the
> x86_64 build.

It's nice to have comments (or at least a good commit message) for unusual code like this, so that in the future it is clear when this kind of workaround can be removed (e.g. if the time_t is changed to always be a 64-bit value for Y2038 issues, even on 32-bit arches). 

Cheers, Andreas





