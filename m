Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab2EQXvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:51:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933487Ab2EQXvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:51:39 -0400
Message-ID: <4FB58EFD.7010302@zytor.com>
Date: Thu, 17 May 2012 16:51:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com>
In-Reply-To: <1337292816-10839-9-git-send-email-hjl.tools@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 03:13 PM, H.J. Lu wrote:
> From: "H.J. Lu" <hjl.tools@gmail.com>
> 
> Replace unsigned long with __kernel_ulong_t in struct msqid64_ds for
> user space.  Don't change unsigned long when __BITS_PER_LONG != 64
> since __kernel_ulong_t == unsigned long in this case.
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>

This patch and the one before it seems to have another problem: we
currently define __BITS_PER_LONG as:

#ifdef __x86_64__
# define __BITS_PER_LONG 64
#else
# define __BITS_PER_LONG 32
#endif

... which means __BITS_PER_LONG == 64 on x86-64.  This seems wrong.  The
result would seem to be that the padding members around __kernel_time_t
in struct shmid64_ds (not visible in patch 07/10 but existing in the
same structure) work by accident (I also wonder how the heck they're
currently supposed to work on bigendian architectures!!)

However, whereas struct shmid64_ds seems to work okay, this patch would
now seem to be wrong.

The sane thing would seem to be to change __BITS_PER_LONG to 32 on x32
and fix the padding hacks in struct shmid64_ds; H.J., would you agree?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

