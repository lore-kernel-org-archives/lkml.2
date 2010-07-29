Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0G2Qrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:47:33 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:20833 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754695Ab0G2Qrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:47:32 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lVTCpO0VM1nQippHLLz9ldEN3qcZfD.FO8nN5QpIrkqvCxK
 4moVGxg6AM9CDRlQMGvAJz2LwWniUuG84nZefMHi7ChY496Vdz.lY4DjW85.
 AABTur_IjD8S4qFJZjbNzcHpyj.to6OviBXHxDuCfr1cIKoQ.54pLcfX8Txk
 pIUm.lLeAg9m55HqLGctCggw9ldnbhYwL4.sodtWpb4Avx5gCnNpULsKlVcw
 Q
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 29 Jul 2010 11:47:26 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <20100729161856.GA16420@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1007291132210.17734@router.home>
References: <pfn.valid.v4.reply.2@mdm.bga.com> <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com> <alpine.DEB.2.00.1007270929290.28648@router.home> <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
 <alpine.DEB.2.00.1007281005440.21717@router.home> <20100728155617.GA5401@barrios-desktop> <alpine.DEB.2.00.1007281158150.21717@router.home> <20100728225756.GA6108@barrios-desktop> <alpine.DEB.2.00.1007291038100.16510@router.home>
 <20100729161856.GA16420@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010, Minchan Kim wrote:

> The thing is valid section also have a invalid memmap.

Oww... . A valid section points to a valid memmap memory block (the page
structs) but the underlying memory pages may not present. So you can check
the (useless) page structs for the page state of the not present pages in
the memory map. If the granularity of the sparsemem mapping is not
sufficient for your purpose then you can change the sparsemem config
(configuration is in arch/<arch>/include/asm/sparsemem.h but does not
exist for arm).

>      It means section 0 is an incompletely filled section.
>      Nontheless, current pfn_valid of sparsemem checks pfn loosely.
>      It checks only mem_section's validation but ARM can free mem_map on hole
>      to save memory space. So in above case, pfn on 0x25000000 can pass pfn_valid's
>      validation check. It's not what we want.

IMHO ARM should not poke holes in the memmap sections. The guarantee of
the full presence of the section is intentional to avoid having to do
these checks that you are proposing. The page allocator typically expects
to be able to check all page structs in one basic allocation unit.

Also pfn_valid then does not have to touch the pag struct to perform its
function as long as we guarantee the presence of the memmap section.
