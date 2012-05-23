Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab2EWCuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:50:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37866 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2EWCuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:50:08 -0400
Message-ID: <4FBC505A.9000102@gmail.com>
Date: Wed, 23 May 2012 12:50:02 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Phil Carmody <ext-phil.2.carmody@nokia.com>, linux-kernel@vger.kernel.org,
        apw@canonical.com
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>  <1337288048.17726.64.camel@joe2Laptop>  <20120517211641.GC27953@pcarmody2.research.nokia.com>  <4FBC4372.5070000@gmail.com> <1337738520.13111.17.camel@joe2Laptop>
In-Reply-To: <1337738520.13111.17.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/12 12:02, Joe Perches wrote:

> On Wed, 2012-05-23 at 11:54 +1000, Ryan Mallon wrote:
>> On 18/05/12 07:16, Phil Carmody wrote:
>>> Too many. Alas I can't share them. 
>> That sounds like the cases you have seen are in code which is not
>> public. I don't think I have ever seen code in the kernel, or in
>> proposed patches which fakes a typedef with a #define.
>>
>> Is this an issue for public code, or for a private company tree? In the
>> latter case, the checkpatch addition should go in your private tree,
>> rather than mainline. It looks like, at least for mainline Linux, you
>> are trying to solve a non-existent problem.
> 
> I agree it's pretty rare.
> 
> $ git grep -E "#\s*define\s+\w+\s+(struct|union)\b"|wc -l
> 57


Some of those do look a bit broken, or easily replaced by typedefs.
Several of them appear to be completely unused. However some of them
look like they need to be defines. The ones in include/net/netfilter are
defines because of this:

  #define nf_ct_ext_find(ext, id) \
          ((id##_TYPE *)__nf_ct_ext_find((ext), (id)))

This one:

  #define __videocard struct card_info
    __attribute__((section(".videocards")))

I'm guessing is because typedefs don't handle __attribute__.

The YYLTYPE one in scripts/dtc/srcpos.h I think is a requirement of
Yacc/Bison.

The acpi_cache_t looks a bit odd, but it is doing an ifdef acpi_cache_t
test (quick glance - looks like it allows a platform specific
definition), though that could probably be reworked to use a typedef and
a __ACPI_CACHE_T_DEFINED or something.

So there are some legitimate reasons for using #define instead of typedef.

However, my real point was that I don't think the problem is rampant. 57
instances across the kernel is not that many, and I haven't seen a lot
of patches trying to add code with #defines where typedefs should be
used. We could test for lots of things in checkpatch, but it seems more
sensible to check for issues which are likely.

~Ryan

