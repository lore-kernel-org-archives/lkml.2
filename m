Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1AKElO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:41:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1AKElJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:41:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] asm-generic headers: modify stat.h in include/asm-generic to be applicable to more architectures
Date: Tue, 11 Jan 2011 05:40:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <024501cbaf37$4e479fd0$ead6df70$@mprc.pku.edu.cn> <201101090128.25371.arnd@arndb.de> <005201cbb0ce$65e725f0$31b571d0$@mprc.pku.edu.cn>
In-Reply-To: <005201cbb0ce$65e725f0$31b571d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101110540.48489.arnd@arndb.de>
X-Provags-ID: V02:K0:0HrpScXRhhsp0iobYElbNdBYfPARd/1/2nsy81vGeKN
 ayUH9a7b5D5D+8g3/zy+i1zRGXgM1WP5wN/6MmssQz0YSQ+W4K
 GJUHtL08ygDlY3tKIJ84ED64bLdJBNk5CUa2Hx82PAxTf35BtP
 R1KR2/teYFdVwS+C0U2StRhhib7QYXZcaHxqfMqJE+mtcwezBr
 rwIS4PBHWpTIbi17rdC2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 January 2011, Guan Xuetao wrote:
> IMO, asm-generic headers should be used in more architectures as far as possible.

They serve two purposes:

1. To be used by other architectures (with or without being modified by arch
   specific defines)
2. As an example implementation to read by people understanding the kernel or
   porting to a new architecture.

Your patch helps the first cause, but it's counterproductive for the second.

Also, if we wanted to make all these headers fully generic, we would no longer
need an asm-generic directory for the first use case, because then everything
in them could be put into the include/linux/*.h headers directly. This has
happened for a number of files in the past, but it's impractical for others.

> The patch of stat.h could be split into two parts to discuss.
> Firstly,  STAT64_HAS_BROKEN_ST_INO is defined in most architecture's asm/stat.h,
> and it should be considered as the part in asm-generic/stat.h.

This one is purely historical. The definition of st_ino was too short
initially, so the field was kept in place by renamed to __st_ino
instead. The __st_ino should however never be used by any application
you compile now, only by the kernel in order to remain compatible with
existing application binaries. No new architecture should need to see
this, because there are no preexisting binaries that use this field.

I intentionally left out all the backwards-compatibility fields from
the asm-generic headers that I wrote.

> Secondly, STAT64_PAD_BEFORE_* are misunderstanding definitions, and perhaps
> it should use STAT64_ST_SIZE_NEED_ALIGN_64.

It's much more complicated ;-)

The padding after st_rdev is usually from glibc trying to reserve a large
amount of space for future extensions of rdev. Padding around st_blocks
and st_size is usually for making it possible to extend those values
to full 64 bit when they are not already, but some architectures use
the padding just to provide natural alignment of the words.

Almost every architecture has a slightly different definition of
stat64, and most of them got at least one aspect slightly wrong.

The mistake that I made in the asm-generic version was that it uses 32 bit
st_*time, which should really be 64 bit in order to avoid the year 2038
overflow bug.

> Indeed, the macros are used for compatibility, but most architectures could make full use of
> asm-generic headers, and new architectures could just follow the default values.

I totally agree with the idea in generical (for other headers), but in case of the
stat.h file, it always gets more complicated than you think at first. 
David Howells worked on a new 'struct xstat' for some time, if anything we should
just do that and keep struct stat hidden in the dark corners of the kernel.

	Arnd
