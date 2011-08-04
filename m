Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1HDPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:25:58 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:42866 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751850Ab1HDPZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:25:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Da1FzxQVM1n2dtdeHz0ff_RrRaEJDlL3R2ids8AZYH0R331
 7wcjV1FW2mFBNxsYRp8LCZo1d87UPoex5lcr8buD8oYuzhCIYHfWUdr1yyTG
 mTlzhuMq5s__WZzOod_y4pMPz5udqEHGEG3nJJl4TPujbUbfgU_ZYWG0ni5h
 M.VWWZA4ThvSX4jpKGWzPPzxDOA.4B0ChtI0fs_95bFTIvuT_6r097OVt.MY
 hh4im3kd_HQoTyOu5z2ajMLPrfw0n2OvlVgIaMVpDhaJV1DNZ5hAS7HRiYCP
 gvLlXJvlUJYY6GJa9T3vWwLhejZNkxrtJUebXAh3sqMovIji0hujXFWRcyvW
 MflA0dcxvZ.PD5lsNiTiZEMHLnfOuEEpeNn8ALxwAds7sTg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 4 Aug 2011 10:25:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [listll] Fix fetching of head->first in lockless lists.
In-Reply-To: <20110804151725.GA21597@Krystal>
Message-ID: <alpine.DEB.2.00.1108041021250.24277@router.home>
References: <alpine.DEB.2.00.1108040942360.24277@router.home> <20110804151725.GA21597@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011, Mathieu Desnoyers wrote:

> * Christoph Lameter (cl@linux.com) wrote:
> >
> > The fetching of head->first must occur in the cmpxchg loop.
> >
> > With the current code head->first may change after the content were assigned to
> > the "entry" variable. Entry then not be change anymore in the loop and be
> > used as old_entry for the cmpxchg. The cmpxchg will then therefore
> > compare "entry" to list->head. This will always fail if list->head has
> > changed. The restarting of the loop will not fetch head->first again. So
> > we could have a hang there.
> >
> > I guess this only works now because the compiler optimizations pull
> > the fetching of head->first into the loop.
>
> Hi Christoph,
>
> The cmpxchg re-fetch the head->first (this is its return value). The:
>
>   } while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
>
> Takes care of the re-read and populating "entry" with an updated value.

I know but that is not the problem.

The code does not refetch the contents in old_entry (which got its value
from entry which was obtained before the loop was entered!). So Old entry
is constant even after a cmpxchg has failed. If head->first has changed
then we will repeatedly comparing the new value to "old_entry" (aka
"entry") as it was before the loop was entered.
