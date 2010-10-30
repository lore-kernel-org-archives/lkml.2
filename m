Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab0J3VG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:06:28 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:50344 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0J3VG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:06:26 -0400
Message-ID: <4CCC88CE.5010006@tilera.com>
Date: Sat, 30 Oct 2010 17:06:22 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] asm-generic/stat.h: support 64-bit file time_t for stat()
References: <201010282020.o9SKKe4Y007068@farm-0012.internal.tilera.com> <201010290826.00087.arnd@arndb.de>
In-Reply-To: <201010290826.00087.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 2:25 AM, Arnd Bergmann wrote:
> On Thursday 28 October 2010, Chris Metcalf wrote:
>> The alternative is keeping the two structures the same shape on 64-bit
>> kernels, which means a 64-bit time_t in "struct stat64" for 32-bit
>> processes.  This is a little unnatural since 32-bit userspace can't
>> do anything with 64 bits of time_t information, since time_t is just
>> "long", not "int64_t"; and in any case 32-bit userspace might expect
>> to be running under a 32-bit kernel, which can't provide the high 32
>> bits anyway.  In the case of a 32-bit kernel we'd then be extending the
>> kernel's 32-bit time_t to 64 bits, then truncating it back to 32 bits
>> again in userspace, for no particular reason.  And, as mentioned above,
>> if we have 64-bit time_t for 32-bit processes we can't easily use glibc's
>> STAT_IS_KERNEL_STAT, since glibc's stat structure requires an embedded
>> "struct timespec", which is a pair of "long" (32-bit) values in a 32-bit
>> userspace.  "Inventive" solutions are possible, but are pretty hacky.
> I'd like to have more opinions on that. Would it be less crazy
> to ignore the y2k38 problem for new 32 bit architectures given that
> we already know about it, or to make those architectures unnecessarily
> slow, given that we still have 27+ years before it hits people in
> a major way?
>
> I think we have four alternatives here:
>
> 1. this patch, which is the easiest solution and keeps everything else
> working, but not solving the y2k38 problem on 32 bit.

Perhaps unsurprisingly, I think this patch strikes a good balance for today
of allowing <asm-generic/stat.h> to work in the "obviously correct" way for
64-bit platforms, but without addressing the larger issues.

> 2. make __kernel_time_t 64 bit on new architectures, solving the y2k38
> problem for them at the cost of run-time overhead and possibly application
> porting effort.
>
> 3. make struct stat use a 64 bit time field on new architectures at the
> cost of not using STAT_IS_KERNEL_STAT in 32 bit glibc.
>
> 4. leave struct stat as it is, and move to struct xstat that does
> everything right from the start.

I'd argue that the longer-term plan might be to work with the glibc
community to spec out what the eventual 64-bit time_t APIs will look like
for user-space, and then think about implementing them using xstat() with
64-bit time_t.  Once this is in place, the kernel will need to move to
64-bit __kernel_time_t enough in advance of 2038 to hope that it's
widely-deployed in embedded systems, etc., by then.  But I think this all
represents a more ambitious project than we need today.

> Your patch looks correct for solution 1, I can forward it if we decide
> to do it this way, or you can take it in your series.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

