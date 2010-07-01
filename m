Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0GARj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:39:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43619 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0GARjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sBEYU/lOSbxum7h+pdvRb8xjh2jCF+VbF/qC2MjcGNJM/58l/Z1NMvdKZ2J6UDYii7
         L5QHbGGYrmQZK97AeWc2A8zSdoYZenTYBezr2/HxN3EN1bEZwsbWpb13kZgXzlNZ7aZw
         SjaS4ucXZHfcGIuqV92VfguVfVUTHC/LbZWAI=
Date: Thu, 1 Jul 2010 19:38:05 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Doug Gilbert <dgilbert@interlog.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] scsi/sg: remove casts from void*
Message-ID: <20100701173805.GW19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	Kernel Janitors <kernel-janitors@vger.kernel.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Jens Axboe <jens.axboe@oracle.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1277990204-22157-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277990204-22157-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:16:43PM +0400, Kulikov Vasiliy wrote:
> -	Sg_fd *sfp;
> +	Sg_fd *sfp = filp->private_data;
                     ^^^^^^^^^^^^^^^^^^
	Dereferenced here.

>  	unsigned long req_sz, len, sa;
>  	Sg_scatter_hold *rsv_schp;
>  	int k, length;
>  
> -	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
> +	if ((!filp) || (!vma) || !(sfp))
             ^^^^^

	Checked here.

I obviously just spotted that during the review but another way would be
to use smatch to catch these.  (http://smatch.sf.net)

$ /path/to/smatch_scripts/kchecker drivers/scsi/sg.c
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   drivers/scsi/sg.c
drivers/scsi/sg.c +1236 sg_mmap(7) warn: variable dereferenced before check 'filp'
  CC [M]  drivers/scsi/sg.o
$

You could also get rid of the extra parenthesis.
+	if (!filp || !vma || !sfp)

>  		return -ENXIO;
>  	req_sz = vma->vm_end - vma->vm_start;
>  	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",

Btw.  These are _way_ better than when you sent them the first time.
Thanks for doing resending them.

regards,
dan carpenter

