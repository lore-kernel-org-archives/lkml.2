Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0KRCrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:47:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50314 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0KRCrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:47:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DOXbVoC2yCeI4Pge2MqsWWOF7YJ9rw1ZXTSSxCDWXG+lCpfxmkqU2m9XpcDq9hl7Dh
         kJ46AYowAavd0Ph4qTzpD+3mFq6qP7HDdDZaHfmp+7KD7qqpEQr3WuiWxHSxrm9P0DTr
         Cnh+54+gywWKpvA18keYS8mnxUKtki46XOZr8=
MIME-Version: 1.0
In-Reply-To: <4CE40129.9060103@redhat.com>
References: <20101109162525.BC87.A69D9226@jp.fujitsu.com>
	<877hgmr72o.fsf@gmail.com>
	<20101114140920.E013.A69D9226@jp.fujitsu.com>
	<AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com>
	<1289810825.2109.469.camel@laptop>
	<AANLkTikibS1fDuk67RHk4SU14pJ9nPdodWba1T3Z_pWE@mail.gmail.com>
	<4CE14848.2060805@redhat.com>
	<AANLkTi=6RtPDnZZa=jrcciB1zHQMiB3LnouBw3G2OyaK@mail.gmail.com>
	<4CE40129.9060103@redhat.com>
Date: Thu, 18 Nov 2010 11:47:17 +0900
Message-ID: <AANLkTin2fXGOAdGNegDhijjo_kV7nOBJP_hagjgoYdtX@mail.gmail.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 1:22 AM, Rik van Riel <riel@redhat.com> wrote:
> On 11/17/2010 05:16 AM, Minchan Kim wrote:
>
>> Absolutely. But how about rsync's two touch?
>> It can evict working set.
>>
>> I need the time for investigation.
>> Thanks for the comment.
>
> Maybe we could exempt MADV_SEQUENTIAL and FADV_SEQUENTIAL
> touches from promoting the page to the active list?
>

The problem is non-mapped file page.
non-mapped file page promotion happens by only mark_page_accessed.
But it doesn't enough information to prevent promotion(ex, vma or file)
Hmm.. Do other guys have any idea?

Here is another idea.
Current problem is following as.
User can use fadivse with FADV_DONTNEED.
But problem is that it can't affect when it meet dirty pages.
So user have to sync dirty page before calling fadvise with FADV_DONTNEED.
It would lose performance.

Let's add some semantic of FADV_DONTNEED.
It invalidates only pages which are not dirty.
If it meets dirty page, let's move the page into inactive's tail or head.
If we move the page into tail, shrinker can move it into head again
for deferred write if it isn't written the backed device.


> Then we just need to make sure rsync uses fadvise properly
> to keep the working set protected from rsync.
>
> --
> All rights reversed
>



-- 
Kind regards,
Minchan Kim
