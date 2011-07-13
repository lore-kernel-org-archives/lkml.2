Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1GMVfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:35:48 -0400
Received: from mail.perches.com ([173.55.12.10]:3983 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1GMVfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:35:47 -0400
Subject: Re: Linux 2.6.32.43 (WARN_RATELIMIT)
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>, David Miller <davem@davemloft.net>,
        saidone <saidone@saidone.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
In-Reply-To: <4E1E0E04.8030200@suse.cz>
References: <20110713034559.GA16150@kroah.com> <4E1E0B40.1030905@suse.cz>
	 <4E1E0C59.1030100@suse.cz>  <4E1E0E04.8030200@suse.cz>
Content-Type: multipart/mixed; boundary="=-3WhKIK5KEfAsOf7g4r3T"
Date: Wed, 13 Jul 2011 14:35:45 -0700
Message-ID: <1310592945.1662.27.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3WhKIK5KEfAsOf7g4r3T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2011-07-13 at 23:28 +0200, Jiri Slaby wrote:
> Cced Joe.

Thanks Jiri.

I didn't submit this patch for stable.
I don't even try to track stable.

Saidone also notified me, I just replied to him
and cc'd stable.  Perhaps I should have cc'd lkml
as well.  Saidone's proposed patch is attached.

cheers, Joe

> On 07/13/2011 11:21 PM, Jiri Slaby wrote:
> > On 07/13/2011 11:16 PM, Jiri Slaby wrote:
> >> On 07/13/2011 05:45 AM, Greg KH wrote:
> >>> Joe Perches (2):
> >>>       bug.h: Add WARN_RATELIMIT
> >>>       net: filter: Use WARN_RATELIMIT
> >>
> >> Hi, this causes a build failure on PPC with minimalistic config (PS3) [1]:
> >> net/core/filter.c: In function 'sk_run_filter':
> >> net/core/filter.c:297: error: implicit declaration of function
> >> 'WARN_RATELIMIT'
> >>
> >> net/core/filter.c should include linux/bug.h (or linux/kernel.h).
> > 
> > Ah, no, PS3 doesn't have CONFIG_BUG set.
> 
> A fix attached. Upstream doesn't need it. There it is all in
> linux/ratelimit.h
> 
> >> [1]
> >> http://gitorious.org/opensuse/kernel-source/blobs/SLE11-SP1/config/ppc/ps3
> >>
> >> regards,



--=-3WhKIK5KEfAsOf7g4r3T
Content-Disposition: inline
Content-Description: Attached message - Re: WARN_RATELIMIT
Content-Type: message/rfc822

Return-Path: <saidone@saidone.org>
X-Original-To: joe@perches.com
Delivered-To: joe@perches.com
Received: from smtp207.alice.it (smtp207.alice.it [82.57.200.103]) by
 mail.perches.com (Postfix) with ESMTP id ACDB224368 for <joe@perches.com>;
 Wed, 13 Jul 2011 10:44:42 -0700 (PDT)
Received: from kugelmass.saidonet (80.183.18.56) by smtp207.alice.it
 (8.5.124.08) id 4DFA189A02D4036E; Wed, 13 Jul 2011 19:44:49 +0200
Received: from [192.168.1.1] (nicoletta-desktop.saidonet [192.168.1.1]) by
 kugelmass.saidonet (Postfix) with ESMTP id 4A282B2; Wed, 13 Jul 2011
 19:44:47 +0200 (CEST)
Message-ID: <4E1DD98E.5030903@saidone.org>
Date: Wed, 13 Jul 2011 19:44:46 +0200
From: saidone <saidone@saidone.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: stable <stable@kernel.org>
Subject: Re: WARN_RATELIMIT
References: <4E1D7560.7060502@saidone.org>
	 <1310568751.1662.13.camel@Joe-Laptop>
In-Reply-To: <1310568751.1662.13.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Status: 
X-Evolution-Source: pop://joe@192.168.1.1/
Content-Transfer-Encoding: 7bit

Hi Joe, I found that the problem was that I have debugfs disabled (# 
CONFIG_BUG is not set).
I cannot make better than this patch to net/core/filter.c:

  #ifdef CONFIG_BUG
                         WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u 
k:%u\n",
                                        fentry->code, fentry->jt,
                                        fentry->jf, fentry->k);
                         #endif
                         #ifndef CONFIG_BUG
                         WARN_ON(1);
                         #endif
                         return 0;

However, at least, it works ;-)
Thank you very much for the hints,

Marco Marini

On 13/07/2011 16:52, Joe Perches wrote:
> On Wed, 2011-07-13 at 12:37 +0200, saidone wrote:
>> Hello Joe,
>> I tried to build the latest stable kernel 2.6.32.43 with gcc 3.4.6, but
>> it stopped while compiling filter.c:
>> net/core/filter.c: In function `sk_run_filter':
>> net/core/filter.c:294: error: implicit declaration of function
>> `WARN_RATELIMIT'
>> How can I patch it in a "safe" manner?
>> Thanks in advance,
>> Marco Marini
>
> I believe net/core/filter.c will need to
>
> #include<linux/ratelimit.h>


--=-3WhKIK5KEfAsOf7g4r3T--

