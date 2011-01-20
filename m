Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1ATHGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:06:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44019 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1ATHGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:06:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ujjoro++K/baD6SQWb4QtA4VffSODVrNu0Cxq0375a7KEMlicopNWOPu65nt6ySSxm
         TDf3utxyudfrP6QaswnNelS00ps8+zdHJQI+gHcVeNVl2dDjcPcujemleGRM7P+Hoz9I
         CW8W/nXp16N78p/aBlXimhZv4i4lSFQRTTek8=
MIME-Version: 1.0
In-Reply-To: <1295503938.8027.59.camel@marge.simson.net>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
	<AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	<1295357746.30950.681.camel@laptop>
	<AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	<1295430276.30950.1414.camel@laptop>
	<1295433498.30950.1482.camel@laptop>
	<1295436632.30950.1542.camel@laptop>
	<1295441881.11678.41.camel@kolo>
	<1295442799.11678.43.camel@kolo>
	<1295443822.28776.23.camel@laptop>
	<AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
	<1295499568.8027.30.camel@marge.simson.net>
	<AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
	<1295503938.8027.59.camel@marge.simson.net>
Date: Thu, 20 Jan 2011 15:06:16 +0800
Message-ID: <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 2:12 PM, Mike Galbraith <efault@gmx.de> wrote:
> If the task returns as a sleeper, place entity() will be called when it
> is awakened, so it's sleep credit will be clipped as usual.  So vruntime
> can be much less than min_vruntime at class exit time, and it doesn't
> matter, clipping on wakeup after re-entry takes care of it.. if that's
> what you were thinking about.

For a sleep task which stay in sched_fair before it's waked:
try_to_wake_up()
  ttwu_activate()
    activate_task()
      enqueue_task_fair()
        enqueue_entity()
          place_entity()        <== clip vruntime

For a sleep task which promote to sched_rt when it's sleep:
rt_mutex_setprio()
  check_class_changed()
    switch_from_fair()       <== vruntime -= min_vruntime
      try_to_wake_up()
        ...run then stay on rq
        rt_mutex_setprio()
          enqueue_task_fair()     <==vruntime += min_vruntime

The difference is that in the second case, place_entity() is not
called, but wrt sched_fair, the task is a WAKEUP task.
Then we place this task in sched_fair before where it should be.

Thanks,
Yong

-- 
Only stand for myself
