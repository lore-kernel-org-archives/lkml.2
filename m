Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0F1PXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:23:25 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:24284 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0F1PXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:23:23 -0400
Message-ID: <4C28BE64.4050505@tilera.com>
Date: Mon, 28 Jun 2010 11:23:16 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Add driver to enable access to the user dynamic
 network.
References: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com> <201006261316.12816.arnd@arndb.de> <4C2783AD.3010403@tilera.com> <201006281312.16391.arnd@arndb.de>
In-Reply-To: <201006281312.16391.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/28/2010 7:12 AM, Arnd Bergmann wrote:
> On Sunday 27 June 2010, Chris Metcalf wrote:
>   
>> On 6/26/2010 7:16 AM, Arnd Bergmann wrote:
>>     
>>> It seems strange that you need this. Why does linux/list.h
>>> depend on asm/processor.h?
>>>       
>> <linux/list.h> -> <linux/poison.h> -> <linux/prefetch.h> ->
>> <asm/processor.h>.  There doesn't seem to be any good way around this. 
>> I could, I suppose, use an opaque "struct list_head;" declaration in
>> <asm/processor.h>, then create one with kmalloc on demand, but that
>> seemed like overkill, so I embed the made-up version here, then validate
>> it as a BUILD_BUG_ON() to be the same size as a real list_head.  I never
>> actually use the "hardwall_list" structure directly.
>>     
> We could break the dependency by turning prefetch_range into a macro
> or an extern function. There is only one user, and it's in a staging
> driver, so the impact would be minimal.
>   

I don't think so.  The problem is that users of <linux/list.h> expect to
be able to #include that one header, then use things like
list_for_each() (which uses prefetch, as defined in <asm/processor.h>),
but without also being required to #include <asm/processor.h> themselves
explicitly.

I think the only "true" fix would be to have a new <linux/list_types.h>
header that provides list_head (and presumably hlist_head and
hlist_node), which <linux/list.h> would include, as would our
<asm/processor.h>.  This is certainly in line with recent
header-separation changes (e.g. mm_types.h).  Would there be interest in
a change like this?  I implemented it in my tree, and if it sounds
plausible to you, I'll send out a git diff, but it looks pretty much
exactly like this description :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

