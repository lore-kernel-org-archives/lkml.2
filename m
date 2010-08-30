Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0H3Wn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:43:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41628 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab0H3WnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eVB+b4yBZmBf+tdFEm/3e6r05AQ8xhWWPdrrQIrQbXjkM1oEHjQ4uirQ87d9BnDDXz
         tgqp/vnvaqOGikMaMBRYUZjHSy0iWcaRJiw3lLwRR0bmMP2N1XeFG6wxHg0+2lRLGeRL
         LHbM7TN/QuILxdhXQs5iq062U4uGJE+Cl8OCA=
MIME-Version: 1.0
In-Reply-To: <201008302341.14312.ptesarik@suse.cz>
References: <201008271537.35709.ptesarik@suse.cz>
	<987664A83D2D224EAE907B061CE93D53015D91D6F5@orsmsx505.amr.corp.intel.com>
	<987664A83D2D224EAE907B061CE93D53015D9B14DC@orsmsx505.amr.corp.intel.com>
	<201008302341.14312.ptesarik@suse.cz>
Date: Mon, 30 Aug 2010 15:43:23 -0700
X-Google-Sender-Auth: BrnsgEIQEaw4M5lb3Lz_S6Fs8CY
Message-ID: <AANLkTin4cn84xu3go-Tj-CYSLp0W6uO1HRtA6_CQu8nJ@mail.gmail.com>
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

On Mon, Aug 30, 2010 at 2:41 PM, Petr Tesarik <ptesarik@suse.cz> wrote:
> IIUC, the subsequent compare can use an undefined value (r20 is not modified
> anywhere in this function, except by the ld4.c.nc, but that happens only on
> an ALAT miss, right?).

I don't see that in my kernel - but you raise a good point. The idea in this
code is that invala makes sure that we don't have a matching ALAT entry
on the first iteration of the loop, so we will do the load. Then we loop not
actually doing the access until the ALAT tells us that the location may
have changed, when we load again.  But this assumes that the compiler
didn't decide to re-use the register for something else in the loop. So
things may be a bit fragile if some aggressive optimization happen after
the routine is inlined.

Does Hedi's test fail for you if you drop the fancy ALAT trick?
I.e. just use "serve = *p;" in __ticket_spin_lock()? [& similar in
__ticket_spin_unlock_wait() if you want - but I don't think that
is ever used for siglock]

-Tony
