Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1EIVIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:08:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab1EIVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:08:04 -0400
Date: Mon, 9 May 2011 22:07:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 31/38] ARM: 6891/1: prevent heap
 corruption in OABI semtimedop
Message-ID: <20110509210754.GN2268@decadent.org.uk>
References: <20110506001210.350968533@clark.kroah.org>
 <1304732990.3203.61.camel@localhost>
 <alpine.LNX.2.00.1105092206110.19722@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1105092206110.19722@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 10:09:19PM +0200, Jesper Juhl wrote:
> On Sat, 7 May 2011, Ben Hutchings wrote:
> 
> > On Thu, 2011-05-05 at 17:11 -0700, Greg KH wrote:
[...]
> > > -	if (nsops < 1)
> > > +	if (nsops < 1 || nsops > SEMOPM)
> > >  		return -EINVAL;
> > 
> > It's not that important, but the manual page says the error code should
> > E2BIG in the latter case.
> > 
> 
> So something like this...
> 
> Return correct error (E2BIG) when nsops is greater than SEMOPM in 
> sys_oabi_semtimedop. The man page (semtimedop(2)) lists this as the proper 
> error in ths case: 
> "E2BIG  The argument nsops is greater than SEMOPM, the maximum number of 
> operations allowed per system call."

Looks right to me, not that I can test it.

Ben.

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> --
>  sys_oabi-compat.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
> index af0aaeb..c196ad7 100644
> --- a/arch/arm/kernel/sys_oabi-compat.c
> +++ b/arch/arm/kernel/sys_oabi-compat.c
> @@ -311,8 +311,10 @@ asmlinkage long sys_oabi_semtimedop(int semid,
>  	long err;
>  	int i;
>  
> -	if (nsops < 1 || nsops > SEMOPM)
> +	if (nsops < 1)
>  		return -EINVAL;
> +	else if (nsops > SEMOPM)
> +		return -E2BIG;
>  	sops = kmalloc(sizeof(*sops) * nsops, GFP_KERNEL);
>  	if (!sops)
>  		return -ENOMEM;
> 
> 
-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
