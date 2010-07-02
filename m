Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab0GBMTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:19:40 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:23469 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab0GBMTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:19:39 -0400
Message-ID: <4C2DD958.7030005@tilera.com>
Date: Fri, 2 Jul 2010 08:19:36 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Add driver to enable access to the user dynamic
 network.
References: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com> <201006281312.16391.arnd@arndb.de> <4C28BE64.4050505@tilera.com> <201006282134.55166.arnd@arndb.de>
In-Reply-To: <201006282134.55166.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[The question is how to use <linux/list.h> from within <asm/processor.h>.]

On 6/28/2010 3:34 PM, Arnd Bergmann wrote:
>> I think the only "true" fix would be to have a new <linux/list_types.h>
>> > header that provides list_head (and presumably hlist_head and
>> > hlist_node), which <linux/list.h> would include, as would our
>> > <asm/processor.h>.  This is certainly in line with recent
>> > header-separation changes (e.g. mm_types.h).  Would there be interest in
>> > a change like this?  I implemented it in my tree, and if it sounds
>> > plausible to you, I'll send out a git diff, but it looks pretty much
>> > exactly like this description :-)
>>     
> Yes, I think that would be a reasonable change.
>
> Another alternative might be to move the prefetch stuff from asm/processor.h
> to asm/prefetch.h on all architectures, which also breaks the dependency loop,
> unless I'm mistaken again

In principle I like the <asm/prefetch.h> idea, but I'm concerned that
the #include of <asm/system.h> from <linux/list.h> will recursively
include <asm/processor.h> on some platforms; for example, s390 and
xtensa include it directly.  We (tile) were including it indirectly via
<asm/irqflags.h>, though this seems to be a spurious include on our
part, but other platforms may also include it indirectly.  To be fair,
I'm not sure why <asm/system.h> is included from <linux/list.h>.  It
doesn't seem required for a tile build, at least, but no doubt it was
put there for some reason.

So, if there's a good reason for it to be there, I'd say that pushes us
back toward a separate <linux/list_types.h>.  Otherwise we can
investigate splitting out the prefetch content on every platform to
<asm/prefetch.h> (presumably creating some empty <asm/prefetch.h>
headers on architectures that just use the gcc builtin) and adding new
#includes of <asm/prefetch.h> to files that reference the prefetch
functionality.  Arnd and other list folks, what's your instinct?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

