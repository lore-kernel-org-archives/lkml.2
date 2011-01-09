Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab1AIEs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 23:48:56 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36537 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911Ab1AIEsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 23:48:55 -0500
Date: Sat, 8 Jan 2011 22:48:48 -0600
From: Jack Steiner <steiner@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cl@linux.com
Subject: Panic caused by PTE corruption - 2.6.32 distro kernel
Message-ID: <20110109044848.GA20375@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A long shot but I'm hoping someone has seen corruption like this
before.

System is running a 2.6.32 distro kernel on a large x86_64 Nehalem system.
During the last 4+ months we have seen 3 instances of panic's caused by a
spurious bit 48 being set in a page table. So far, we are unable to
reliably duplicate the problem but it has occured on multiple systems. We
have not seen any other strange failures caused by memory corruption.  The
bug only hits bit 48 in PTEs.

Has anyone seen anything like this before or have any ideas? Note
that the system has several non-distro drivers. We have no
reason to believe these drivers are related but can't rule it out.

Here is a detailed analysis of the first failure. The other failures are
similar.

--------------------------------

Failure occurred because a user-mode page-table-walk found a page table
entry with a reserved bit set.

        <1> engine_par: Corrupted page table at address 20705808
        <4> PGD 7cf83c8b067 PUD 7ccd3170067 PMD 7e7f8c46067 PTE 800107e1d43f5067
        <0> Bad pagetable: 000f [#1] SMP
                              ^--- bit 3 ==> reserved bit is set in a PT entry

        PGD      7cf83c8b067
        PUD      7ccd3170067
        PMD      7e7f8c46067
        PTE 800107e1d43f5067
               ^------- ???


Note bit 48 in the PTE. This bit should not be set. Failure left no trace
that I could find.  Other observations:

Failing process is:
        0xffff8fcff6942140   237757   237716  1 1010   R  0xffff8fcff69427d0 *engine_par

Appears to be a big MPI job (hybrid???)


Other entries in the PT close to the corrupted entry look reasonable:
        0xffff8fe7f8c46800 800007e1d43f0067 800007e1d43f1067
        0xffff8fe7f8c46810 800007e1d43f2067 800007e1d43f3067
        0xffff8fe7f8c46820 800007e1d43f4067 800107e1d43f5067 << has bad entry
        0xffff8fe7f8c46830 800007e1d43f6067 800007e1d43f7067
        0xffff8fe7f8c46840 800007e1ab590067 800007e1ab591067
        0xffff8fe7f8c46850 800007e1ab592067 800007e1ab593067
        0xffff8fe7f8c46860 800007e1ab594067 800007e1ab595067
        0xffff8fe7f8c46870 800007e1ab596067 800007e1ab597067


A second failure:
	0xffff8dbff5a34a70 800005bcdd382067 800005bcdd383067
	0xffff8dbff5a34a80 800005bcdd384067 800005bcdd385067
	0xffff8dbff5a34a90 800005bcdd386067 800005bcdd387067
	0xffff8dbff5a34aa0 800005bcdd388067 800105bcdd389067  << has bad entry
	0xffff8dbff5a34ab0 800005bcdd38a067 800005bcdd38b067
	0xffff8dbff5a34ac0 800005bcdd38c067 800005bcdd38d067
	0xffff8dbff5a34ad0 800005bcdd38e067 800005bcdd38f067
	0xffff8dbff5a34ae0 800005bcdd390067 800005bcdd391067

---
Jack Steiner (steiner@sgi.com)
SGI - Silicon Graphics, Inc.

