Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab2AKTpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:45:08 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:47167 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2AKTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:45:06 -0500
Date: Wed, 11 Jan 2012 17:43:31 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Marcel Selhorst <m.selhorst@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 2/3] TPM: Close data_pending and
 data_buffer races
Message-ID: <20120111194331.GB12299@hardened-box.br.ibm.com>
References: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
 <1323196162-2717-3-git-send-email-tim.gardner@canonical.com>
 <4EF0B9F8.9020305@linux.vnet.ibm.com>
 <4EF0E465.5060704@canonical.com>
 <4EF36C1F.6040409@linux.vnet.ibm.com>
 <4EF37A7A.2060504@canonical.com>
 <4EF38CBD.3080302@linux.vnet.ibm.com>
 <4EF48F64.4010509@canonical.com>
 <1325016165.2313.45.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325016165.2313.45.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011119-1524-0000-0000-000000F55172
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011, Mimi Zohar wrote:

> On Fri, 2011-12-23 at 07:25 -0700, Tim Gardner wrote:
> > On 12/22/2011 01:02 PM, Rajiv Andrade wrote:
> 
> <snip>
> 
> > > It's inside the mutex region.
> > >
> > 
> > Actually, the patch you sent (https://lkml.org/lkml/2011/12/22/257) is 
> > _outside_ the mutex area, but I got your drift.
> 
> Yes, thanks for pointing it out in your original comments. I haven't
> tested the following patch, but perhaps it will help clarify the updated
> version, that I think Rajiv was describing ... 
>

That's exactly it Mimi, thanks for writing down the patch.

> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 6a8771f..7dafd95 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1210,7 +1210,6 @@ ssize_t tpm_read(struct file *file, char __user *buf,
>  	del_singleshot_timer_sync(&chip->user_read_timer);
>  	flush_work_sync(&chip->work);
>  	ret_size = atomic_read(&chip->data_pending);
> -	atomic_set(&chip->data_pending, 0);
>  	if (ret_size > 0) {	/* relay data */
>  		if (size < ret_size)
>  			ret_size = size;
> @@ -1221,8 +1220,10 @@ ssize_t tpm_read(struct file *file, char __user *buf,
>  		if (rc)
>  			ret_size = -EFAULT;
> 
> +		atomic_set(&chip->data_pending, 0);
>  		mutex_unlock(&chip->buffer_mutex);
> -	}
> +	} else if (ret_size < 0)
> +		atomic_set(&chip->data_pending, 0);
> 
>  	return ret_size;
>  }

Tim, do you still see a race with the changes posted above?

Rajiv

> 
> > Even clearing chip->data_pending _inside_ the mutex area, I'm not sure 
> > it closes all of the race windows. I think its still possible to race 
> > with mod_timer() and del_singleshot_timer_sync(). Therein lies my point, 
> > if the exclusion code is not _obviously_ correct for something this 
> > simple, then its probably not. I think my patch is the correct approach.
> 
> With the above patch, tpm_read() resets the data_pending flag only after
> copying the data to userspace, resolving the original race condition
> described.
> 
> > > This would require another fix though. tpm_write() doesn't check
> > > tpm_transmit return code (and it should).
> > > In case it returns an error (< 0), chip->data_pending would remain the
> > > same forever with that change.
> > >
> > 
> > This observation is also correct, but not relevant to the exclusion 
> > races. It deserves a separate patch.
> 
> With the above patch, tpm_read() resets the data_pending flag only if
> set, resolving the other race condition(s).
> 
> thanks,
> 
> Mimi
> 

