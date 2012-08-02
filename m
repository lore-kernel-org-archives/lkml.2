Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2HBIr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:47:58 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38363 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab2HBIr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:47:56 -0400
Message-ID: <1343897272.5073.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2] parisc: fix personality flag check in copy_thread()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Aug 2012 09:47:52 +0100
In-Reply-To: <alpine.LNX.2.00.1208020911300.14910@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012155330.14910@pobox.suse.cz>
	 <alpine.LNX.2.00.1208020911300.14910@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 09:12 +0200, Jiri Kosina wrote:
> Directly comparing task_struct->personality against PER_* is not fully
> correct, as it doesn't take flags potentially stored in top three bytes
> into account.
> 
> Analogically, directly forcefully setting personality to PER_LINUX32 or
> PER_LINUX discards any flags stored in the top three bytes.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> 
> changed since v1: fix the bit ops to reflect the fact that PER_LINUX is 
> actually 0

Tell me what you're trying to achieve (or what problem you're trying to
solve), because personality is notoriously tricky.

Usually personality = <whatever> is desired because if you look at the
enum for personality, it does set the top three bits in quite a few
cases.  We actually don't need any of the top 3 byte features ... but I
think making sure they're zeroed out is the correct thing to do.

In particular, if we ever get around to a 64 bit user space, our
personality will be PER_LINUX_FDPIC and then we will be setting the top
three bytes.

James


>  arch/parisc/kernel/process.c    |    2 +-
>  arch/parisc/kernel/sys_parisc.c |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
> index d4b94b3..2c05a92 100644
> --- a/arch/parisc/kernel/process.c
> +++ b/arch/parisc/kernel/process.c
> @@ -309,7 +309,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
>  		cregs->ksp = (unsigned long)stack
>  			+ (pregs->gr[21] & (THREAD_SIZE - 1));
>  		cregs->gr[30] = usp;
> -		if (p->personality == PER_HPUX) {
> +		if (personality(p->personality) == PER_HPUX) {
>  #ifdef CONFIG_HPUX
>  			cregs->kpc = (unsigned long) &hpux_child_return;
>  #else
> diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
> index c9b9322..7f9658e 100644
> --- a/arch/parisc/kernel/sys_parisc.c
> +++ b/arch/parisc/kernel/sys_parisc.c
> @@ -225,12 +225,12 @@ long parisc_personality(unsigned long personality)
>  	long err;
>  
>  	if (personality(current->personality) == PER_LINUX32
> -	    && personality == PER_LINUX)
> -		personality = PER_LINUX32;
> +	    && personality(personality) == PER_LINUX)
> +		personality |= PER_LINUX32;
>  
>  	err = sys_personality(personality);
> -	if (err == PER_LINUX32)
> -		err = PER_LINUX;
> +	if (personality(err) == PER_LINUX32)
> +		err &= ~PER_LINUX32;
>  
>  	return err;
>  }
> 


