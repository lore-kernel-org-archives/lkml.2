Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1BUQDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:03:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41822 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1BUQDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:03:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KI3b3MmtpPo/E+ar7w7ATEH3QdJ0Zgh3BLPtncMANOlGfOq2ITu1IwWKLhH13g3Qvu
         M4kujVN2ZsFFVc+XbiXFAI338FtfVkBWx1lNxL5xHZYRNka2ZtGEfydxKRtn60ha5ACE
         woRHg/PNMBlzewz2Q+SEltXazvRB1rE+E75oo=
MIME-Version: 1.0
In-Reply-To: <1298303677.24121.1.camel@twins>
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
	<1298299131-17695-2-git-send-email-dacohen@gmail.com>
	<1298303677.24121.1.camel@twins>
Date: Mon, 21 Feb 2011 18:03:18 +0200
Message-ID: <AANLkTimOT6jNG3=TiRMJR0dgEQ6EHjcBPJ1ivCu3Wj5Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
From: David Cohen <dacohen@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 5:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-02-21 at 16:38 +0200, David Cohen wrote:
>> Currently sched.h and wait.h have circular dependency between both.
>> wait.h defines macros wake_up*() which use macros TASK_* defined by
>> sched.h. But as sched.h indirectly includes wait.h, such wait.h header
>> file can't include sched.h too. The side effect is when some file
>> includes wait.h and tries to use its wake_up*() macros, it's necessary
>> to include sched.h also.
>> This patch moves all TASK_* macros from linux/sched.h to a new header
>> file linux/task_state.h. This way, both sched.h and wait.h can include
>> task_state.h and fix the circular dependency. No need to include sched.h
>> anymore when wake_up*() macros are used.
>
> I think Alexey already told you what you done wrong.
>
> Also, I really don't like the task_state.h header, it assumes a lot of
> things it doesn't include itself and only works because its using macros
> and not inlines at it probably should.

Like wait.h I'd say. The main issue is wait.h uses TASK_* macros but
cannot properly include sched.h as it would create a circular
dependency. So a file including wait.h is able to compile because the
dependency of sched.h relies on wake_up*() macros and it's not always
used.
We can still drop everything else from task_state.h but the TASK_*
macros and then the problem you just pointed out won't exist anymore.
What do you think about it?

Br,

David

>
>
>
