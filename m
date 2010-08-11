Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab0HKXpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:45:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26193 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0HKXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:45:39 -0400
Date: Wed, 11 Aug 2010 16:43:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gcosta@redhat.com, hpa@zytor.com,
        lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de,
        ying.huang@intel.com
Subject: Re: +
 drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch added to
 -mm tree
Message-Id: <20100811164310.a4790773.randy.dunlap@oracle.com>
In-Reply-To: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>
References: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 16:06:24 -0700 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      drivers/acpi/apei/erst-dbg.c: get_user(u64) doesn't work on i386
> has been added to the -mm tree.  Its filename is
>      drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: drivers/acpi/apei/erst-dbg.c: get_user(u64) doesn't work on i386
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Might be an x86 bug?  A get_user() on a u64 on i386 expands to
> 
> #define __get_user_8(__ret_gu, __val_gu, ptr)				\
> 		__get_user_x(X, __ret_gu, __val_gu, ptr)
> 
> which emits a call to __get_user_X(), which doesn't exist.
> 
> Kludge around it with copy_from_user().
> 

Reported and fixed yesterday.

> 
> 
> While we're there, teach it how to print size_t's:

That was also patched, but yours is better.
I missed the cast in Huang's patch.


> drivers/acpi/apei/erst-dbg.c: In function 'erst_dbg_read':
> drivers/acpi/apei/erst-dbg.c:106: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'ssize_t'
> 
> Cc: Glauber Costa <gcosta@redhat.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/acpi/apei/erst-dbg.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/acpi/apei/erst-dbg.c~drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386 drivers/acpi/apei/erst-dbg.c
> --- a/drivers/acpi/apei/erst-dbg.c~drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386
> +++ a/drivers/acpi/apei/erst-dbg.c
> @@ -57,9 +57,10 @@ static long erst_dbg_ioctl(struct file *
>  
>  	switch (cmd) {
>  	case APEI_ERST_CLEAR_RECORD:
> -		rc = get_user(record_id, (u64 __user *)arg);
> +		rc = copy_from_user(&record_id, (const void __user *)arg,
> +					sizeof(record_id));
>  		if (rc)
> -			return rc;
> +			return -EFAULT;
>  		return erst_clear(record_id);
>  	case APEI_ERST_GET_RECORD_COUNT:
>  		rc = erst_get_record_count();
> @@ -104,7 +105,7 @@ retry:
>  		goto out;
>  	if (len > ERST_DBG_RECORD_LEN_MAX) {
>  		pr_warning(ERST_DBG_PFX
> -			   "Record (ID: 0x%llx) length is too long: 0x%lx\n",
> +			   "Record (ID: 0x%llx) length is too long: 0x%zx\n",
>  			   id, len);
>  		rc = -EIO;
>  		goto out;
> _


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
