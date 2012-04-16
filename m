Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2DPOGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:06:33 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34989 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2DPOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:06:30 -0400
Date: Mon, 16 Apr 2012 16:06:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 00/13] Convert EDAC internal strutures to support all
 types of Memory Controllers
Message-ID: <20120416140615.GE308@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <20120402135959.GC24238@aftab>
 <4F8C176F.5020706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F8C176F.5020706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 09:58:23AM -0300, Mauro Carvalho Chehab wrote:
> That's weird. Maybe it was just a temporary error at vger. I'll contact vger
> maintainers in order to double check what's happening there.

No, not weird. You're probably hitting some limit on patch mail size (it
was 40K AFAICR) and your patch is 156K.

> > And what a patch it is: almost 5000 lines.
> 
> No. It is half of it (2449 lines):

$ wc -l 05-edac-fix-fore-support-for-mcs-that-see-dimms.patch
4642 05-edac-fix-fore-support-for-mcs-that-see-dimms.patch

[..]

> No way. Applying just the include/linux/edac.h changes:
> 
> drivers/edac/edac_mc.c: In function ‘edac_mc_dump_channel’:
> drivers/edac/edac_mc.c:47:2: error: ‘struct dimm_info’ has no member named ‘ce_count’

[..]

> The changes at edac.h are replacing the csrow-dependent broken
> internal ABI to a csrow-independent one. Due to that single change,
> all existing code needs to be touched.

Ok let me spell it:

* Add a patch which only _adds_ the changes to <include/linux/edac.h>, i.e.:

enum hw_event_mc_err_type, edac_mc_layer_type, GET_POS macro and that's it -
this is your first patch out of this monster and the changes there are easily
verifiable when looking at it.

* Then, add a patch which introduces dimm_info->location[] array along with code
that touches it (if possible).

* Then, add a patch which adds dimm_info->mci which is the parent (it
should be called parent_mci btw) and all code that touches it.

...

* Add a patch which adds ->csrow and ->cschannel _without_ removing
->ce_count so that drivers still build.

* Then, after you've switched code to use ->csrow and ->cschannel,
remove ->ce_count.

* Then, after you've converted the data structures properly, you can
always adjust the functions in later patches.

* Then, documentation pointers to memory controllers can go into a
different patch.

* edac_mc_dump_dimm() is yet another patch.

...

Do you catch my drift?

All I'm trying to explain to you is that a reviewer needs small
patches, each patch touching a _single_ thing so that it is easily
understandable what you're changing.

Then, it is much easily debuggable than with a 5000 lines single
monster.

Also, look at Documentation/SubmittingPatches which has some more good
advice. Hint: "If you cannot condense your patch set into a smaller set
of patches, then only post say 15 or so at a time and wait for review
and integration."

> > * changes to edac_mc_alloc
>
> Those are also related with the edac.h changes: the data got moved
> from one place to another one, some fields disappeared, others
> appeared.

As said above, split changing of those members in single patches.

And so on...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
