Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1HCTQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:16:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63741 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab1HCTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:16:44 -0400
Date: Wed, 3 Aug 2011 23:16:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm: optimize exit_shm()
Message-ID: <20110803191639.GA6306@albatros>
References: <20110803140456.GA14393@redhat.com>
 <20110803182417.GA2510@albatros>
 <20110803182826.GB2865@albatros>
 <CAOLZvyFQPCsU7bnyv=iyz3FSBF72iYiLGKarvCfq6Z=2i_bOVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOLZvyFQPCsU7bnyv=iyz3FSBF72iYiLGKarvCfq6Z=2i_bOVw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manuel,

On Wed, Aug 03, 2011 at 21:08 +0200, Manuel Lauss wrote:
> On Wed, Aug 3, 2011 at 8:28 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > We may check .in_use == 0 without holding the rw_mutex as .in_use is int
> > and reads of ints are atomic.  As .in_use may be changed to zero while current
> > process was sleeping in down_write(), we should check .in_use once again after
> > down_write().
[...]
> > +       if (shm_ids(ns).in_use == 0)
> > +               return;
> > +
> >        /* Destroy all already created segments, but not mapped yet */
> >        down_write(&shm_ids(ns).rw_mutex);
> >        if (shm_ids(ns).in_use)
> 
> This check here is now unnecessary, yes?

No, as I said in the comment above, other task may be holding the mutex and
deleting the last shm segment.  So, current task will see in_use == 1
before down_write(), but == 0 after it.

> And this also fixes the oops.

Yes, but it only hides the real problem - tasks' dependency on initialized
init_*_ns.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
