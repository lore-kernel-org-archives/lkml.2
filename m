Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1BGXUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:20:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab1BGXUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:20:53 -0500
Date: Tue, 8 Feb 2011 00:20:45 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
Message-ID: <20110207232045.GJ3347@random.random>
References: <4CB76E8B.2090309@goop.org>
 <4CC0AB73.8060609@goop.org>
 <20110203024838.GI5843@random.random>
 <4D4B1392.5090603@goop.org>
 <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4C6F45.6010204@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 01:27:33PM -0800, Jeremy Fitzhardinge wrote:
> No, I don't think there's any xen-specific code which calls mmdrop (at
> all, let alone in interrupt context).  Erm, but I'm not sure where it
> does.  I had a thinko that "schedule" would be one of those places, but
> calling that from interrupt context would cause much bigger problems :/
> > static void pgd_dtor(pgd_t *pgd)

I checked again and I don't see exactly where mmdrop or __mmdrop are
called from irq context.

> No.  I don't think I wrote that comment.  It possibly just some ancient
> lore that could have been correct at one point, or perhaps it never true.

I agree with that. But it'd be nice of more people could look into
that so we at least can remove the misleading comment.

Where else can the pgd_lock be taken from irq context? Can we fix the
deadlock with NR_CPUS < 4 with my patch? (with the ,flags removed from below?)


> 
> >>> @@ -247,7 +248,7 @@ void vmalloc_sync_all(void)
> >>>  			if (!ret)
> >>>  				break;
> >>>  		}
> >>> -		spin_unlock_irqrestore(&pgd_lock, flags);
> >>> +		spin_unlock(&pgd_lock, flags);
> >> Urp.  Did this compile?
> > Yes it builds
> 
> (spin_unlock() shouldn't take a "flags" arg.)
> 
> 
> > I'm not reposting a version that builds for 32bit x86 too until we
> > figure out the mmdrop thing...
> 
> Stick it in next and look for explosion reports?

I intended to correct that of course, I just meant it is no problem
for 64bit builds and that's why I didn't notice the build failure
before posting the patch. Clearly 32bit build would have failed ;).
