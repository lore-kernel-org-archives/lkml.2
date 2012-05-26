Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2EZSHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 14:07:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57900 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2EZSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 14:07:15 -0400
Date: Sat, 26 May 2012 11:06:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sam Portolla <samportolla@yahoo.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, "kaber@trash.net" <kaber@trash.net>,
        "jarkao2@gmail.com" <jarkao2@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)
In-Reply-To: <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com>
Message-ID: <alpine.LSU.2.00.1205261033500.2033@eggly.anvils>
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com> <alpine.LSU.2.00.1205191301430.10539@eggly.anvils> <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1719654220-1338055614=:2033"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1719654220-1338055614=:2033
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 25 May 2012, Sam Portolla wrote:
>=20
> commit 378a2f090f7a478704a372a4869b8a9ac206234e
> Date:=A0=A0 Mon Aug 4 22:31:03 2008 -0700
> net_sched: Add qdisc __NET_XMIT_STOLEN flag
=2E..
>=20
> =A0I wonder if the lack of above patch in our code base could explain the
>  exit_mmap() BUG_ON as well due to memory corruption causing MMU to not
>  be able to locate the page(s) it had to free. NR_PTES keeps track of
>  that? Could you explain that more?

I concur with Eric in thinking it unlikely - though (unlike Eric)
I know far too little about networking to comment with authority.

I'd guess that there have been literally hundreds of fixes gone into
the kernel since 2.6.23, each more likely to be the fix to such memory
corruption than this one.  And I could also be wrong in attributing
your BUG to memory corruption: perhaps I'm forgetting an mm fix.

You ask me to explain more: mm->nr_ptes keeps track of the number of
page tables that have been allocated; when we free the mm, we should
be freeing exactly the number of page tables we allocated earlier,
but a bug in the code maintaining the vmas or the page tables might
break that, hence the BUG_ON to test.  But equally, if there has been
memory corruption of vmas or of higher-level page tables, we may now
be unable to locate all the page tables we allocated earlier, and so
hit the BUG_ON for that reason.

Would I be unfair to characterize this as a problem seen once at a
customer site in the 4.5 years since 2.6.23 was released?

As I said before, please just change that BUG_ON to WARN_ON, and
wait to see if more such issues come up: if they do, then you can
start to look for a pattern.

Hugh
--8323584-1719654220-1338055614=:2033--
