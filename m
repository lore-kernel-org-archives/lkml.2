Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab0J0OrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:47:03 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:39179 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab0J0OrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:47:01 -0400
Date: Wed, 27 Oct 2010 10:46:42 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 09/30] staging/vme: fill in struct device's .release,
 even if it's a NOOP
Message-ID: <20101027144642.GP10869@flamenco.cs.columbia.edu>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
 <1288055476-19438-10-git-send-email-cota@braap.org>
 <4CC804FF.9050908@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC804FF.9050908@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 11:54:55 +0100, Martyn Welch wrote:
> On 26/10/10 02:10, Emilio G. Cota wrote:
> > From: Emilio G. Cota <cota@braap.org>
> > 
> > Without it we get 32 warnings, one per device being released, when
> > removing a bridge module.
> > 
> > After applying this patch, bridge modules can at last be removed
> > without any apparent hiccup.
> > 
> > [Note: tested only on the tsi148, it's the only bridge I've got]
> > 
> 
> I guess this is an artifact of the current lack of refcounting?

No, that's orthogonal to this. This has to do with the way the
devices are allocated.

> This is definitely an issue, however I don't think masking it by adding
> an empty function is the correct way to go.

We're not masking anything. The release method is there to free the
struct it protects when its refcount goes to zero; however, in this
case the struct wasn't allocated dynamically--the 32 devices are
stored in struct vme_bridge in an array--and therefore there's
nothing to do in .release, since struct vme_bridge is freed
elsewhere.

While it's true that empty .release methods are usually frowned
upon (as stated in Documentation/kobject.txt), due to the way
things are done here it actually makes sense to have an
empty .release.

Hope this helps

		Emilio


