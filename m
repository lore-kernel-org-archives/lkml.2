Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1KIUr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:47:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39518 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1KIUrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:47:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1111041451590.26175@sister.anvils>
References: <20111103215421.AF532122186@elm.corp.google.com>
	<alpine.LSU.2.00.1111041451590.26175@sister.anvils>
Date: Wed, 9 Nov 2011 12:47:54 -0800
Message-ID: <CABQzsv8RSFfguP2W9EU_TxzCRy3NZR=fmQLj-V7+m2vGY60Szw@mail.gmail.com>
Subject: Re: [patch] hugetlb: add hugepage reservation upon mremap expansion.
From: Ken Chen <kenchen@google.com>
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 3:13 PM, Hugh Dickins <hughd@google.com> wrote:
> But changing i_size in mmap and mremap is unusual, if not simply wrong.
> The size of mmap or mremap is the size of a userspace mapping, which
> is modified by mmap, mremap, munmap.  The size of the underlying object
> is usually independent of that, and modified by ftruncate or write.
>
> It was suggested a few years ago that it would be helpful if mremap of
> a shared anonymous shmem object would change the size of the underlying
> object, instead of just giving SIGBUS on the enlargement; but in the
> end I played cautious, and made no change there.

Indeed, that would be undesirable to modify i_size in mremap().  For small
page, the only mapping one can truly expand beyond file size via mremap()
is private anon.  All other cases it will SIGBUS at the time of fault. In
that respect, I think hugetlb should match the behavior of small page as
well.  I will add a size check for hugetlb mapping and disallow new size
to pass beyond i_size.

Then there are cases of taking partial region and perform an mremap
expansion: e.g.
  addr = mmap(.., SIZE, ..)
  mremap(addr, SIZE / 2, SIZE, ...);

Which for shared mapping, it is fine because everything is already
reserved.  For private mapping, a new set of expansion would be needed.
I will re-post with updated changes on this.

- Ken
