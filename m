Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1BUMLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 07:11:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51828 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1BUMLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 07:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hRJnf0cCXIauw/LABbQFDTaWgdGPKBJI2TjeOPnwdFFtGd4L5F/3r7Lm1e1zRRqtxd
         vbd2RN/mHnr2uoNu6eEa+4Gsd4uJDIIiJbwA8WnvAxA/+2XQhYzkvhuo9/EodXlOR2Za
         bt5/H+zCrEjLhakQZFBrdSlxcN2UWa7d950pc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
	<1298283649-24532-2-git-send-email-dacohen@gmail.com>
	<AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
Date: Mon, 21 Feb 2011 14:11:42 +0200
Message-ID: <AANLkTi=kL1+qKys0ZCTRb_9GgzadS8Stbai+cR-KNoAU@mail.gmail.com>
Subject: Re: [PATCH 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
From: David Cohen <dacohen@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 1:05 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Mon, Feb 21, 2011 at 12:20 PM, David Cohen <dacohen@gmail.com> wrote:
>> Currently sched.h and wait.h have circular dependency between both.
>> wait.h defines macros wake_up*() which use macros TASK_* defined by
>> sched.h. But as sched.h indirectly includes wait.h, such wait.h header
>> file can't include sched.h too. The side effect is when some file
>> includes wait.h and tries to use its wake_up*() macros, it's necessary
>> to include sched.h also.
>> This patch moves all TASK_* macros from linux/sched.h to a new header
>> file linux/task_sched.h. This way, both sched.h and wait.h can include
>> task_sched.h and fix the circular dependency. No need to include sched.h
>> anymore when wake_up*() macros are used.
>
> Just include <linux/sched.h> in your driver.

Sounds a reasonable solution for me.

> This include splitting in small pieces is troublesome as well.

But I disagree it's troublesome. It's transparent to everyone else.
The only side effect is to not have to include sched.h when using a
macro define on wait.h.

>
> Why are you moving TASK_COMM_LEN?

This one can be moved back to sched.h.

Br,

David

>
>>  include/linux/sched.h      |   61 +-----------------------------------------
>>  include/linux/task_sched.h |   64 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/wait.h       |    1 +
>>  3 files changed, 66 insertions(+), 60 deletions(-)
>>  create mode 100644 include/linux/task_sched.h
>
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> +#include <linux/task_sched.h>
>
