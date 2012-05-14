Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2ENS7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:59:04 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:34113 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757562Ab2ENS7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:59:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: j3I4HmIVM1kamc5A39ngvxszFMGhUyOdwenMTRCuWL3G8sG
 JR9tD53vTADNyvOxRxYl9FftaCTDYXHuz9RsqSgyKDwCVNNe5nFEAg4a3aKJ
 vWKXrUstqDg8lq1nMPEtamAfiHK.pjPbyMpQ7l2Se7PiBoF859AtZPPCh93l
 AAhof1itlqV2V5ddF_tUxOgd0vBAbkWMFKMsMqH0oOCfQsVkZAk8mdGehOUg
 EGRieDJ2AWXOY6rB2P0A_9z4wVU.lAtf7fikM7gZ2o_w8CbqySLNfXoA885f
 VAPPf.kehWngK.QKybNSUUjDqXlHTttb9Pz0f2CWbVnjfxBEDuA4uRb7BMpB
 8VcuteOUCxDE_xWnt3xqURjWSWvvoO9FGvdSQOX71Z65UsXJUpmrtR60lAVN
 J
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 14 May 2012 13:58:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pravin B Shelar <pshelar@nicira.com>
cc: penberg@kernel.org, mpm@selenic.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jesse@nicira.com, abhide@nicira.com
Subject: Re: [PATCH 2/2] mm: Fix slab->page _count corruption.
In-Reply-To: <1337020900-20120-1-git-send-email-pshelar@nicira.com>
Message-ID: <alpine.DEB.2.00.1205141353310.26304@router.home>
References: <1337020900-20120-1-git-send-email-pshelar@nicira.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Pravin B Shelar wrote:

> On arches that do not support this_cpu_cmpxchg_double slab_lock is used
> to do atomic cmpxchg() on double word which contains page->_count.
> page count can be changed from get_page() or put_page() without taking
> slab_lock. That corrupts page counter.
>
> Following patch fixes it by moving page->_count out of cmpxchg_double
> data. So that slub does no change it while updating slub meta-data in
> struct page.

Ugly. Maybe its best to not touch the count in the page lock case in slub?

You could accomplish that by changing the definition of counters in
mm_types.h. Make it unsigned instead of unsigned long so that it only
covers the first part of the struct (which excludes the refcounter)


