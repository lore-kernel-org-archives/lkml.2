Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0HMXiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:38:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46710 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0HMXiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gAiqHjusiHRimrhPYGifwQ1k+ZwqU64pGJV8MbhmEU/6DlpzSGJa11ZwbmTUvANlBm
         0zztKfCzl+WiPIpLjI2GashFv57TbZqK0r7z3s/sQKiSQOZyb6D6Gm0S2HNLOJ/sxHEf
         cCqRIU75doYRM08Nk1BZzNDlqzsYhAeWqkOoA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=c9DsAZArMpbz-7wUmR3nPQyAsOyOYxmeKh=2Q@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
	<AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
	<AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
	<AANLkTiny_GOfvX-t=SoXZVi8uO3SHC_h2YgbPtCcLXcu@mail.gmail.com>
	<AANLkTin6cHofTWkAysi_hojxaYUJtXg44_F0AyffMy5k@mail.gmail.com>
	<AANLkTi=hW0ceGxAPko4qG6uRz6tSEQEdzxRdeKWMueiz@mail.gmail.com>
	<AANLkTi=c9DsAZArMpbz-7wUmR3nPQyAsOyOYxmeKh=2Q@mail.gmail.com>
Date: Fri, 13 Aug 2010 16:38:02 -0700
Message-ID: <AANLkTi=o6g2cxcL_F-ZTZZkMUFT39jLtyRdTigZRbA5o@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aha!. I think I found it.

This embarrassing declaration in ia64's asm/atomic.h:

static __inline__ int
ia64_atomic64_add (__s64 i, atomic64_t *v)

looks to be the key.  Obviously it would be better to return all
64 bits of the answer using "long" rather than just 32 bits with "int".
The critical change in the rwsem code that exposed this silliness
is:

-           (rwsem_atomic_update(0, sem) & RWSEM_ACTIVE_MASK))
-               /* Someone grabbed the sem already */
+           rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS)
+               /* Someone grabbed the sem for write already */

i.e. the old code only looked at the low 32-bits of the return value
(RWSEM_ACTIVE_MASK is 0xffffffff) - so the truncation didn't
matter.

ia64_atomic64_add() has been broken like this since before the
dawn of git time in 2.6.12. Obviously we haven't been using
atomic64_t much.

Running a new test now. 12 iterations so far (which is slightly
further than this test usually gets ... but I'll let it run for a few
more hours before declaring victory).

-Tony
