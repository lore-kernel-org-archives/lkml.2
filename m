Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0KIKhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:37:43 -0500
Received: from smtp-out-105.synserver.de ([212.40.180.105]:1055 "HELO
	smtp-out-105.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755176Ab0KIKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:37:42 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 26341
Date: Tue, 9 Nov 2010 11:37:37 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Radeon RS780 - BUG: unable to handle kernel NULL pointer
 dereference
Message-ID: <20101109103737.GA1767@arch.trippelsdorf.de>
References: <20101108170221.GA1602@arch.trippelsdorf.de>
 <20101108170737.GA1617@arch.trippelsdorf.de>
 <20101108184301.GA1614@arch.trippelsdorf.de>
 <20101108190258.GA1623@arch.trippelsdorf.de>
 <AANLkTi=fo3rnBp8Fs6H+ivP6R+x=QDzBLyi+DmT-LNHV@mail.gmail.com>
 <4CD879BC.5060008@vmware.com>
 <20101109092920.GA1542@arch.trippelsdorf.de>
 <4CD91A07.1060308@vmware.com>
 <4CD91D58.7080508@vmware.com>
 <1289298777.10682.63.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289298777.10682.63.camel@thor.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:32:57AM +0100, Michel Dänzer wrote:
> On Die, 2010-11-09 at 11:07 +0100, Thomas Hellstrom wrote: 
> > On 11/09/2010 10:53 AM, Thomas Hellstrom wrote:
> > > On 11/09/2010 10:29 AM, Markus Trippelsdorf wrote:
> > >> OK I've found the buggy commit by bisection:
> > >>
> > >> e376573f7267390f4e1bdc552564b6fb913bce76 is the first bad commit
> > >> commit e376573f7267390f4e1bdc552564b6fb913bce76
> > >> Author: Michel Dänzer<daenzer@vmware.com>
> > >> Date:   Thu Jul 8 12:43:28 2010 +1000
> > >>
> > >>      drm/radeon: fall back to GTT if bo creation/validation in VRAM 
> > >> fails.
> > >>
> > >>      This fixes a problem where on low VRAM cards we'd run out of 
> > >> space for validation.
> > >>
> > >>      [airlied: Tested on my M7, Thinkpad T42, compiz works with no 
> > >> problems.]
> > >>
> > >>      Signed-off-by: Michel Dänzer<daenzer@vmware.com>
> > >>      Cc: stable@kernel.org
> > >>      Signed-off-by: Dave Airlie<airlied@redhat.com>
> > >>
> > >> Please note that this is an old commit from 2.6.36-rc. When I revert 
> > >> it the
> > >> kernel no longer crashes. Instead I see the following in my dmesg:
> > >>
> > >
> > > Hmm, so this sounds like something in the Radeon eviction error path 
> > > is causing corruption.
> > > I had a similar problem with vmwgfx, when I tried to unref a BO 
> > > _after_ ttm_bo_init() failed.
> > > ttm_bo_init() is really supposed to call unref itself for various 
> > > reasons,  so calling unref() or kfree() after a failed ttm_bo_init() 
> > > will cause corruption.
> > >
> > > In any case, the error below also suggests something is a bit fragile 
> > > in the Radeon driver:
> > >
> > > First, an accelerated eviction may fail, like in the message below, 
> > > but then there must always be a backup plan, like unaccelerated 
> > > eviction to system. On BO creation, there are a number of placement 
> > > strategies, but if all else fails, it should be possible to initially 
> > > place the BO in system memory.
> > >
> > > Second, If bo validation fails during a command submission, due to 
> > > insufficient VRAM / TT, then the driver should retry the complete 
> > > validation cycle after first blocking all other validators and then 
> > > evicting everything not pinned, to avoid failures due to fragmentation.
> > >
> > > /Thomas
> > >
> > 
> > Indeed, it seems like the commit you mention just retries ttm_bo_init() 
> > after it previously failed. At that point the bo has been destroyed, so 
> > that is probably what's causing the BUG you are seeing.
> > 
> > Admittedly, ttm_bo_init() calling unref on failure is not properly 
> > documented in the function description.  The reason for doing so is to 
> > have a single path for freeing all BO resources already allocated on the 
> > point of failure.
> 
> Does the patch below fix the problem?

Yes, indeed. I was just about to send the same patch to the list.

Thanks.
-- 
Markus
