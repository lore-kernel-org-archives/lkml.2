Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1LLVav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:30:51 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:6789 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1LLVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:30:50 -0500
X-SpamScore: -14
X-BigFish: VS-14(zzbb2dI9371I936eK1432N98dKzz1202hzzz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE6725C.3050706@freescale.com>
Date: Mon, 12 Dec 2011 15:30:04 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>   <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>   <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala>  <4EE66EFE.1050608@freescale.com> <1323724784.2297.20.camel@koala>
In-Reply-To: <1323724784.2297.20.camel@koala>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 03:19 PM, Artem Bityutskiy wrote:
> On Mon, 2011-12-12 at 15:15 -0600, Scott Wood wrote:
>> NAND chips come from the factory with bad blocks marked at a certain
>> offset into each page.  This offset is normally in the OOB area, but
>> since we change the layout from "4k data, 128 byte oob" to "2k data, 64
>> byte oob, 2k data, 64 byte oob" the marker is no longer in the oob.  On
>> first use we need to migrate the markers so that they are still in the oob.
> 
> Ah, I see, thanks. Are you planning to implement in-kernel migration or
> use a user-space tool?

That's the kind of answer I was hoping to get from Shuo. :-)

Most likely is a firmware-based tool, but I'd like there to be some way
for the tool to mark that this has happened, so that the Linux driver
can refuse to do non-raw accesses to a chip that isn't marked as having
been migrated (or at least yell loudly in the log).

Speaking of raw accesses, these are currently broken in the eLBC
driver... we need some way for the generic layer to tell us what kind of
access it is before the transaction starts, not once it wants to read
out the buffer (unless we add more hacks to delay the start of a read
transaction until first buffer access...).  We'd be better off with a
high-level "read page/write page" function that does the whole thing
(not just buffer access, but command issuance as well).

-Scott

