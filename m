Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0IAXJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:09:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37603 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab0IAXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rK8MeZ9ZJBCK/VtsvotKULdYrE21ftTqJYMR2EaasRgtkWOd8EfT44JevPJf+9kR5q
         3J4mdveNDvDWNYDRU7GN5V2H+yKlPLVCaqUI0M74dEuTm09hBIwL/o0kG6yFsAuv72hf
         0Flfrn1nSeiL3DDcZ6pGyWnac3/1MeAGRnmlI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinHOpcdAJd0_4G=OFAnMZaXKeOsqnbjJMAxCume@mail.gmail.com>
References: <201008271537.35709.ptesarik@suse.cz>
	<987664A83D2D224EAE907B061CE93D53015D91D6F5@orsmsx505.amr.corp.intel.com>
	<987664A83D2D224EAE907B061CE93D53015D9B14DC@orsmsx505.amr.corp.intel.com>
	<201008302341.14312.ptesarik@suse.cz>
	<AANLkTin4cn84xu3go-Tj-CYSLp0W6uO1HRtA6_CQu8nJ@mail.gmail.com>
	<AANLkTinHOpcdAJd0_4G=OFAnMZaXKeOsqnbjJMAxCume@mail.gmail.com>
Date: Wed, 1 Sep 2010 16:09:18 -0700
X-Google-Sender-Auth: WmdGb1KH5YpFgfZQpEAhf2iw73w
Message-ID: <AANLkTikUrNcuZB_CFn5cGFovN8U4eyPGL=nEdSP3JS9Z@mail.gmail.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
From: Tony Luck <tony.luck@intel.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Hedi Berriche <hedi@sgi.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More results from other experiments ...

1) It occurred to me that I should check that these test cases weren't
hitting some other problem in 2.6.36-rc3. So I ported the 64-bit
version of ticket locks to the current kernel and ran the stress test.
It was still going strong at 16 hours (where all my other experiments
tend to fail at 90 minutes or less).

2) Next I investigated whether wrap-around was related by reducing
TICKET_BITS from 15 to 8 (I only have 32 cpus, so this should be
plenty). I also moved the bit offset of the "now serving" value to
different spots in the high half of the lock to check whether we were
hitting some issues with overflow from the fetchadd on the low half
into the high half, or some sign problem when bit 31 was set.  These
tests all failed in 20 minutes to an hour (not significantly different
from TICKET_BITS=15) ... so wraparound appears not to be an issue.

3) Then I wondered whether it was a problem that we used fetchadd4
which modifies all 32 bits in an atomic instruction when acquiring the
lock, but a simple st2 to write just the upper 16 bits when doing the
unlock. So I recoded __ticket_spin_unlock() to spin on a cmpxchg call
to update all 32-bits with an atomic instruction. This one failed in
34 minutes.

4) Memory ordering? I added ia64_mf() calls liberally throughout all
the __ticket_* routines. Kernel failed in 32 minutes.

Summary: the only change that helps is the 64-bit ticket locks.

-Tony
