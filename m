Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2DOWKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:10:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47682 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2DOWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:10:33 -0400
Date: Mon, 16 Apr 2012 02:10:28 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] prctl: Add PR_SET_MM option description
Message-ID: <20120415221028.GE25380@moon>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
 <1330518197-12825-2-git-send-email-gorcunov@openvz.org>
 <CAKgNAkgwapZXw5gR_sSGyfufybY52S4qD1MjPDKs+6tBcgFJUg@mail.gmail.com>
 <20120415065401.GA25380@moon>
 <CAKgNAkjMpjmKCD3oQa7qTeH5gXydDgMj5TjmKKtyXYzV9f--fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgNAkjMpjmKCD3oQa7qTeH5gXydDgMj5TjmKKtyXYzV9f--fA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 10:13:51PM +1200, Michael Kerrisk (man-pages) wrote:
> On Sun, Apr 15, 2012 at 6:54 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > On Sun, Apr 15, 2012 at 03:48:18PM +1200, Michael Kerrisk (man-pages) wrote:
> >> Cyrill,
> >>
> >> While reviewing your patch to the prctl() manual page, I noticed the
> >> following code inkernel/sys.c::prctl_set_mm():
> >>
> >>         if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
> >>                 /* It must be existing VMA */
> >>                 if (!vma || vma->vm_start > addr)
> >>                         goto out;
> >>         }
> >>
> >> At this point, the code causes an exit with error set to zero (i.e.,
> >> success). This looks unintended to me. Is the code correct? I suspect
> >> a return of -EFAULT or -ENOMEM is warranted.
> >
> > Hi Michael, yup, -EINVAL escaped (I think EFAULT or ENOMEM is not really
> > good here). I'll fix and send update. Thanks!
> 
> For what it's worth (I am no expert), it looks to me as though EFAULT
> or ENOMEM is more usual after a failed find_vma(). Furthermore, EINVAL
> is already heavily used, so not very informative as an error.

Would not ENOMEM be decoded by glibc as "no-memory" usually associated
with lack of free memory?

You know, I'm starting to think this checks for existing vmas might be
redundant completely. I tried to make this prctl codes to look somehow
close to elf loading procedure, where start|end_code/data do correspond
vmas loaded by kernel while parsing pt-load sections, but now I think
this is not needed, because start|end_code/data is not changed after
file is loaded but when we do checkpoint (and then restore) the program
map might be seriously changed (the program may unmap original areas,alocate
new vmas, put there code/data or whatever) thus there might be no correspond
vma at all when we setup this addresses for memory map (if only I'm not
missing something). So I guess I could drop this "existing vmas"
requirements. Need to think more :)

	Cyrill
