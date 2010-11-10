Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0KJPS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:18:28 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46278 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0KJPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:18:26 -0500
Date: Wed, 10 Nov 2010 08:18:24 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] fix vulnerability of the release method of file
	operations in Block layer SCSI generic driver
Message-ID: <20101110151823.GC18258@parisc-linux.org>
References: <AANLkTikbkhHmsVAdGrY0OTnH=gUZW5igjsWSF9y=Ub1u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikbkhHmsVAdGrY0OTnH=gUZW5igjsWSF9y=Ub1u@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:08:37PM +0800, Hillf Danton wrote:
> The computation context setup by previous opening the bsg file could
> not survive following open/release operations upon the same file
> object.

Umm .. release is called on final close of a file, not on every close
of a file.

> The vulnerability is fixed by deferring the cleanup operation until necessary.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/block/bsg.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/block/bsg.c	2010-11-10 21:43:58.000000000 +0800
> @@ -858,7 +858,8 @@ static int bsg_release(struct inode *ino
>  {
>  	struct bsg_device *bd = file->private_data;
> 
> -	file->private_data = NULL;
> +	if (1 == atomic_read(&bd->ref_count))
> +		file->private_data = NULL;
>  	return bsg_put_device(bd);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
