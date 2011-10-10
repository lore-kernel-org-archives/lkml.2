Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1JJTTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:19:19 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:36910 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1JJTTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:19:18 -0400
X-IronPort-AV: E=Sophos;i="4.68,518,1312156800"; 
   d="scan'208";a="8311790"
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Li Dongyang <lidongyang@novell.com>
In-Reply-To: <20111010175323.GA31210@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
	 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
	 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
	 <20111010164250.GG28646@phenom.oracle.com>
	 <20111010175323.GA31210@phenom.oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Mon, 10 Oct 2011 20:19:15 +0100
Message-ID: <1318274355.27397.12.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where is your tree at the moment?

On Mon, 2011-10-10 at 18:53 +0100, Konrad Rzeszutek Wilk wrote:
> > > I think an explicit flag variable is likely to be less trouble WRT
> > > maintaining compatibility in the future than a bit-field. Also I think
> > > you may as well align the struct size to something larger than a byte,
> > > either 4 or 8 bytes would make sense.
> > 
> > Ok. Will change it and make it an uint64_t secure_flag
> > variable. Later on if there are any "other" flags we can chop it down.
> 
> New patch (it also looks like the patch I sent to xen-devel to update
> the blkif.h was never merged) - so let me send right now.
> 
> BTW, it seems that the #pragma pack(push, 4) is used in the
> drivers/block/xen-blkback/common.h to compact the structures already so
> I don't think we need the aligment.

Only around the x86_32 ABI definition, working around the fact that the
original 32 bit interface was not 64 bit clean :-(. I think to ensure
that the new DISCARD structure is sensibly aligned you probably do want
it to be a multiple of 64 bits in size (32 of flags and 32 of pad would
do it).

> diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
> index 9324488..13d040e 100644
> --- a/include/xen/interface/io/blkif.h
> +++ b/include/xen/interface/io/blkif.h
> @@ -84,6 +84,10 @@ typedef uint64_t blkif_sector_t;
>   *     e07154r6-Data_Set_Management_Proposal_for_ATA-ACS2.doc
>   * http://www.seagate.com/staticfiles/support/disc/manuals/
>   *     Interface%20manuals/100293068c.pdf
> + * We also provide three extra XenBus options to the discard operation:

Who is "We" here? The frontend, backend or both? Do they both need to
agree on anything?

> + * 'discard-granularity' - Max amount of sectors that can be discarded.

... in a single request?

> + * 'discard-alignment' - 4K, 128K, etc aligment on sectors to erased.
                                          alignment

What size are the sectors which "discard-granularity" is measured in? Is
it "discard-alignment"-byte sectors or in base 512-byte sectors?

> + * 'discard-secure' - whether the discard can also securely erase data.
>   */
>  #define BLKIF_OP_DISCARD           5
>  
> @@ -107,6 +111,8 @@ struct blkif_request_rw {
>  struct blkif_request_discard {
>  	blkif_sector_t sector_number;
>  	uint64_t nr_sectors;
> +#define BLKIF_OP_DISCARD_FLAG_SECURE	(1<<1) /* ignored if discard-secure=0 */

"1<<0" is unused.

> +	uint32_t flag;
>  };
>  
>  struct blkif_request {


