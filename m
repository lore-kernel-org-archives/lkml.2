Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab1FKQEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 12:04:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53080 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1FKQEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 12:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=N30yYE23ss/2fW+CojMncmhSEOvnEqlFImbv0wMGsgf85tBPcKXeX1S1i2azDzdK+b
         Mt3ai9mZXa9qUmiIqZ/w==
Date: Sat, 11 Jun 2011 09:04:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Ying Han <yinghan@google.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [BUGFIX] update mm->owner even if no next owner.
In-Reply-To: <BANLkTi=bBSeMFtUDyz+px1Kt34HDU=DEcw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1106110847190.29336@sister.anvils>
References: <20110609212956.GA2319@redhat.com> <BANLkTikCfWhoLNK__ringzy7KjKY5ZEtNb3QTuX1jJ53wNNysA@mail.gmail.com> <BANLkTikF7=qfXAmrNzyMSmWm7Neh6yMAB8EbBp7oLcfQmrbDjA@mail.gmail.com> <20110610091355.2ce38798.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1106091812030.4904@sister.anvils> <20110610113311.409bb423.kamezawa.hiroyu@jp.fujitsu.com> <20110610121949.622e4629.kamezawa.hiroyu@jp.fujitsu.com> <20110610125551.385ea7ed.kamezawa.hiroyu@jp.fujitsu.com> <20110610133021.2eaaf0da.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1106101425400.28334@sister.anvils> <BANLkTi=bBSeMFtUDyz+px1Kt34HDU=DEcw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1115670598-1307808256=:29336"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1115670598-1307808256=:29336
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 11 Jun 2011, Hiroyuki Kamezawa wrote:
> 2011/6/11 Hugh Dickins <hughd@google.com>:
> > On Fri, 10 Jun 2011, KAMEZAWA Hiroyuki wrote:
> >>
> >> I think this can be a fix.
> >
> > Sorry, I think not: I've not digested your rationale,
> > but three things stand out:
> >
> > 1. Why has this only just started happening? =A0I may not have run that
> > =A0 test on 3.0-rc1, but surely I ran it for hours with 2.6.39;
> > =A0 maybe not with khugepaged, but certainly with ksmd.
> >
> Not sure. I pointed this just by review because I found "charge" in
> khugepaged is out of mmap_sem now.

Right, Andrea's patch cited below.

>=20
> > 2. Your hunk below:
> >> - =A0 =A0 if (!mm_need_new_owner(mm, p))
> >> + =A0 =A0 if (!mm_need_new_owner(mm, p)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rcu_assign_pointer(mm->owner, NULL);
> > =A0 is now setting mm->owner to NULL at times when we were sure it did =
not
> > =A0 need updating before (task is not the owner): you're damaging mm->o=
wner.
> >
> Ah, yes. It's my mistake.
>=20
> > 3. There's a patch from Andrea in 3.0-rc1 which looks very likely to be
> > =A0 relevant, 692e0b35427a "mm: thp: optimize memcg charge in khugepage=
d".
> > =A0 I'll try reproducing without that tonight (I crashed in 20 minutes
> > =A0 this morning, so it's not too hard).

I had another go at reproducing it, 2 hours that time, then a try with
692e0b35427a reverted: it ran overnight for 9 hours when I stopped it.

Andrea, please would you ask Linus to revert that commit before -rc3?
Or is there something else you'd like us to try instead?  I admit that
I've not actually taken the time to think through exactly how it goes
wrong, but it does look dangerous.

The way I reproduce it is with my tmpfs kbuilds swapping load,
in this case restricting mem by memcg, and (perhaps the important
detail, not certain) doing concurrent swapoff/swapon repeatedly -
swapoff takes another mm_users reference to the mm it's working on,
which can cause surprises.

Hugh
--8323584-1115670598-1307808256=:29336--
