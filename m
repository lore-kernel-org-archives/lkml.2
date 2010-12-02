Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0LBKRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:17:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:52058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183Ab0LBKRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:17:41 -0500
Message-ID: <4CF77225.3040904@kernel.org>
Date: Thu, 02 Dec 2010 11:17:09 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
References: <4CF506A6.4020200@kernel.org> <20101130153839.GM15818@bombadil.infradead.org> <4CF52652.4030802@kernel.org> <20101130163150.GA25668@bombadil.infradead.org> <20101130175317.GB25668@bombadil.infradead.org> <20101130210938.GF25668@bombadil.infradead.org> <4CF62EE0.7040607@kernel.org> <20101201124445.GG25668@bombadil.infradead.org> <4CF6595A.6010104@kernel.org> <20101201155026.GH25668@bombadil.infradead.org> <20101201200907.GI25668@bombadil.infradead.org>
In-Reply-To: <20101201200907.GI25668@bombadil.infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 10:17:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 09:09 PM, Kyle McMartin wrote:
> On Wed, Dec 01, 2010 at 10:50:26AM -0500, Kyle McMartin wrote:
>>> Nothing peculiar.  Hmm... okay, I think I've found what went wrong.
>>> Can you please try the following patch and see whether the problem
>>> goes away?
>>>
>>
>> Thanks, I'll let you know when/if it drops to 1.5gbps.
>>
> 
> Looks to stay at 3.0 Gbps now... but gives up on EH after 5 retries?

Hmmm... something is setting EH_PENDING while EH is in progress.
Let's see what's doing it.  Can you please apply the following patch
on top of the previous one and report the kernel log?

Thanks.

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5e59050..8f0d854 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -896,6 +896,10 @@ static void ata_eh_set_pending(struct ata_port *ap, int fastdrain)

 	ap->pflags |= ATA_PFLAG_EH_PENDING;

+	ata_port_printk(ap, KERN_WARNING, "XXX SET EH PENDING, fastdrain=%d\n",
+			fastdrain);
+	dump_stack();
+
 	if (!fastdrain)
 		return;

