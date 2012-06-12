Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2FLBYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:24:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59546 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2FLBYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:24:05 -0400
Message-ID: <4FD69984.3030702@us.ibm.com>
Date: Mon, 11 Jun 2012 18:21:08 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com>	<4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com>	<4FC937AD.8040201@linaro.org> <4FC9438B.1000403@gmail.com>	<4FC94F61.20305@linaro.org> <4FCFB4F6.6070308@gmail.com>	<4FCFEE36.3010902@linaro.org> <CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com> <4FD13C30.2030401@linux.vnet.ibm.com> <4FD16B6E.8000307@linaro.org> <4FD1848B.7040102@gmail.com> <4FD2C6C5.1070900@linaro.org> <4FD515FA.2020708@redhat.com> <4FD63A55.3090505@linaro.org>
In-Reply-To: <4FD63A55.3090505@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061201-7282-0000-0000-000009D38064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 11:35 AM, John Stultz wrote:
> On 06/10/2012 02:47 PM, Rik van Riel wrote:
>> On 06/08/2012 11:45 PM, John Stultz wrote:
>>
>>> I *think* ideally, the pages in a volatile range should be similar to
>>> non-dirty file-backed pages. There is a cost to restore them, but
>>> freeing them is very cheap. The trick is that volatile ranges 
>>> introduces
>>
>> Easier to mark them dirty.
>>
>>> a new relationship between pages. Since the neighboring virtual 
>>> pages in
>>> a volatile range are in effect tied together, purging one effectively
>>> ruins the value of keeping the others, regardless of which zone they 
>>> are
>>> physically.
>>
>> Then the volatile ->writepage function can zap the whole
>> object.
>>
>
> What about the concern that if we don't have swap, we'll not call 
> writepage on tmpfs files?

So actually, a more concrete question might be: What is the value of the 
active/inactive split of anonymous memory on a system without swap?

Basically I'm looking at trying to allow the writepage function to zap 
the range as you suggest, but also changing the behavior when there is 
no swap so that all anonymous pages stay active, unless they are 
volatile.  Then, in both cases with swap and without, we would still 
shrink the inactive list, call writepage and zap the volatile ranges. 
Its just without swap, the only anonymous pages on the inactive list 
would be volatile.

Does that make any sense?

Hopefully will have a hackish patch to demonstrate what I'm describing 
tomorrow.

thanks
-john

