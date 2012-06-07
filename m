Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971Ab2FGOmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760925Ab2FGOmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:42:20 -0400
Date: Thu, 7 Jun 2012 16:42:04 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulrich Obergfell <uobergfe@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Larry Woodman <lwoodman@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [ 08/82] mm: pmd_read_atomic: fix 32bit PAE pmd walk vs
 pmd_populate SMP race condition
Message-ID: <20120607144204.GD21339@redhat.com>
References: <20120607041406.GA13233@kroah.com>
 <20120607040337.622672845@linuxfoundation.org>
 <CA+5PVA6A0K3WYBQJH8z3ddd2X3=fQm1a34z+fWSYGcUg4TR9+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA6A0K3WYBQJH8z3ddd2X3=fQm1a34z+fWSYGcUg4TR9+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 07, 2012 at 09:42:55AM -0400, Josh Boyer wrote:
> On Thu, Jun 7, 2012 at 12:03 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Andrea Arcangeli <aarcange@redhat.com>
> >
> > commit 26c191788f18129af0eb32a358cdaea0c7479626 upstream.
> >
> > When holding the mmap_sem for reading, pmd_offset_map_lock should only
> > run on a pmd_t that has been read atomically from the pmdp pointer,
> > otherwise we may read only half of it leading to this crash.
> 
> This one is important, but it can break Xen apparently:
> 
> http://permalink.gmane.org/gmane.comp.emulators.xen.devel/132522
> https://bugzilla.redhat.com/show_bug.cgi?id=829016
> 
> Not sure if you want to hold off on it or see if Andrea comes up with
> a follow up fix?

Not knowing exactly why Xen trips on the atomic64_read on a PAE 32bit
pmd on my side, I don't know what's the best direction to fix it yet.

I knew this fix has been tested and was working fine with Xen +
CONFIG_TRANSPARENT_HUGEPAGE=n + 32bit + x86 + PAE. And when THP=n I
could fix the problem without having to use a slightly more expensive
cmpxchg8b for every pmd read happening with the mmap_sem hold in read
mode.

It was totally unexpected to run into trouble with Xen +
CONFIG_TRANSPARENT_HUGEPAGE=y + 32bit + x86 + PAE, apologies.

>From the oops it looks like atomic64_read trips on a dangling pmdp
pointer, but if the problem doesn't happen with Xen then the pointer
value shouldn't be the problem, and in turn the lock cmpxchg8b used to
access the pointer is likely the problem.

I gave a few suggestions on how to fix it, that should work regardless
of why this is happening, but I'd prefer the Xen developers to comment
on that.

https://bugzilla.redhat.com/attachment.cgi?id=589620

<f0> 0f c7 09 c3 8d 76 0

f0 0f is the infamous opcode lock cmpxchg8b so it confirms it trips
exactly on the pmdp read.

ecx/edx = dcaea360 and "BUG: unable to handle kernel paging request at
dcaea360" are probably all right, my best guess is that the insn used
to read the pmd is unexpected.
