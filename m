Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1GTN3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:29:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27109 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1GTN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:29:05 -0400
Date: Wed, 20 Jul 2011 09:27:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mikew@google.com,
        tony.luck@intel.com
Subject: Re: [PATCH 4/9] pstore: Allow the user to explicitly choose a backend
Message-ID: <20110720132706.GA19934@dumpdata.com>
References: <1311021033-7483-1-git-send-email-mjg@redhat.com>
 <1311021033-7483-5-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311021033-7483-5-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E26D7B5.0070:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 04:30:28PM -0400, Matthew Garrett wrote:
> pstore only allows one backend to be registered at present, but the
> system may provide several. Add a parameter to allow the user to choose
> which backend will be used rather than just relying on load order.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  Documentation/ABI/testing/pstore    |    5 +++++
>  Documentation/kernel-parameters.txt |    2 ++
>  fs/pstore/platform.c                |   11 +++++++++++
>  3 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing/pstore
> index ddf451e..1aa4035 100644
> --- a/Documentation/ABI/testing/pstore
> +++ b/Documentation/ABI/testing/pstore
> @@ -39,3 +39,8 @@ Description:	Generic interface to platform dependent persistent storage.
>  		multiple) files based on the record size of the underlying
>  		persistent storage until at least this amount is reached.
>  		Default is 10 Kbytes.
> +
> +		Pstore only supports one backend at a time. If multiple
> +		backends are available, the preferred backend may be
> +		set by passing the pstore.backend= argument to the kernel
> +		or writing to /sys/module/pstore/parameters/backend .
> \ No newline at end of file
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index ede3209..abafa88 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2156,6 +2156,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			[HW,MOUSE] Controls Logitech smartscroll autorepeat.
>  			0 = disabled, 1 = enabled (default).
>  
> +	pstore.backend=	Specify the name of the pstore backend to use
> +
>  	pt.		[PARIDE]
>  			See Documentation/blockdev/paride.txt.
>  
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 49ff1de..94200d6 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -37,6 +37,8 @@
>  static DEFINE_SPINLOCK(pstore_lock);
>  static struct pstore_info *psinfo;
>  
> +static char *backend;
> +
>  /* How much of the console log to snapshot */
>  static unsigned long kmsg_bytes = 10240;
>  
> @@ -131,6 +133,12 @@ int pstore_register(struct pstore_info *psi)
>  		spin_unlock(&pstore_lock);
>  		return -EBUSY;
>  	}
> +
> +	if (backend && strcmp(backend, psi->name)) {

Is there a limit of how big the backend name can be? If so would it
make sense to use to strncmp?

> +		spin_unlock(&pstore_lock);
> +		return -EBUSY;
> +	}
> +
>  	psinfo = psi;
>  	spin_unlock(&pstore_lock);
>  
> @@ -208,3 +216,6 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(pstore_write);
> +
> +module_param(backend, charp, 0644);
> +MODULE_PARM_DESC(backend, "Pstore backend to use");
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
