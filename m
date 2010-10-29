Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194Ab0J2RSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:18:05 -0400
Received: from claw.goop.org ([74.207.240.146]:37343 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701Ab0J2RSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:18:03 -0400
Message-ID: <4CCB01C9.4020007@goop.org>
Date: Fri, 29 Oct 2010 10:18:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH] xen: xenfs: privcmd: check put_user() return code
References: <1288265942-12581-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1288265942-12581-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/28/2010 04:39 AM, Vasiliy Kulikov wrote:
> put_user() may fail.  In this case propagate error code from
> privcmd_ioctl_mmap_batch().

Thanks for looking at this.  I'm in two minds about this; the existing
logic is such that these put_users can only fail if something else has
already failed and its returning an error.  I guess it would be useful
to get an EFAULT if you've got a problem writing back the results.

IanC, any opinion?

Thanks,
    J

> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
>
>  drivers/xen/xenfs/privcmd.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
> index f80be7f..2eb04c8 100644
> --- a/drivers/xen/xenfs/privcmd.c
> +++ b/drivers/xen/xenfs/privcmd.c
> @@ -266,9 +266,7 @@ static int mmap_return_errors(void *data, void *state)
>  	xen_pfn_t *mfnp = data;
>  	struct mmap_batch_state *st = state;
>  
> -	put_user(*mfnp, st->user++);
> -
> -	return 0;
> +	return put_user(*mfnp, st->user++);
>  }
>  
>  static struct vm_operations_struct privcmd_vm_ops;
> @@ -323,10 +321,8 @@ static long privcmd_ioctl_mmap_batch(void __user *udata)
>  	up_write(&mm->mmap_sem);
>  
>  	if (state.err > 0) {
> -		ret = 0;
> -
>  		state.user = m.arr;
> -		traverse_pages(m.num, sizeof(xen_pfn_t),
> +		ret = traverse_pages(m.num, sizeof(xen_pfn_t),
>  			       &pagelist,
>  			       mmap_return_errors, &state);
>  	}

