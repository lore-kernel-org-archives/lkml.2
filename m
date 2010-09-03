Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0ICAGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:06:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53847 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0ICAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=tIugu8mbQU+bkIcKAQLVYHLUEy1Wn474l2Pp1jUNQXEpG5Y0HTPv4pHI3MtI6mIWy4
         xVXW2fNPLDSgrW3E5yahxBos5jtKxZ3uuTsXUVe849OYEkteQbwXMG8etF9Q0zvHCEp6
         HO7DZB5wZSpGJR0veR22/99n4bnS2MgsspVfw=
MIME-Version: 1.0
In-Reply-To: <20100902002641.GI18967@zorg.emea.sgi.com>
References: <201008271537.35709.ptesarik@suse.cz>
	<987664A83D2D224EAE907B061CE93D53015D91D6F5@orsmsx505.amr.corp.intel.com>
	<987664A83D2D224EAE907B061CE93D53015D9B14DC@orsmsx505.amr.corp.intel.com>
	<201008302341.14312.ptesarik@suse.cz>
	<AANLkTin4cn84xu3go-Tj-CYSLp0W6uO1HRtA6_CQu8nJ@mail.gmail.com>
	<AANLkTinHOpcdAJd0_4G=OFAnMZaXKeOsqnbjJMAxCume@mail.gmail.com>
	<AANLkTikUrNcuZB_CFn5cGFovN8U4eyPGL=nEdSP3JS9Z@mail.gmail.com>
	<20100902002641.GI18967@zorg.emea.sgi.com>
Date: Thu, 2 Sep 2010 17:06:33 -0700
X-Google-Sender-Auth: YQ_kFEbYRCIqYVuu2aOHiOn9MYc
Message-ID: <AANLkTimCOWvBs1pdWeMZD9DR=u2ioFPXt7Jja73VQaZn@mail.gmail.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
From: Tony Luck <tony.luck@intel.com>
To: Tony Luck <tony.luck@intel.com>, Petr Tesarik <ptesarik@suse.cz>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's experiments were inspired by Petr's comment at the start of this thread:

   "Interestingly, CPU 5 and CPU 7 are both granted the same ticket"

I added an "owner" element to every lock - I have 32 cpus, so I made
it "unsigned int". Then added to the lock and trylock paths code to
check that owner was 0 when the lock was granted, followed by:
lock->owner |= (1u << cpu);  Then in the unlock path I check that just
the (1u << cpu) bit is set before doing: lock->owner &= ~(1u << cpu);

In my first test I got a hit. cpu28 had failed to get the lock and was
spinning holding ticket "1". When "now serving" hit 1, cpu28 saw that
the owner field was set to 0x1, indicating that cpu0 had also claimed
the lock. The lockword was 0x20002 at this point ... so cpu28 was
correct to believe that the lock had been freed and handed to it.  It
was unclear why cpu0 had muscled in and set its bit in the owner
field. Also can't tell whether that was a newly allocated lock, or one
that had recently wrapped around.

Subsequent tests have failed to reproduce that result - system just
hangs without complaining about multiple cpus owning the same lock at
the same time - perhaps because of the extra tracing I included to
capture more details.

-Tony
