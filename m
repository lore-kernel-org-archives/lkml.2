Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2IZBPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 21:15:40 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58695 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2IZBPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 21:15:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120925142948.6b062cb6.akpm@linux-foundation.org>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
	<1347137279-17568-5-git-send-email-elezegarcia@gmail.com>
	<20120925142948.6b062cb6.akpm@linux-foundation.org>
Date: Tue, 25 Sep 2012 22:15:38 -0300
Message-ID: <CALF0-+WcXLR_akn8mL8u-QigHU9Bk5RotA3tbodZ8rhZsxpFLg@mail.gmail.com>
Subject: Re: [PATCH 05/10] mm, util: Use dup_user to duplicate user memory
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Sep 25, 2012 at 6:29 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat,  8 Sep 2012 17:47:54 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>
>> Previously the strndup_user allocation was being done through memdup_user,
>> and the caller was wrongly traced as being strndup_user
>> (the correct trace must report the caller of strndup_user).
>>
>> This is a common problem: in order to get accurate callsite tracing,
>> a utils function can't allocate through another utils function,
>> but instead do the allocation himself (or inlined).
>>
>> Here we fix this by creating an always inlined dup_user() function to
>> performed the real allocation and to be used by memdup_user and strndup_user.
>
> This patch increases util.o's text size by 238 bytes.  A larger kernel
> with a worsened cache footprint.
>
> And we did this to get marginally improved tracing output?  This sounds
> like a bad tradeoff to me.
>

Mmm, that's bad tradeoff indeed.
It's certainly odd since the patch shouldn't increase the text size
*that* much.
Is it too much to ask that you send your kernel config and gcc version.

My compilation (x86 kernel in gcc 4.7.1) shows a kernel less bloated:

$ readelf -s util-dup-user.o | grep dup_user
   161: 00001c10   108 FUNC    GLOBAL DEFAULT    1 memdup_user
   169: 00001df0   159 FUNC    GLOBAL DEFAULT    1 strndup_user
$ readelf -s util.o | grep dup_user
   161: 00001c10   108 FUNC    GLOBAL DEFAULT    1 memdup_user
   169: 00001df0    98 FUNC    GLOBAL DEFAULT    1 strndup_user

$ size util.o
   text	   data	    bss	    dec	    hex	filename
  18319	   2077	      0	  20396	   4fac	util.o
$ size util-dup-user.o
   text	   data	    bss	    dec	    hex	filename
  18367	   2077	      0	  20444	   4fdc	util-dup-user.o

Am I doing anything wrong?
If you still feel this is unnecessary bloatness, perhaps I could think of
something depending on CONFIG_TRACING (though I know
we all hate those nasty ifdefs).

Anyway, thanks for the review,
Ezequiel.
