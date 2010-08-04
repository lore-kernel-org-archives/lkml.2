Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0HDI3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:29:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64527 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0HDI3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
References: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
Date: Wed, 4 Aug 2010 09:29:00 +0100
Message-ID: <AANLkTik8+8e6eibAUyfj+A982-jvL_kEsXNmFZ8_qom8@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf: symbol offset breakage with separated debug
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, kernel-team@lists.ubuntu.com,
        Will Deacon <Will.Deacon@arm.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A follow-up on this:

On Tue, Aug 3, 2010 at 12:48 PM, Dave Martin <dave.martin@linaro.org> wrote:

[...]

>
>        a) perf represents symbols as offsets from the start of
>                the mmap'd code region which contains each
>                symbol.

I've looked at the code some more, and it looks like I've
misunderstood here.  It looks like symbol addresses are stored and
searched as _file offsets_ in relation to each mapping -- the
map__map_ip implementation bears this out, now that I understand how
it's used to translate from run-time vitrual address to a file offset:

static inline u64 map__map_ip(struct map *map, u64 ip)
{
        return ip - map->start + map->pgoff;
}

Does this conclusion look wrong to anyone?


Assuming I've understood correctly now, this means that the existing
code _is_ correct, except that seperated debug images aren't processed
correctly.

This means that my patch "work around incorrect ET_EXEC symbol
adjustment" is therefore a bodge, not a fix -- it will "work" in many
cases, for the reasons previously discussed, but it's probably not the
right solution.


Looks like I need to think about this a bit more--- basically we need
to have the ELF section or program headers from the each mmap'd file
available in order to translate correctly between file offset and
link-time virtual address for each image.  The information would need
to be available either when loading symbols or when doing symbol
lookups.  As already discussed, the headers from separated debug
images are junk (at least the p_offset and sh_offset values are junk)
and will lead to wrong address calculations.

We could
    a) Capture the relevant information during perf record, in
addition to capturing the build-ids.  This might break the perf data
file format, but has the advantage (?) that perf report can display
correct image-relative virtual addresses even if the debug symbols
can't be loaded.  map__map_ip could be converted to output
    b) Try to read the loadable image _and_ the debug image during
perf report.  Currently the code only loads one image per mapping.
Loading both and cross-referencing information between them would make
the loading process more complicated.

For (a) we know the program headers will be correct, since they can be
obtained from the exact file that was mapped during the profiling run.
For (b) the "real" file may have gone, and we search other locations
instead.  So, we would need a way to detect which set of program
headers are the correct ones when we search for images to load.  I'm
not sure what the best approach is for this -- maybe some checks for
empty PT_LOAD segments (i.e., for which p_filesz == 0, or is much
smaller than p_memsz) would work...


Any views welcome on which approach would be best.

Cheers
---Dave
