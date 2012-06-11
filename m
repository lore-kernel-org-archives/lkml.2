Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2FKKf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:35:29 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:53406 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2FKKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:35:28 -0400
Date: Mon, 11 Jun 2012 06:34:05 -0400 (EDT)
From: Andrew Jones <drjones@redhat.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: xen-devel@lists.xensource.com, Petr Matousek <pmatouse@redhat.com>,
        Jan Beulich <jbeulich@suse.com>,
        "linux-mm@kvack.org Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Mel Gorman <mgorman@suse.de>,
        676360@bugs.debian.org, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Larry Woodman <lwoodman@redhat.com>, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [Xen-devel] [PATCH] thp: avoid atomic64_read in pmd_read_atomic for 32bit PAE\
Message-ID: <4728e392-7130-4967-aa79-8da12f929191@zmail17.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20120610020331.GA26100@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.34.1.174]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Thu, Jun 07, 2012 at 11:00:33PM +0200, Andrea Arcangeli wrote:
> > In the x86 32bit PAE CONFIG_TRANSPARENT_HUGEPAGE=y case while
> > holding
> > the mmap_sem for reading, cmpxchg8b cannot be used to read pmd
> > contents under Xen.
> > 
> > So instead of dealing only with "consistent" pmdvals in
> > pmd_none_or_trans_huge_or_clear_bad() (which would be conceptually
> > simpler) we let pmd_none_or_trans_huge_or_clear_bad() deal with
> > pmdvals
> > where the low 32bit and high 32bit could be inconsistent (to avoid
> > having to use cmpxchg8b).
> 
> <nods>
> > 
> > The only guarantee we get from pmd_read_atomic is that if the low
> > part
> > of the pmd was found null, the high part will be null too (so the
> > pmd
> > will be considered unstable). And if the low part of the pmd is
> > found
> > "stable" later, then it means the whole pmd was read atomically
> > (because after a pmd is stable, neither MADV_DONTNEED nor page
> > faults
> > can alter it anymore, and we read the high part after the low
> > part).
> > 
> > In the 32bit PAE x86 case, it is enough to read the low part of the
> > pmdval atomically to declare the pmd as "stable" and that's true
> > for
> > THP and no THP, furthermore in the THP case we also have a
> > barrier()
> > that will prevent any inconsistent pmdvals to be cached by a later
> > re-read of the *pmd.
> 
> Nice. Andrew, any chane you could test this patch on the affected
> Xen hypervisors? Was it as easy to reproduce this on a RHEL5 (U1?)
> hypervisor or is it really only on Linode and Amazon EC2?
> 

Originally, I was able to reproduce the issue easily with a RHEL5
host. Now, with this patch it's fixed.

Drew
