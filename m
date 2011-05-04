Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1EDN7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:59:33 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:43772 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752556Ab1EDN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:59:32 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jO0HCdwVM1l3R161nDXbwCeN85x68dcGSCiiiHwEWSLwCi_
 0WZC0BszbtdRZSA1w_T298BfpwVNLjFaLBug74z27fM7nNDxmAjeDx8bNZFe
 ab1OZcxedkf4CS7adDUkVWIRMWVtU45ihND5jy4HhXQbX1DJ0SKvslMnSkPS
 0LCCvbh_6dbWd0B7b_A6bSrCCMlLDGgSSbImIKlP4HMTTHAjKcq3qr_vRKlq
 uh7_bLrgKIT6Q2tGfJ6MZ7hhGLRBZ5aVPaKEo3ArHURQnC_k.1iGOdxDW4GH
 hu8gXOkdDgdTatJxFmOvZJ79XlLwD9ycvW6M690LTXLp3U8LHSmyPDUCKkEQ
 kT_RJzmToxQHr7yFnH4UM4A61
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 08:59:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
In-Reply-To: <alpine.DEB.2.00.1105031538470.27795@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105040851090.5495@router.home>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg> <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com> <1304026464.2598.36.camel@mulgrave.site> <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
 <BANLkTimT4899xDF99Fj37u_CgnkeBzoFzQ@mail.gmail.com> <alpine.DEB.2.00.1105031538470.27795@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011, David Rientjes wrote:

> So we're in the unfortunate position where slub works fine for some
> architectures with DISCONTIGMEM and not with others.  It seems like the
> problems originating on James' hppa aren't related to slab allocation at
> all, though, so I'm wondering if we should rethink disallowing SLUB as it
> sits in Linus' tree right now for everything that uses DISCONTINGMEM
> without NUMA and not force them to enable CONFIG_BROKEN?
>
> Perhaps change the kconfig entry to only block slub for parisc instead?

As i have explained multiple times before: This is a generic issue with a
kernel configuration that has DISCONTIGMEM on and NUMA configured off.
Core code in various subsystems makes various assumptions in the !NUMA
case. F.e. page_to_nid(page) == 0. Slub is one of them.

DISCONTIGMEM works fine on !NUMA if it just has a single node which is 0.
But in James' hppa we have multiple nodes and thus a fundamental problem
with node 1 existing in a non NUMA environment. We then have a strange
mixture of NUMA nodes existing in DISCONTIGMEM code and the core code
assuming there are none. This can lead to numerous weird problems.

IMHO A config broken for DISCONTIG and !NUMA for arches that can actually
use multiple DISCONTIG nodes would be the proper thing.

