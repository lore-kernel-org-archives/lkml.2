Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab1CCUv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:51:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48601 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab1CCUvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:51:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=AhoXoPevAIMHdeIA5K+rbB4UQL7xd4+VCu8YhygWmg+x7ieUiRd+gcK7Yo/8jR9Wc8
         c80E5lSWjvmpRsN8SOeRuOTy0xWdk53O28O+jjGuEazwYGYkQuCSNx7GCqFTdgnc6dR4
         aII6wVeB0w7hfdsZmsG13lcO/IgOZ0Av7aVV0=
MIME-Version: 1.0
In-Reply-To: <1299174901-16762-8-git-send-email-iws@ovro.caltech.edu>
References: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
	<1299174901-16762-8-git-send-email-iws@ovro.caltech.edu>
Date: Thu, 3 Mar 2011 12:51:14 -0800
X-Google-Sender-Auth: qJIzLLImZvkSB6g1C7uY4tcjOZA
Message-ID: <AANLkTik6G6zh+=-5pJZRWBcQXry=3DUrc=CQ+QNbsSuH@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] fsldma: support async_tx dependencies and
 automatic unmapping
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com, "Koul, Vinod" <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 9:54 AM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> Previous to this patch, the dma_run_dependencies() function has been
> called while holding desc_lock. This function can call tx_submit() for
> other descriptors, which may try to re-grab the lock. Avoid this by
> moving the descriptors to be cleaned up to a temporary list, and
> dropping the lock before cleanup.
>
> At the same time, add support for automatic unmapping of src and dst
> buffers, as offered by the DMAEngine API.

Unfortunately, this may be a short lived addition as Russell has put
the the kibosh on how the dmaengine api supports dependencies and
automated unmapping [1].  It really needs to be up to the client to
maintain all the mappings until the dma operation is complete.  If we
cross dma mapping domains we need to queisce operations, remap the
buffers and submit the dma to the next channel.  The current approach
of using overlapping mappings is broken on at least ARM v6+ platforms.

So I need to rework how md raid submits dependencies and manages the
dma mapping api, and will most likely end up removing dependency
support from the api as I do not see a clean way for this to be
automated behind the client's back.  Mapping needs to be sole
responsibility of the client.

Other than that this patch looks good.

--
Dan

[1] http://marc.info/?l=linux-raid&m=129407256602759&w=2
