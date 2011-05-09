Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1EIUQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:16:18 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19175 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1EIUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:16:17 -0400
Date: Mon, 9 May 2011 22:09:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ben Hutchings <ben@decadent.org.uk>
cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 31/38] ARM: 6891/1: prevent heap corruption
 in OABI semtimedop
In-Reply-To: <1304732990.3203.61.camel@localhost>
Message-ID: <alpine.LNX.2.00.1105092206110.19722@swampdragon.chaosbits.net>
References: <20110506001210.350968533@clark.kroah.org> <1304732990.3203.61.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 May 2011, Ben Hutchings wrote:

> On Thu, 2011-05-05 at 17:11 -0700, Greg KH wrote:
> > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Dan Rosenberg <drosenberg@vsecurity.com>
> > 
> > commit 0f22072ab50cac7983f9660d33974b45184da4f9 upstream.
> > 
> > When CONFIG_OABI_COMPAT is set, the wrapper for semtimedop does not
> > bound the nsops argument.  A sufficiently large value will cause an
> > integer overflow in allocation size, followed by copying too much data
> > into the allocated buffer.  Fix this by restricting nsops to SEMOPM.
> > Untested.
> > 
> > Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  arch/arm/kernel/sys_oabi-compat.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/arch/arm/kernel/sys_oabi-compat.c
> > +++ b/arch/arm/kernel/sys_oabi-compat.c
> > @@ -311,7 +311,7 @@ asmlinkage long sys_oabi_semtimedop(int
> >  	long err;
> >  	int i;
> >  
> > -	if (nsops < 1)
> > +	if (nsops < 1 || nsops > SEMOPM)
> >  		return -EINVAL;
> 
> It's not that important, but the manual page says the error code should
> E2BIG in the latter case.
> 

So something like this...

Return correct error (E2BIG) when nsops is greater than SEMOPM in 
sys_oabi_semtimedop. The man page (semtimedop(2)) lists this as the proper 
error in ths case: 
"E2BIG  The argument nsops is greater than SEMOPM, the maximum number of 
operations allowed per system call."

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
--
 sys_oabi-compat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index af0aaeb..c196ad7 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -311,8 +311,10 @@ asmlinkage long sys_oabi_semtimedop(int semid,
 	long err;
 	int i;
 
-	if (nsops < 1 || nsops > SEMOPM)
+	if (nsops < 1)
 		return -EINVAL;
+	else if (nsops > SEMOPM)
+		return -E2BIG;
 	sops = kmalloc(sizeof(*sops) * nsops, GFP_KERNEL);
 	if (!sops)
 		return -ENOMEM;



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

