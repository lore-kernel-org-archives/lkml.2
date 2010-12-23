Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0LWAxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:53:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46130 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0LWAxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:53:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hvepmcqgfV1ox33KloCB1pk2IhrppEsw4ub89aSr2TUoLQP88fkyNtU9sLq55MAbWz
         H2prPNFhVtRf/QhzJMS9ivJvHB5zgwSHiIqNAVMHXIBQFo6zHrX75k1wrY6FPeKrQqWH
         XKmOGPJijmevF6ErpayqB3nbdZtUFOkWTuy5s=
MIME-Version: 1.0
In-Reply-To: <20101222235403.GE29368@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20101222235403.GE29368@n2100.arm.linux.org.uk>
Date: Wed, 22 Dec 2010 16:53:13 -0800
X-Google-Sender-Auth: O_EL5DEsbSMe1tTfcGlNCu-45KQ
Message-ID: <AANLkTi=QzaZgFab-M0-xOVyY2RQ-Xxq2f7s+C7oCB9Uc@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 3:54 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Dec 22, 2010 at 03:45:39PM -0800, Dan Williams wrote:
>> This is listed in the dmaengine documentation [1], but I obviously
>> missed this before merging.  This also would have been caught by
>> lockdep as required by SubmitChecklist.  As far as corrective action
>> before 2.6.37-final.  It looks like this driver needs a full scrub
>> which seems unreasonable to complete and test over the holidays before
>> .37 lands.  Linus we either need to mark this "depends on BROKEN" or
>> revert it.
>>
>> Support for the DMA_COMPL flags are necessary if the DMA_MEMCPY
>> capability is advertised, yes this driver got this wrong.  I'll update
>> the documentation to make this requirement clear, and audit the other
>> drivers.  With slave-only drivers the only usage model is one where
>> the client driver owns dma-mapping.  In the non-slave (opportunistic
>> memcpy offload) case the client is unaware of the engine so the driver
>> owns unmapping.  The minimal fix is to disable memcpy offload.
>>
>> --
>> Dan
>>
>> [1]
>> 3.6 Constraints:
>> 1/ Calls to async_<operation> are not permitted in IRQ context.  Other
>>    contexts are permitted provided constraint #2 is not violated.
>> 2/ Completion callback routines cannot submit new operations.  This
>>    results in recursion in the synchronous case and spin_locks being
>>    acquired twice in the asynchronous case.
>
> (2) seems to be more than a little annoying - it seems that DMA engine
> drivers use a tasklet for running their DMA cleanup, which calls drivers
> callbacks, and we're going to have to have a whole pile of taskets
> in drivers just to be triggered from the completion callback.  I can
> see this adding an additional layer of complexity and a nice fine set
> of shiney new races to deal with.

I should clarify, this is the async_memcpy() api requirement which is
not used outside of md/raid5.  DMA drivers can and do allow new
submissions from callbacks, and the ones that do so properly move the
callback outside of the driver lock.  The doc needs updating to
reflect present reality, but it at least should have prompted the same
reaction you had when reading it and triggered a question about how to
support that usage model.

--
Dan
