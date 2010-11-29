Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0K2U7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:59:24 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:40842 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751222Ab0K2U7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:59:23 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jqlYPE8VM1n_zkZa_4MveMbL5f1rHebRoMF43NahQl3FFmn
 sZB2BIta5B2uz.0k2c2Vur8fpx37VLQeEQcPJJiAE3FTaJyQpEnniUnitEit
 zEcFH_Icn.T7.T2lF8RnZrfGzHZCJtp8Gm.YtvqiHUsM4Ei_mBsltk8X5Rz.
 n54u6G2y_.4slj4bc.KtAmNq08UBW6LKT4oMUo_ZR2.6KoX9NOeol5F2CoTL
 Fvd2S0wem4cw-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 14:59:20 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 02/10] vmstat: Optimize zone counter modifications
 through the use of this cpu operations
In-Reply-To: <alpine.DEB.2.00.1011291402300.4836@router.home>
Message-ID: <alpine.DEB.2.00.1011291448220.9804@router.home>
References: <20101126210937.383047168@linux.com> <20101126210950.142747403@linux.com> <20101127144949.GC15365@Krystal> <alpine.DEB.2.00.1011291013460.3923@router.home> <alpine.DEB.2.00.1011291111110.4836@router.home> <20101129192801.GE25610@Krystal>
 <alpine.DEB.2.00.1011291402300.4836@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some numbers for the cmpxchg implementation (cycles)

Function		Orig	Cmpxchg Fallback
--------------------------------------------------
inc_zone_page_state	170	32	196
__inc_zone_page_s	23	31	26
inc/dec pairs		347	69	379

So the fallback is always worse. cmpxchg is only better for the versions
of zone counters where we need to disable and enable interrupts.

This would suggest to only use the cmpxchg for arches that have cmpxchg
local and only in the case of the full versions.

There are 12 cases of inc_zone_page_state and 13 of dec_zone_page_state
as well as 7 cases of mod_zone_page_state.


