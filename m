Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0JDJaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:30:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40215 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0JDJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Ov96ak6Uh+oo19ciXGrNwlmFbsMmE1Z1PsDcOJmHSWfMEKCCjxBfjThSnVwYsjmlD1
         AF1X/1Ffwj8x+Tmm8AQgk0w62gOPYr3OQN3nFa0UXN4aCNgMJjc191BgQlGIhtKbAvsL
         bBRSdjts1jmCx/Aw4dNmS/iFpC4ov78QJDr8w=
Date: Mon, 4 Oct 2010 17:34:39 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [PATCH] sysctl: fix min/max handling in
 __do_proc_doulongvec_minmax()
Message-ID: <20101004093439.GG5189@cr0.nay.redhat.com>
References: <1286025469.2582.1806.camel@edumazet-laptop>
 <20101004085913.GR14068@sgi.com>
 <1286183058.18293.26.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286183058.18293.26.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 11:04:18AM +0200, Eric Dumazet wrote:
>Le lundi 04 octobre 2010 à 03:59 -0500, Robin Holt a écrit :
>> On Sat, Oct 02, 2010 at 03:17:49PM +0200, Eric Dumazet wrote:
>> > When proc_doulongvec_minmax() is used with an array of longs,
>> > and no min/max check requested (.extra1 or .extra2 being NULL), we
>> > dereference a NULL pointer for the second element of the array.
>> > 
>> > Noticed while doing some changes in network stack for the "16TB problem"
>> > 
>> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> > ---
>> >  kernel/sysctl.c |    3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> > index f88552c..4fba86d 100644
>> > --- a/kernel/sysctl.c
>> > +++ b/kernel/sysctl.c
>> > @@ -2500,7 +2500,8 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>> >  				break;
>> >  			if (neg)
>> >  				continue;
>> > -			if ((min && val < *min) || (max && val > *max))
>> > +			if ((table->extra1 && val < *min) ||
>> > +			    (table->extra2 && val > *max))
>> 
>> How about changing:
>>         for (; left && vleft--; i++, min++, max++, first=0) {
>> into:
>>         for (; left && vleft--; i++, min = min ? min + 1 : NULL, max = max ? max + 1: NULL, first=0) {
>> 
>> That would make min and max correct and reduce the chances somebody in
>> the future overlooks the fact they are currently filled with garbage.
>
>I prefer my solution, because the check is done only in the 'write'
>case, while its done also for 'read' in your solution, not counting the
>for (;;) is really ugly...
>

Sorry, I still don't get the point here, min and max
are pointers, they are already checked before dereferenced.
After your patch, min and max will be still increased, while
you are still checking ->extra{1,2} which is wrong.

I see no problem with the original code, or I must have missed something?

