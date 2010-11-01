Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab0KAMR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:17:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61607 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab0KAMRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=icgok7VpFm4smQTvgDA/Gw0dVpg041QXiVZn+EqEh8iHGsfOMZD+uSvRHYuPwFAXUh
         hWXuubkbK9BlWAnxY2RdggAckX2ePmEiXdIKzy2Kt/kucrTAeX5rDQKzsdV20ErkJwPP
         r+5yWBc4n431knQyYYoVmcOYngTrk7nX2nU34=
Date: Mon, 1 Nov 2010 20:22:37 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
Message-ID: <20101101122237.GM6023@cr0.nay.redhat.com>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>
 <20101030214704.GA20005@Krystal>
 <alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net>
 <20101031183913.GA26160@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101031183913.GA26160@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 02:39:14PM -0400, Mathieu Desnoyers wrote:
>* Jesper Juhl (jj@chaosbits.net) wrote:
>> On Sat, 30 Oct 2010, Mathieu Desnoyers wrote:
>> 
>> > * Jesper Juhl (jj@chaosbits.net) wrote:
>> > > Hi,
>> > > 
>> > > We can optimize kernel/relay.c::relay_alloc_page_array() slightly by using 
>> > > vzalloc. The patch makes these changes:
>> > > 
>> > >  - use vzalloc instead of vmalloc+memset.
>> > >  - remove redundant local variable 'array'.
>> > >  - declare local 'pa_size' as const.
>> > 
>> > Hrm ? How does declaring a local variable as const helps the compiler in
>> > any way ?
>> > 
>> 
>> Hmm, probably not very much in this case (but it doesn't hurt either ;) - 
>> actually, removing the const yielded the exact same result, so it's 
>> "not at all" in this case). 
>> That bit came from my "build-in" tendency to declare stuff const when it 
>> obviously doesn't change/nor should. It's a habbit..
>
>Which looks to me like a misunderstanding of the C99 standard. What you
>do is:
>
>static struct page **relay_alloc_page_array(unsigned int n_pages)
>{
>	const size_t pa_size = n_pages * sizeof(struct page *);
>	...
>}
>
>So the compiler has no choice but to emit code that will fill in the
>value of pa_size at runtime, because it depends on "n_pages", a
>parameter received by the function. So pa_size is everything but
>constant.
>
>The C99 standard, section 6.7.3 (Type qualifiers) states:
>
>"The implementation may place a const object that is not volatile in a
>read-only region of storage. Moreover, the implementation need not
>allocate storage for such an object if its address is never used."
>


This is not enforced by C99. This is C, not C++. :)

>So maybe gcc is kind here and it just removes this const specifier
>without complaining, but a different compiler might be more strict and
>fail to compile because you would be dynamically assigning a value to a
>variable placed in read-only storage.
>

That compiler would be broken if it exists. Also, I doubt linux kernel
could be compiled with other compilers than gcc (except icc?).
