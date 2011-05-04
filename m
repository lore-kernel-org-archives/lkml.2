Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1EDP2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:28:09 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:46089 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754282Ab1EDP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:28:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: LjZKmWUVM1nidKSwtrXCJhLiS4aEtMBjB2PI5ImgWAnJkn_
 w9nZw7WLsL1gcC.ovuOK9i8rbqippOzCuT2UAaaj.9Dl7WfpqMz3A6QNL6ue
 tXDvqdX5VFQM445iucr4cYt..asONfQ6GDdGOlBpMFBMX.b9xbWppYNtqBgd
 o0G0gYBPE6fNZyZIlnPmvTMxqTnJDj0X0hNPbXEJkkUrJmk8sBsxNsfbanGI
 vyZhVqmRhcnnuMVBfSnwntyoKpfWiTqanE2KbxTH8m3p3CnLAvZ3OkjexYzn
 RLSPrnkX90pAsdEXuU6EcmbzPmPejAa.ZS7lYkA.fe74pJrB_
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 10:28:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105041023070.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Linus Torvalds wrote:

> On Wed, May 4, 2011 at 8:00 AM, Christoph Lameter <cl@linux.com> wrote:
> >
> > Right there is only the tid management that is added. Hope I am fast
> > enough to at least get one patch in (not very well tested):
>
> So the thing that worries me about this is non-x86 architectures.
>
> Have we verified that the generic routines are ok for all
> architectures? Has somebody checked the memory barriers in particular?

There are no memory barriers used. The barrier() here is a compiler hint
to not keep data across it. This is dealing with concurrency issues on
the *same* cpu due to preemption and irqs. It avoids the interrupt
disable. There no memory barrier issues for code running on a single cpu.
The cpu is always guaranteed to have a consistent view of the data.

There is an additional patchset that also uses a cmpxchg_double for the
slowpath. There barrier issues may arise because concurrent access is
possible but that is likely to be merged only in 2.6.41. The
cmpxchg_double in that case is a locked operation.

> Things that work on x86 may not work on non-x86. Everything should be
> per-cpu _except_ for the initialization, I think, but that should be
> double-checked.

The fallback path is using interrupt disable / enable. This must be
working on all arches AFAICT.

> My gut reaction would be: let's do the minimal patch that just fixes
> things to do irqsafe_cpu_cmpxchg_double() for 2.6.39, and then let's
> remove the #ifdef'fery in -rc1. Or make _really_ sure that things are
> ok for platforms that never even triggered the CMPXCHG_LOCAL case
> before.
>
> Hmm?

Ok. Pekka can put that patch in for the next round of merges?

