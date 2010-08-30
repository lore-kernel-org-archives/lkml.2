Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0H3Vkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:40:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0H3Vki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:40:38 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Date: Mon, 30 Aug 2010 23:41:13 +0200
User-Agent: KMail/1.9.10
Cc: Hedi Berriche <hedi@sgi.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201008271537.35709.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D6F5@orsmsx505.amr.corp.intel.com> <987664A83D2D224EAE907B061CE93D53015D9B14DC@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D9B14DC@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008302341.14312.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 of August 2010 20:17:25 Luck, Tony wrote:
> > I may tinker with this test a bit to include some short random
> > amounts of hold-time for the lock, and delays between attempts
> > to acquire it (to make it look more like a contended kernel lock
> > and less like a continuous queue of processes trading around a
> > lock that is never free
>
> I've been iterating ... adding new bits to try to reproduce the
> kernel environment:

Hi Tony,

I've been also playing with my test case, and I haven't been able to reproduce 
it in user-space either. One thing I noticed was the apparently incorrect use 
of ALAT. The generated code for _spin_lock_irq contains:

invala;;
ld4.c.nc r11=[r32]
// Other instructions not affecting r20
ld4.c.nc r20=[r32]

IIUC, the subsequent compare can use an undefined value (r20 is not modified 
anywhere in this function, except by the ld4.c.nc, but that happens only on 
an ALAT miss, right?).

I changed the corresponding code in __ticket_spin_lock to:

   asm volatile ("ld4.c.nc %0=[%1]" : "+r"(serve) : "r"(p) : "memory");

(NB the "+r" constraint instead of "=r")

The generated code now re-uses r15. Unfortunately, Hedi's test case still 
fails for me. :(

Petr Tesarik
