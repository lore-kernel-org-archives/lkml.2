Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1FOGiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 02:38:17 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:53987 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331Ab1FOGiO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 02:38:14 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "yxlraid@gmail.com" <yxlraid@gmail.com>,
        "jack_wang@usish.com" <jack_wang@usish.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "maciej.trela@intel.com" <maciej.trela@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Tue, 14 Jun 2011 23:31:25 -0700
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Topic: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Index: AcwrIR/qdpMMo2uOTdi6EtZ/SnmPkgAAZ5KA
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
	 <1308065367.2401.24.camel@mulgrave>
	 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
In-Reply-To: <1308117450.2329.31.camel@mulgrave>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2011-06-14 at 18:44 -0700, Xiangliang Yu wrote:
>> Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
>> 
>> On Tue, 2011-06-14 at 23:17 +0800, yxlraid@gmail.com wrote:
>> >> From: Xiangliang Yu <yuxiangl@marvell.com>
>> >> 
>> >> -- The value of child link rate should is minimum of link rate, or
>> >>    command will fail if child link rate is bigger than parent link rate.
>> >> 
>> >> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
>> >> ---
>> >>  drivers/scsi/libsas/sas_expander.c |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >> 
>> >> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> >> index 874e29d..6ccca09 100644
>> >> --- a/drivers/scsi/libsas/sas_expander.c
>> >> +++ b/drivers/scsi/libsas/sas_expander.c
>> >> @@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>> >>  			sas_port_add_phy(port, phy->phy);
>> >>  		}
>> >>  	}
>> >> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
>> >> +	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);
>> 
>> >This patch doesn't look right.  It will clamp the phy to the minim
>> >possible link rate.  
>> Link negotiation should get the minimum.

>it's probably a negotiation problem.  If the
>child can't support the highest possible link rate because of problems
>like transmission errors, it should fall back.

I get the issue like this: 
1. HBA support 3Gbps, level 1 expander support 6Gbps, and level 2 expander support 6Gbps; 
2. level 1 is fine, and find that level 2 link rate is 6Gbps in DISCOVER command response.
3. LIBSAS think level 2 is 6Gbps by sas_ex_get_linkrate function, and send command to level 2 expander
4. LIBSAS link error.

