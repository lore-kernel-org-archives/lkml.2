Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0EKUDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:03:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50102 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0EKUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=rocM9vOWFUnRObAXkhAh/+/TPXHfGr3SodMRMkYmuK/xuWk4wJpD1lBIyCJsi3yNNE
         Y6k/Wh23IpVOUCHC6Vd4ldiv/m1naGBitTXMJ2SThCnojvy/4Ft4bforHDIh3bEdDP9s
         75WN04OglX9uGNZgwDA6BvBUfGM2NDucxm3Jc=
MIME-Version: 1.0
In-Reply-To: <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com> 
	<1273488154-2993-1-git-send-email-os@emlix.com> <20100510142225.4bf215ef.akpm@linux-foundation.org> 
	<20100511060547.GA9644@core.coreip.homeip.net> <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com> 
	<20100511062110.GB9644@core.coreip.homeip.net> <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com> 
	<20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 May 2010 16:03:25 -0400
Message-ID: <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 02:42, Pekka Enberg wrote:
> On Tue, May 11, 2010 at 9:33 AM, Dmitry Torokhov wrote:
>>> what guarantee exactly do you have for that statement ?
>>
>> The data is kmalloced, kmalloc aligns on cacheline boundary AFAIK which
>> means that next kmalloc data chunk will not share "our" cacheline.
>
> No, there are no such guarantees. kmalloc() aligns on
> ARCH_KMALLOC_MINALIGN or ARCH_SLAB_MINALIGN depending on which is
> bigger but beyond that, there are no guarantees. You can, of course,
> use kmem_cache_create() with SLAB_HWCACHE_ALIGN to align on cacheline
> boundary.

so how is this to be addressed in general ?  this is a problem for any
device that does SPI transactions, and having every driver create its
own kmem cache isnt the answer.

do people need to kmalloc() like 2x the desired size and manually
align it themselves ?  declaring alignments on struct members doesnt
matter if the base of the struct isnt aligned.  seems like we need a
new GFP flag that says we need a cache aligned pointer so we can give
that to kmalloc() and such.
-mike
