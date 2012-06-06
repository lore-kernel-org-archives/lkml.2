Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab2FFVKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:10:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48826 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2FFVKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:10:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120512001754.GF14782@lizard>
References: <20120512001506.GA8653@lizard>
	<20120512001754.GF14782@lizard>
Date: Wed, 6 Jun 2012 14:10:34 -0700
X-Google-Sender-Auth: UX2qVn_4f4sO0QwczcWm3sb8P8M
Message-ID: <CAMbhsRTi2Gkk+CgRdcuQRU6f3SO51bqPt8o_+JDpTuXjkDf64Q@mail.gmail.com>
Subject: Re: [PATCH 06/11] persistent_ram: Make it possible to use memory
 outside of bootmem
From: Colin Cross <ccross@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 5:17 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> This includes devices' memory (e.g. framebuffers or memory mapped
> EEPROMs on a local bus), as well as the normal RAM that we don't use
> for the main memory.
>
> For the normal (but unused) ram we could use kmaps, but this assumes
> highmem support, so we don't bother and just use the memory via
> ioremap.
>
> As a side effect, the following hack is possible: when used together
> with pstore_ram (new ramoops) module, we can limit the normal RAM region
> with mem= and then point ramoops to use the rest of the memory, e.g.
>
>        mem=128M ramoops.mem_address=0x8000000
>
> Sure, we could just reserve the region with memblock_reserve() early in
> the arch/ code, and then register a pstore_ram platform device pointing
> to the reserved region. It's still a viable option if platform wants
> to do so.
>
> Also, we might want to use IO accessors in case of a real device,
> but for now we don't bother (the old ramoops wasn't using it either, so
> at least we don't make things worse).

This is long merged, but I remembered why I moved away from using
ioremap.  The current code uses atomics to track the ringbuffer
positions, which results in ldrex and strex instructions on ARM.
ldrex and strex on memory that is mapped as Device memory (which is
what ioremap maps as) is implementation defined, and is unpredictable
at the architecture level.
