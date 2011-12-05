Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1LETqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:46:33 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:14598
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932285Ab1LETqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:46:32 -0500
X-SpamScore: -18
X-BigFish: VS-18(zzbb2dK9371K936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EDD1F90.300@freescale.com>
Date: Mon, 5 Dec 2011 13:46:24 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <shuo.liu@freescale.com>, <Artem.Bityutskiy@nokia.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <akpm@linux-foundation.org>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com> <1323067628.2316.29.camel@koala>
In-Reply-To: <1323067628.2316.29.camel@koala>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 12:47 AM, Artem Bityutskiy wrote:
> On Sun, 2011-12-04 at 12:31 +0800, shuo.liu@freescale.com wrote:
>> +		/*
>> +		 * Freescale FCM controller has a 2K size limitation of buffer
>> +		 * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
>> +		 * of chip is greater than 2048.
>> +		 * We malloc a large enough buffer (maximum page size is 16K).
>> +		 */
>> +		elbc_fcm_ctrl->buffer = kmalloc(1024 * 16 + 1024, GFP_KERNEL);
>> +		if (!elbc_fcm_ctrl->buffer) {
>> +			dev_err(dev, "failed to allocate memory\n");
>> +			mutex_unlock(&fsl_elbc_nand_mutex);
>> +			ret = -ENOMEM;
>> +			goto err;
>> +		}
> 
> Sorry for returning to this again and agian - I do not have time to dig
> suggest you the right solutions on the one hand, you do not provide me a
> good answer on the other hand (or I forgot?).
> 
> 16KiB pages do not even exist I believe.

Googling turns up some hints of it, but nothing concrete such as a
datasheet.  We can assume 8K max for now and adjust it later, as the
need becomes clear.

> And you kmalloc 33KiB or RAM

17KiB, or 9KiB if we forget about 16K-page NAND.

> although in most cases you need only 5KiB. I think this is wrong -
> what is the very strong reason of wasting RAM you have?
> 
> Why you cannot allocate exactly the required amount of RAM after
> 'nand_scan_ident()' finishes and you know the page size?

Because this is a controller resource, shared by multiple NAND chips
that may be different page sizes (even if not, it's adding another point
of synchronization required between initialization of different chips).
 I don't think it's worth the gymnastics to save a few KiB.

-Scott

