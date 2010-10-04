Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0JDJE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:04:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50071 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0JDJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hhf0NcLPC52RRcg4XzL4ISTfd6l7DNMtsJuxdUDh4k6V7KKhFCIHInxgI/ZQ6/sreG
         YItaVPZonfD6VoGSe14YxxvM17YADk2HnZpN2duywMCqW87CVb84OOs377GTpD2VBo0C
         TGxUzTFnJgLOSROxV4Yrx0KlKCraWLLiEQDAE=
Subject: Re: [PATCH] sysctl: fix min/max handling in
 __do_proc_doulongvec_minmax()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
In-Reply-To: <20101004085913.GR14068@sgi.com>
References: <1286025469.2582.1806.camel@edumazet-laptop>
	 <20101004085913.GR14068@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 11:04:18 +0200
Message-ID: <1286183058.18293.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 octobre 2010 à 03:59 -0500, Robin Holt a écrit :
> On Sat, Oct 02, 2010 at 03:17:49PM +0200, Eric Dumazet wrote:
> > When proc_doulongvec_minmax() is used with an array of longs,
> > and no min/max check requested (.extra1 or .extra2 being NULL), we
> > dereference a NULL pointer for the second element of the array.
> > 
> > Noticed while doing some changes in network stack for the "16TB problem"
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> >  kernel/sysctl.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index f88552c..4fba86d 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -2500,7 +2500,8 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
> >  				break;
> >  			if (neg)
> >  				continue;
> > -			if ((min && val < *min) || (max && val > *max))
> > +			if ((table->extra1 && val < *min) ||
> > +			    (table->extra2 && val > *max))
> 
> How about changing:
>         for (; left && vleft--; i++, min++, max++, first=0) {
> into:
>         for (; left && vleft--; i++, min = min ? min + 1 : NULL, max = max ? max + 1: NULL, first=0) {
> 
> That would make min and max correct and reduce the chances somebody in
> the future overlooks the fact they are currently filled with garbage.

I prefer my solution, because the check is done only in the 'write'
case, while its done also for 'read' in your solution, not counting the
for (;;) is really ugly...




