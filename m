Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab0LAP30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:29:26 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:36747 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751424Ab0LAP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:29:25 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Ovuv22sVM1mb5CWVOG2F1WgfLQqlJhJfBzOOIktKjVz6OpH
 1jy09DoVmBFEiTpNMwR3AeFoZ1sYz7aJkppRh_BbpHPTVhFWQtTOZGKf4ZUr
 f0Qb0FXnOzk99r.KW3YaArIDuw1YGGbWLXXgtwGcXzM5_qi6MOyN5rCDbX8t
 Ubim.XfK78SsfPXkuIbF4NI69o0q4LYgl__4kMuQ1lquDq0HUeHtJeo0RQve
 v5hooue3Hwuo-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Dec 2010 09:29:21 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Simon Kirby <sim@hostway.ca>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Free memory never fully used, swapping
In-Reply-To: <20101201114226.ABAB.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1012010910450.2989@router.home>
References: <20101130092534.82D5.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011301309240.3134@router.home> <20101201114226.ABAB.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, KOSAKI Motohiro wrote:

> > Specifying a parameter to temporarily override to see if this has the
> > effect is ok. But this has worked for years now. There must be something
> > else going with with reclaim that causes these issues now.
>
> I don't think this has worked. Simon have found the corner case recently,
> but it is not new.

What has worked? If the reduction of the maximum allocation order did not
have the expected effect of fixing things here then the issue is not
related to the higher allocations from slub.

Higher order allocations are not only a slub issue but a general issue for
various subsystem that require higher order pages. This ranges from jumbo
frames, to particular needs for certain device drivers, to huge pages.

> So I hope you realize that high order allocation is no free lunch. __GFP_NORETRY
> makes no sense really. Even though we have compaction, high order reclaim is still
> costly operation.

Sure. There is a tradeoff between reclaim effort and the benefit of higher
allocations. The costliness of reclaim may have increased with the recent
changes to the reclaim logic. In fact reclaim gets more and more complex
over time and there may be subtle bugs in there given the recent flurry of
changes.

> I don't think SLUB's high order allocation trying is bad idea. but now It
> does more costly trying. that's bad. Also I'm worry about SLUB assume too
> higher end machine. Now Both SLES and RHEL decided to don't use SLUB,
> instead use SLAB. Now linux community is fragmented. If you are still
> interesting SL*B unification, can you please consider to join corner
> case smashing activity?

The problems with higher order reclaim get more difficult with small
memory sizes yes. We could reduce the maximum order automatically if memory
is too tight. There is nothing hindering us from tuning the max order
behavior of slub in a similar way that we now tune the thresholds of the
vm statistics.

But for that to be done we first need to have some feedback if the changes
to max order have indeed the desired effect in this corner case.




