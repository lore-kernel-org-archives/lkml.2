Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1LNDg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:36:57 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:31296
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494Ab1LNDg4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:36:56 -0500
X-SpamScore: -14
X-BigFish: VS-14(zzbb2dI9371Ic89bh936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE81ADD.6090104@freescale.com>
Date: Wed, 14 Dec 2011 11:41:17 +0800
From: LiuShuo <b35362@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <dedekind1@gmail.com>, Scott Wood <scottwood@freescale.com>
CC: <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>	 <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>	 <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala>
In-Reply-To: <1323724195.2297.11.camel@koala>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月13日 05:09, Artem Bityutskiy 写道:
> On Tue, 2011-12-06 at 18:09 -0600, Scott Wood wrote:
>> On 12/03/2011 10:31 PM, shuo.liu@freescale.com wrote:
>>> From: Liu Shuo<shuo.liu@freescale.com>
>>>
>>> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
>>> to support the Nand flash chip whose page size is larger than 2K bytes,
>>> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
>>> them to a large buffer.
>>>
>>> Signed-off-by: Liu Shuo<shuo.liu@freescale.com>
>>> ---
>>> v3:
>>>      -remove page_size of struct fsl_elbc_mtd.
>>>      -do a oob write by NAND_CMD_RNDIN.
>>>
>>>   drivers/mtd/nand/fsl_elbc_nand.c |  243 ++++++++++++++++++++++++++++++++++----
>>>   1 files changed, 218 insertions(+), 25 deletions(-)
>> What is the plan for bad block marker migration.
I think we can use a special bbt pattern to indicate whether migration 
has been done.
(we needn't to define another marker)

Do the migration our chip->scan_bbt as follow :

/*
  * this pattern indicate that the bad block information has been migrated,
  * if this isn't found, we do the migration.
  */
static u8 migrated_bbt_pattern[] = {'M', 'b', 'b', 't', '0' };

static int fsl_elbc_bbt(struct mtd_info *mtd)
{
         if (!check_migrated_bbt_pattern())
             bad_block_info_migtrate();

          nand_default_bbt(mtd); /* default function in nand_bbt.c */
}

- LiuShuo

