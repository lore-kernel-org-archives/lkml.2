Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0HDRgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:36:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50620 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0HDRgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tM6mYE+S9zNk+1EQ8U1z9pllVjQRCtHsZ/XIyy4Zo1Y6M1D4AUbBrECuFXJg1LKC1+
         rhzSVUggkaL/vahKNKgp+25LtZldQWmeuOPmQMuPL65000u1dAZB3uWc9OekdtgjZYsD
         2ptPlih+5+GmjuSAAWZ10rTcPQ3h+V7PMwL5U=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008040951170.11084@router.home>
References: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com>
	<alpine.DEB.2.00.1008040951170.11084@router.home>
Date: Wed, 4 Aug 2010 20:35:59 +0300
X-Google-Sender-Auth: LeVITqnPv7smV8waN3aQ66TaCnE
Message-ID: <AANLkTikRf6r4a=XhnOJswrzHRDTb8yvCuQjD2qnh5ETt@mail.gmail.com>
Subject: Re: Using Bootmem for large DMA buffers in the presence of the slab 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        Michal Simek <michal.simek@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@petalogix.com>,
        John Williams <john.williams@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Peter Crosthwaite wrote:
>> Because the buffer was too large for kmalloc, the kmalloc call would
>> fail. I traced the alloc_bootmem_low_pages() call further and
>> discovered that since the kmalloc call was failing, it was falling
>> back to alloc_bootmem_core(). So does this mean that the bootmem
>> allocator is trying to allocate memory while the slab allocator is up
>> and running? And is this supposed to work?

On Wed, Aug 4, 2010 at 6:40 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> The bootmem allocator should not work when slab is fully up. However,
> there is a grey period where the page allocator is not fully functional
> yet but the slab allocator is mostly working.

Yup, the WARN_ON there means that someone is calling the bootmem
allocator after slab is up and running and the call-site needs to be
fixed. The slab fallback is there for convenience so that we don't
crash the kernel during bootup and it's not supposed to work for large
allocations.

                        Pekka
