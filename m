Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0HPOHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:07:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab0HPOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GOOP2znLVp4HoXbbDIb//7saVs07lLMVNDzHcPPIU7zRbVJbqcdPrNNdVXafxhJUd5
         LU1TP+PVAA2t6NX2oK0CHHV/Ovoy0DwRl7+WbHFr9Ce6YtcgxKrnMsmWFeXAWBAoc+gg
         vxKRqeqq2RHnCWYKXMGTj9cU0mxXNmrLYUjaU=
Date: Mon, 16 Aug 2010 22:06:49 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog
Message-ID: <20100816140649.GA1992@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100816133452.GS4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 09:34:52AM -0400, Don Zickus wrote:
> I don't recall any requirement to have preemption disabled when using
> those functions.

Isn't that implicit? I mean the caller of touch_{softlockup|nmi}_watchdog
will sticky to that cpu before it finish running.

> It seems sensible to put it in the
> touch_{softlockup|nmi}_watchdog code.

I don't think so. Such as:

	...
      preempt_disable()                <===A
      touch_{softlockup|nmi}_watchdog  <===B
      preempt_enable()                 <===C
        ...

You just scroll A and C into B, but what will happen before preempt
occur before A?

> 
> I assume the reason for having preemption disabled when using
> smp_processor_id() is that the code could migrate to another cpu when
> rescheduled?

If the migration could happen, then we could touch the wrong cpu-data,
and the detection on the original cpu will trigger anyway.

> 
> I don't see a problem with the patch, but my low level understanding of
> the __get_cpu_var vs. per_cpu isn't very strong.

Maybe we should use __raw_get_cpu_var() instead.

Thanks,
Yong
