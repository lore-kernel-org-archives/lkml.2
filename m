Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1E0Xwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:52:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56141 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab1E0Xwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:52:34 -0400
Message-ID: <4DE03917.8030809@zytor.com>
Date: Fri, 27 May 2011 16:51:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu> <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu> <4DDFE52D.4070308@zytor.com> <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com> <4DE0198A.9080108@zytor.com>
In-Reply-To: <4DE0198A.9080108@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 02:37 PM, H. Peter Anvin wrote:
> On 05/27/2011 11:05 AM, Linus Torvalds wrote:
>>
>> You can load the kernel at the same virtual address we always load it,
>> and/or perhaps shift it up by just small amounts (ie "single pages"
>> rather than "ten bits worth of pages")
>>
>> And then rely on the fact that you mixed up symbols in other ways.
>>
> 
> OK, here is a bat-shit-crazy idea... an all-module kernel where nothing
> except init code is prelinked at all.
> 
> If we could modularize the core code we could have init code load the
> modules at all kinds of random addresses; they wouldn't even need to be
> contiguous in memory, and since we'd have full access to the memory
> layout at that point, we can randomize the **** out of *everything*.
> 

Thinking about it some more, it might not be that crazy.  Consider the
following notion: the kernel payload, as delivered by the decompressor,
contains the init code, plus a set of modules, which can be ELF modules,
but don't have to be (but since we already have code to load and link
ELF modules it is probably be the best choice.)

After we initialize the system enough to have a memory map, we can pick
a random place for each module, copy it in place, fix up the
relocations, and free the original location.

If we are exceptionally clever, which of course we are, we could even
have these modules linked to their initial location and fix up
references in running code, that way init code could still call module
code, as long as it doesn't stash away pointers to module data.

	-hpa
