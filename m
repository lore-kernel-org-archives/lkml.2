Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1LNUx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:53:27 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:24358
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab1LNUx0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:53:26 -0500
X-SpamScore: -20
X-BigFish: VS-20(zzbb2dI9371Ic89bh936eK179dN1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE90CC0.8040807@freescale.com>
Date: Wed, 14 Dec 2011 14:53:20 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LiuShuo <b35362@freescale.com>
CC: <dedekind1@gmail.com>, <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>	 <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>	 <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala> <4EE81ADD.6090104@freescale.com>
In-Reply-To: <4EE81ADD.6090104@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 09:41 PM, LiuShuo wrote:
> 于 2011年12月13日 05:09, Artem Bityutskiy 写道:
>> On Tue, 2011-12-06 at 18:09 -0600, Scott Wood wrote:
>>> On 12/03/2011 10:31 PM, shuo.liu@freescale.com wrote:
>>>> From: Liu Shuo<shuo.liu@freescale.com>
>>>>
>>>> Freescale FCM controller has a 2K size limitation of buffer RAM. In
>>>> order
>>>> to support the Nand flash chip whose page size is larger than 2K bytes,
>>>> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and
>>>> save
>>>> them to a large buffer.
>>>>
>>>> Signed-off-by: Liu Shuo<shuo.liu@freescale.com>
>>>> ---
>>>> v3:
>>>>      -remove page_size of struct fsl_elbc_mtd.
>>>>      -do a oob write by NAND_CMD_RNDIN.
>>>>
>>>>   drivers/mtd/nand/fsl_elbc_nand.c |  243
>>>> ++++++++++++++++++++++++++++++++++----
>>>>   1 files changed, 218 insertions(+), 25 deletions(-)
>>> What is the plan for bad block marker migration.
> I think we can use a special bbt pattern to indicate whether migration
> has been done.
> (we needn't to define another marker)
> 
> Do the migration our chip->scan_bbt as follow :
> 
> /*
>  * this pattern indicate that the bad block information has been migrated,
>  * if this isn't found, we do the migration.
>  */
> static u8 migrated_bbt_pattern[] = {'M', 'b', 'b', 't', '0' };
> 
> static int fsl_elbc_bbt(struct mtd_info *mtd)
> {
>         if (!check_migrated_bbt_pattern())
>             bad_block_info_migtrate();
> 
>          nand_default_bbt(mtd); /* default function in nand_bbt.c */
> }

Hmm.  This is OK as long as the bad block table never gets erased (which
could happen if a user wants it reconstructed, such as if buggy software
makes a mess of it on a developer's board).  If it gets erased, we'll
end up migrating again -- and the place that factory bad block markers
would have been in is now data, so all blocks that have been written to
will show up as bad unless they happen to have 0xff at the right place.

How about a marker that is compatible with the bbt, so the same block
can be used in production (where scrubbing the bbt should never happen),
but that does not have to imply that the block is a bbt (so a developer
that might want to erase the bbt can set the mark elsewhere, preferably
just before the bbt)?

Or have two versions of the marker, one that is also a bbt marker and
one that is not.

When scanning the bbt, the driver would look for one of these markers
from the end of the chip backward.  If not found, it concludes the chip
is unmigrated.  In U-Boot, this would trigger a migration (or a message
to run a migration command).  In Linux (and U-Boot if migration is a
separate command that has not been run) an unmigrated flash could be
read-only, with the possible exception of raw accesses if needed to
support an external migration tool.

-Scott

