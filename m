Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2ISQRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:17:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53051 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2ISQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120918165819.583252C0A4@topped-with-meat.com>
References: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com> <20120918165819.583252C0A4@topped-with-meat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 19 Sep 2012 18:16:53 +0200
Message-ID: <CAK1hOcOH_KGccLgFr3N7Ep5J_i1svcXTantYFqE5N9WDBvoomA@mail.gmail.com>
Subject: Re: [PATCH -mm v2] coredump: extend core dump note section to contain
 file names of mapped files
To: Roland McGrath <roland@hack.frob.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 6:58 PM, Roland McGrath <roland@hack.frob.com> wrote:
> The code needs to be macroized a bit so that compat_binfmt_elf.c will
> produce a version that encodes 32-bit values correctly so as to be
> compatible with the output of a native 32-bit kernel.

Just did it...

> It's doubtful that rolling your own single loop actually performs better
> than just calling strlen and memcpy.

I didn't do it for speed, rather for simplicity.

> Since you're just counting to estimate the size of a temporary buffer,
> you could skip the initial loop and just estimate based on mm->map_count.
> Then collect the count in the main loop and write the first word of the
> buffer last.

The format is:

    long count     -- how many files are mapped
    long page_size -- units for file_ofs
    array of [COUNT] elements of
       long start
       long end
       long file_ofs
    followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...

In order to fill in file names, we need to know exact number of array elements,
since file names immediately follow that array. IOW:

+       for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+               if (it is a file-backed vma)
+                       count++;
+       }
+
+       size = count * 64;
+       word_count = 2 + 3 * count;               <=====
...
+       name = (void*)&start_end_ofs[word_count]; <=====

The marked statements are crucial. We can't use estimated count,
we need exact one here in order for 'name' pointer to be correct.

Otherwise (if we would use count = mm->map_count),
we'd need to memmove block of file names at the end.
And we might end up allocating significant amounts of memory
we don't need if there are tons of anon mappings.
IMO this is worse than the counting loop.

Anyway, I will shortly send a patch which implements your logic.
-- 
vda
