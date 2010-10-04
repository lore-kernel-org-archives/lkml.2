Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0JDKKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:10:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61909 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0JDKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XnSAbj1wBs3TSMWCOO2XuQx4tK7BcQRqjrpvuykZNhHRLq6anhFHOxzBNbyRPyFwl2
         OBbCJmcmhqN0BfN03hFS5IUklAD8liimt/30pssyW+NpJpj1EyqAbpGJ0Va9nP6j+2MR
         clqhRhSNMXrQUjYwxPlfyE97daGlBFGM9OVMQ=
Subject: Re: [PATCH] sysctl: fix min/max handling in
 __do_proc_doulongvec_minmax()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
In-Reply-To: <20101004093439.GG5189@cr0.nay.redhat.com>
References: <1286025469.2582.1806.camel@edumazet-laptop>
	 <20101004085913.GR14068@sgi.com>
	 <1286183058.18293.26.camel@edumazet-laptop>
	 <20101004093439.GG5189@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 12:10:30 +0200
Message-ID: <1286187030.18293.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 octobre 2010 à 17:34 +0800, Américo Wang a écrit :
> On Mon, Oct 04, 2010 at 11:04:18AM +0200, Eric Dumazet wrote:
> >Le lundi 04 octobre 2010 à 03:59 -0500, Robin Holt a écrit :
> >> On Sat, Oct 02, 2010 at 03:17:49PM +0200, Eric Dumazet wrote:
> >> > When proc_doulongvec_minmax() is used with an array of longs,
> >> > and no min/max check requested (.extra1 or .extra2 being NULL), we
> >> > dereference a NULL pointer for the second element of the array.
> >> > 
> >> > Noticed while doing some changes in network stack for the "16TB problem"
> >> > 
> >> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> >> > ---
> >> >  kernel/sysctl.c |    3 ++-
> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> > 
> >> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> >> > index f88552c..4fba86d 100644
> >> > --- a/kernel/sysctl.c
> >> > +++ b/kernel/sysctl.c
> >> > @@ -2500,7 +2500,8 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
> >> >  				break;
> >> >  			if (neg)
> >> >  				continue;
> >> > -			if ((min && val < *min) || (max && val > *max))
> >> > +			if ((table->extra1 && val < *min) ||
> >> > +			    (table->extra2 && val > *max))
> >> 
> >> How about changing:
> >>         for (; left && vleft--; i++, min++, max++, first=0) {
> >> into:
> >>         for (; left && vleft--; i++, min = min ? min + 1 : NULL, max = max ? max + 1: NULL, first=0) {
> >> 
> >> That would make min and max correct and reduce the chances somebody in
> >> the future overlooks the fact they are currently filled with garbage.
> >
> >I prefer my solution, because the check is done only in the 'write'
> >case, while its done also for 'read' in your solution, not counting the
> >for (;;) is really ugly...
> >
> 
> Sorry, I still don't get the point here, min and max
> are pointers, they are already checked before dereferenced.
> After your patch, min and max will be still increased, while
> you are still checking ->extra{1,2} which is wrong.
> 
> I see no problem with the original code, or I must have missed something?

Please re-read again. I had crashes, so original code is bugyy.

Say you call __do_proc_doulongvec_minmax() with an array of three
elements. And .extra1 = NULL, .extra2 = NULL (no range checks, this is a
valid use case)

First element, min = NULL OK. no problem so far.

Second element, min = (long *)(NULL + sizeof(long))   -> BUG 

Third element, min = (long *)(NULL + 2*sizeof(long)) -> BUG 

After my patch, min/max increases normally (they are only pointers after
all)

But they are _dereferenced_ only if they were _not_ NULL at the
beginning (extra1 not NULL for *min, extra2 not NULL for *max)



