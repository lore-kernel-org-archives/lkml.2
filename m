Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1EYJrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:47:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32958 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1EYJrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:47:46 -0400
MIME-Version: 1.0
In-Reply-To: <1306312009.30236.110.camel@vkoul-udesk3>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
	<BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
	<1306253171.30236.9.camel@vkoul-udesk3>
	<BANLkTikjxECNAK5eS5hSu2bbEKpZX341Dw@mail.gmail.com>
	<BANLkTikAm=D_YNFt0Regeas6AX8116L0-A@mail.gmail.com>
	<1306312009.30236.110.camel@vkoul-udesk3>
Date: Wed, 25 May 2011 11:47:45 +0200
Message-ID: <BANLkTikn3BBeNyuUeZ9BhG5QLj-dmcGjTg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: Per Forlin <per.forlin@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 May 2011 10:26, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Wed, 2011-05-25 at 09:47 +0200, Per Forlin wrote:
>> On 24 May 2011 23:03, Dan Williams <dan.j.williams@intel.com> wrote:
>
>> >>> Does submit really start the transfer as well? My interpretation of
>> >>> submit is that is only adds desc to a pending queue. When calling
>> >>> issue_pending all these descs will be schedule for DMA transfer. Calls
>> >>> to submit after this point will added to the pending queue again and
>> >>> not be issued until calling issue_pending once more.
>> >> For slave dma devices, submit() is used to start the transaction if the
>> >> channel is idle. If its already doing a transaction then it will queue
>> >> it up and submit once cureent excuting one is completed. It is not
>> >> required to call issue_pending once more.
>> >> I am not sure if this is true for non slave usage, Dan would that be
>> >> correct for you as well?
>> >
>> > No, ->submit() is just an "add this descriptor to the chain"
>> > operation, and ->issue_pending() is always required to make sure the
>> > everything submitted previously is actively executing.  This was a
>> > holdover from the very first dmaengine implementation where, for
>> > efficiency reasons, it could save mmio writes by batching the issuing
>> > of requests.
>> Thanks Dan for clarifying.
>> Vinod, I propose that the submit and issue_pending works the same for
>> SLAVE and none SLAVE channels. The API should have the same definition
>> independent of DMA_CAP. Please enlighten me if there are things I have
>> foreseen on this matter.
> I am okay with making this same for the slave devices as well.
>
> That would also require to change few drivers which start the txn in
> submit()
Yes,
The trivial part is to move enable from submit to issue_pending. I had
a quick look and it looks like the following drivers need to be
changed.
mpc512x_dma.c
imx-dma.c
imx-sdma.c
mxs-dma.c

The other part is more complex. To make submit only add descs to a
queue that will be pushed down to the DMA only after issue_pending. It
is not as trivial to identify which of the drivers support this or
not.
I still think it make sense to fix the documentation first and then
fix the drivers. Keep a list inside the dmaengine.txt of drivers that
need to be fixed in order to comply with the API. Over time drivers
will be fixed and removed from the list. When we have agreed upon the
API (we may not be there yet) I am willingly to make a draft of such a
list.

/Per
