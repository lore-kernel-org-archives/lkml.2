Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0G2HyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 03:54:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37587 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0G2HyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 03:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gBTzCgX0sVSyxF+pkT7o51gWmLLTdz7nA5+mnJRotk85/baUhocctSxrPvchzQwRBE
         5USmmVjhDkGFuI41ko5urxk5he4CDGi/je3D9HXIiCUc04UkinsiNJM/b9jivH04TSr/
         DyCn1Z6LwEmFy2ReJY2FzKZe+CsW8sClszess=
Date: Thu, 29 Jul 2010 15:58:15 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] kexec: return -EFAULT on copy_to_user() failures
Message-ID: <20100729075815.GA5555@cr0.nay.redhat.com>
References: <20100729073609.GR26313@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729073609.GR26313@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 09:36:10AM +0200, Dan Carpenter wrote:
>copy_to/from_user() returns the number of bytes remaining to be copied.
>It never returns a negative value.  The correct return code is -EFAULT
>and not -EIO.
>
>All the callers check for non-zero returns so that's Ok, but the return
>code is passed to the user so we should fix this.
>
>Signed-off-by: Dan Carpenter <error27@gmail.com>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
>diff --git a/kernel/kexec.c b/kernel/kexec.c
>index 474a847..ab2258b 100644
>--- a/kernel/kexec.c
>+++ b/kernel/kexec.c
>@@ -151,8 +151,10 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
> 	image->nr_segments = nr_segments;
> 	segment_bytes = nr_segments * sizeof(*segments);
> 	result = copy_from_user(image->segment, segments, segment_bytes);
>-	if (result)
>+	if (result) {
>+		result = -EFAULT;
> 		goto out;
>+	}
> 
> 	/*
> 	 * Verify we have good destination addresses.  The caller is
>@@ -827,7 +829,7 @@ static int kimage_load_normal_segment(struct kimage *image,
> 		result = copy_from_user(ptr, buf, uchunk);
> 		kunmap(page);
> 		if (result) {
>-			result = (result < 0) ? result : -EIO;
>+			result = -EFAULT;
> 			goto out;
> 		}
> 		ubytes -= uchunk;
>@@ -882,7 +884,7 @@ static int kimage_load_crash_segment(struct kimage *image,
> 		kexec_flush_icache_page(page);
> 		kunmap(page);
> 		if (result) {
>-			result = (result < 0) ? result : -EIO;
>+			result = -EFAULT;
> 			goto out;
> 		}
> 		ubytes -= uchunk;
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
