Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1FMPmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:42:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39410 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083Ab1FMPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:42:10 -0400
Date: Mon, 13 Jun 2011 16:44:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, greg@kroah.com
Subject: Re: [PATCH 14/15] gma500: nuke the PSB debug stuff
Message-ID: <20110613164403.4cb74675@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=WhtbST=GxP9Q03L0bhppFuozjsw@mail.gmail.com>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
	<20110608101515.9478.67943.stgit@localhost.localdomain>
	<BANLkTikYtLExBTcYAwicjEH=1bQp28WitQ@mail.gmail.com>
	<20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
	<1307615814.5963.2.camel@t60prh>
	<BANLkTikvteDhzirKUxDcnD8dykw_00ec=A@mail.gmail.com>
	<20110609130431.0c29218a@lxorguk.ukuu.org.uk>
	<BANLkTi=WhtbST=GxP9Q03L0bhppFuozjsw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Given that I've mucked around in drm_mm quite a bit I'd be very interested
> in your opinion about what's weird in it (and presumably what could be
> improved). Can you elaborate?

Mostly the API, which is also somewhat poorly documented. I've not dug
into the internals beyond trying to figure out how to use it. Looking at
the users the API is non-obvious, the interface involves a mix of calls
and digging deep into struct internals.

I'd have expected an API that had allocate/free type methods and exposed
the needed information directly or very easily not one that has drivers
doing. drm_sman seems to be attempt in that direction but its also rather
odd with interfaces like


        item = drm_sman_alloc(&dev_priv->sman, mem->type, tmpSize, 0,
                              (unsigned long)file_priv);
        mutex_unlock(&dev->struct_mutex);
        if (item) {
                mem->offset = ((mem->type == VIA_MEM_VIDEO) ?
                              dev_priv->vram_offset :
        dev_priv->agp_offset) + (item->mm->
                     offset(item->mm, item->mm_info) <<
        VIA_MM_ALIGN_SHIFT); mem->index = item->user_hash.key;


where the item->... gymnastics are spectacular to say the least given the
basic function of the allocator appears to be to provide said offset in
the first place.

And ultimately this is why I went with using allocate_region and friends
plus using GEM to do handles, which was a good choice for other reasons
as GEM is rather nicely designed barring the lack of a couple of helpers
and the few lines needed to split the shmem/handle abstraction properly.

Possibly drm_sman and friends should just wrap whatever simple native
allocator exists on the OS ?

Alan


