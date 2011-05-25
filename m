Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1EYQZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:25:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34822 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab1EYQZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:25:14 -0400
Message-ID: <4DDD2D40.1020305@zytor.com>
Date: Wed, 25 May 2011 09:24:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <20110524211644.GJ27634@elte.hu>	 <4DDC39F1.2060903@zytor.com> <1306332225.2211.9.camel@dan>	 <4DDD24E2.4010602@zytor.com> <1306340141.2211.32.camel@dan>
In-Reply-To: <1306340141.2211.32.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 09:15 AM, Dan Rosenberg wrote:
> 
> Ok, checking the e820 memory map seems like the way to go then.  As a
> first attempt, I'd assume that if I find a contiguous free chunk that
> begins before (or at) 16 MB and continues beyond 16 MB, then that
> represents space where it's safe to load the kernel (up to a certain
> point before the end of that chunk), assuming the chunk has enough space
> and I do some degree of checking that I'm not decompressing on top of
> something else (I'll start to gather a list of what to watch out for).
> Is this a fair assumption?
> 

There is already code that calculates exactly how much space is needed,
so that part is good -- you should have a tight bound available to you.

The important and messy part, though, is that you get the "raw" e820 map
at that point (including not even having had the e801 and 88 fallback
information merged into it.)  This information has to be sanitized (to
deal with overlaps and broken-up chunks) and reserved areas merged in.
This is done in the kernel proper, and bootloaders have some equivalent
code, but you don't have it in that particular boot stage.

> 
> Do you have any alternatives that allow maintaining compatibility while
> giving us finer-grained alignment?  It seems it should be possible,
> since alignment was lower than 16 MB for years before this change was
> introduced...
> 

Basically, you end up having to have a "real alignment" that is internal
to the kernel.  We already expose a "minimum alignment" field in the
header (the legacy field is now "recommended alignment"); however, the
"minimum alignment" is really too aggressive.

Since this can be buried in the kernel itself the key is to not change
the existing header fields.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

