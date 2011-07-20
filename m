Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1GTTwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:52:20 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:24070 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751309Ab1GTTwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:52:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XK5AwW0VM1npqQ1ZEG.tpkzMahMdAhkDKbG_HZLVI8zU4Rf
 JLLRd4LgeCcXOuuvdRQ77b6EkNQ50yyJko_X6rmXF.3C2TjEff6vER7DZPCV
 WWsDQd4cuDjrY9WXx2l0pZv.i86Q34efI0OIbsqjH3qXnF0kO1AIbaRcs9Hv
 .fWSGuKmCZvZdVBStTHVmfmqll8yKpBLIrXD2WSCMFUmTO2SlWSvaKo_LwHZ
 V0XGGQpqePtFofe_VqiFUPIsLUusfPYUdCYCRSpq56eB4JpB..6NgIOFbM15
 aBuPPNWIbW0gbsuuYy5ebPsbLhMdh6y5PqUGU3QzHwwqyX7Or
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 14:52:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
In-Reply-To: <alpine.DEB.2.00.1107201425200.1472@router.home>
Message-ID: <alpine.DEB.2.00.1107201443400.1472@router.home>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de> <1310742540-22780-2-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1107180951390.30392@router.home> <20110718160552.GB5349@suse.de> <alpine.DEB.2.00.1107181208050.31576@router.home>
 <20110718211325.GC5349@suse.de> <alpine.DEB.2.00.1107181651000.31576@router.home> <alpine.DEB.2.00.1107190901120.1199@router.home> <alpine.DEB.2.00.1107201307530.1472@router.home> <20110720191858.GO5349@suse.de>
 <alpine.DEB.2.00.1107201425200.1472@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing way of deciding if watermarks have been met looks broken to
me.

There are two pools of pages: One is the pages available from the buddy
lists and another the pages in the per cpu lists.

zone_watermark_ok() only checks those in the buddy lists
(NR_FREE_PAGES) is not updated when we get a page from the per cpu lists).

And we do check zone_watermark_ok() before even attempting to allocate
pages that may be available from the per cpu lists?

So the allocator may pass on a zone and/or go into reclaim despite of the
availability of pages on per cpu lists. The more pages one puts into the
per cpu lists the higher the chance of an OOM. ... Ok that is not true
since we flush the per cpu pages and get them back into the buddy lists
before that happens.


