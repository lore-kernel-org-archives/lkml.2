Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0LWK4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:56:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:60061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab0LWK4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:56:47 -0500
Subject: Re: + kmap-types-clean-up-and-optimization.patch added to -mm tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org,
        hpa@zytor.com
In-Reply-To: <4D1336DE020000780002977F@vpn.id2.novell.com>
References: <201012222248.oBMMmbcF023808@imap1.linux-foundation.org>
	 <1293098310.2170.415.camel@laptop>
	 <4D1336DE020000780002977F@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 11:56:45 +0100
Message-ID: <1293101805.2170.514.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 10:47 +0000, Jan Beulich wrote:
> >>> On 23.12.10 at 10:58, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Wed, 2010-12-22 at 14:48 -0800, akpm@linux-foundation.org wrote:
> >> The patch titled
> >>      kmap-types: clean up and optimization
> >> has been added to the -mm tree.  Its filename is
> >>      kmap-types-clean-up-and-optimization.patch
> >> 
> >> Before you just go and hit "reply", please:
> >>    a) Consider who else should be cc'ed
> >>    b) Prefer to cc a suitable mailing list as well
> >>    c) Ideally: find the original patch on the mailing list and do a
> >>       reply-to-all to that, adding suitable additional cc's
> >> 
> > 
> >> ------------------------------------------------------
> >> Subject: kmap-types: clean up and optimization
> >> From: "Jan Beulich" <JBeulich@novell.com>
> >> 
> >> Several of the types aren't being used at all anymore - those can be
> >> deleted altogether.  
> > 
> > NO! That's wrong, in fact non of them are being used, but removing them
> > will decrease the number of kmap_atomic slots, but those are still being
> > used.
> 
> Would you mind pointing out examples of such uses (i.e. without
> the proper enumerator)? How would those avoid collisions with
> actually used slots?

Nobody uses explicit slots anymore:

/*
 * Make both: kmap_atomic(page, idx) and kmap_atomic(page) work.
 */
#define kmap_atomic(page, args...) __kmap_atomic(page)

All instances of KM_foo are deprecated and in need of a cleanup.
See commit: 3e4d3af501cccdc8a8cca41bdbe57d54ad7e7e73

> > Feh, its only a few pages and since there is no way to actually tell if
> > you've got enough kmap atomic pages other than experiencing runtime
> > errors, removing them must be done with utmost prudence.
> 
> Whether 2Mb of lowmem is "only a few pages" certainly depends
> on the perspective you take.
> 
> And even then - shouldn't the bad (non-enumerated) uses of
> atomic kmap-s be fixed rather than keeping unused entries in
> the enumeration just because there is broken code somewhere?

With the current 20 slots on x86, its 80k per CPU, you need 25 CPUs to
cross the 2M boundary, 32bit kernels having that many CPUs deserve to
suffer.


