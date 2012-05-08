Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2EHTWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:22:18 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:22775 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754857Ab2EHTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:22:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1R53ojUVM1l75izuERybjK9zpK1U38UuhVP.pLPA_xnsJYb
 pYt_W7HDMbEm6gGX4jS.CUci.nx6RLomLo7yR8nGm1IWkYh6xGbfovIviNfN
 ozr2kWDWhxNnoQJwlLu6XQExV5o4kbW0LVaYJ9jWvh43ygIKchY77BDUFZyG
 YBgKN74kvMkUkNuu.Qxui4Eu9dbNAeh..MjcSSudkInSv1aKBb4nbM4rFang
 ISosenWHUgVqI3iT2iliEGYt5VrBriBd2Wyun59G09SPmB1QYNe.5vxr5_Vl
 natkgZ_786A5SOHWRWFGsKaxKG7KAjS61NUGPqM5uz4O.VxJU_bs5xvvUEzm
 eMDN32GNxRtZGSEZjEizRJDCF6hB3NPDidZXGuZEp.ilIimlbiEyT8Fp6YD1
 453d8MprrnRKA_q4u3ozUZaDB_N4pKot_7S8W
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 14:22:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pravin B Shelar <pshelar@nicira.com>, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
Subject: Re: [PATCH] mm: sl[auo]b: Use atomic bit operations to update
 page-flags.
In-Reply-To: <1336504276.3752.2600.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.00.1205081417120.27713@router.home>
References: <1336503339-18722-1-git-send-email-pshelar@nicira.com> <1336504276.3752.2600.camel@edumazet-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Eric Dumazet wrote:

> On Tue, 2012-05-08 at 11:55 -0700, Pravin B Shelar wrote:
> > Transparent huge pages can change page->flags (PG_compound_lock)
> > without taking Slab lock. So sl[auo]b need to use atomic bit
> > operation while changing page->flags.
> > Specificly this patch fixes race between compound_unlock and slab
> > functions which does page-flags update. This can occur when
> > get_page/put_page is called on page from slab object.
>
>
> But should get_page()/put_page() be called on a page own by slub ?

Can occur in slab allocators if the slab memory is used for DMA. I dont
like the performance impact of the atomics. In particular slab_unlock() in
slub is or used to be a hot path item. It is still hot on arches that do
not support this_cpu_cmpxchg_double. With the cmpxchg_double only the
debug mode is affected.

