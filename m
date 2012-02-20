Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2BTX0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:26:03 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33458 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2BTX0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:26:01 -0500
Message-ID: <4F42D66D.8090604@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 15:25:33 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: John Stultz <john.stultz@linaro.org>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org> <1328832993-23228-2-git-send-email-john.stultz@linaro.org> <20120214051659.GH14132@dastard>	<1329198932.2753.62.camel@work-vm> <20120214235106.GL7479@dastard>	<1329265750.2340.17.camel@work-vm> <20120215123750.3333141f@notabene.brown> <1329456095.2373.43.camel@js-netbook> <20120220183440.01bd4c5c@notabene.brown>
In-Reply-To: <20120220183440.01bd4c5c@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022023-5518-0000-0000-00000262805E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 11:34 PM, NeilBrown wrote:
> Is this a problem?  If the typical granularity is a page or two then it is
> unlikely to hurt.  If it is hundreds of pages I think it would mean that we
> don't make as good use of memory as we could (but it is all heuristics anyway
> and we probably waste lots of opportunities already so maybe it doesn't
> matter).
> 
> My gut feeling is that seeing the app has concrete knowledge about
> granularity it should give it to the kernel somehow.

I dunno...  The kernel works well with an awful lot of applications
without ever having any concept of the underlying objects.

I guess the worst-case scenario would be if we have a very large object,
most of its pages being accessed very often, but one never accessed.
The one page makes its way to the end of the LRU and gets discarded, now
the whole object is worthless, and most of it is at the beginning of the
LRU.  If it is truly accessed often, then userspace should notice
quickly and discard the entire object quickly.  If it isn't accessed
often, then the majority of the object is moving down the LRU and won't
be wasted for long.

What else can we do?  I guess whenever a range is set NONVOLATILE, we
could SetPageReferenced() on every page in the range to keep them
bunched up on the LRU.

