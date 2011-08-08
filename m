Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1HHJOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:14:55 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:57973 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1HHJOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:14:54 -0400
Date: Mon, 8 Aug 2011 05:14:32 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110808091432.GA19570@flamenco.cs.columbia.edu>
References: <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
 <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
 <20110805174728.GA1741@flamenco.cs.columbia.edu>
 <4E3F97EA.2020600@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3F97EA.2020600@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 09:01:46 +0100, Martyn Welch wrote:
> On 05/08/11 18:47, Emilio G. Cota wrote:
> > A driver leaking a resource will then leave a bogus refcount
> > Refcounting must be kept simple & stupid; doing it behind the
> > backs of the drivers we're trying to protect is a mistake.
> 
> I just simply disagree. Forcing each driver to specifically maintain the
> refcount is just stupid when an alternative is possible.

Martyn, no one in the kernel is doing what you propose, for
good reason. Look at USB, PCI, RapidIO.  They all provide get
and put functions to be called from probe and release.

Doing otherwise is a bug. If a driver needs a resource *not
necessarily at .probe time*, it increments the refcount
then (in .probe) to make sure that the parent driver won't
be removed. IOW if you increase the refcount in the bridge
driver only when a resource is requested you're doomed,
because when the non-probe request arrives, the bridge driver
may have been removed already.. And the kernel gently reminds
you of this fact in the form of an oops.

There is a technical reason why we want drivers to explicitly
manage refcounts in the device hierarchy. It's the sane thing
to do.

		Emilio
