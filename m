Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab1FXWaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:30:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab1FXWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vqxpUT3BeYzqk5zNXvCAwet5qDmJchyJtB6kmxRc8tcSQIiLu0gRxDhmraHvdOGezC
         7SUcn9qt9YcsgWh0xJDQ==
MIME-Version: 1.0
In-Reply-To: <20110623134759.GC8058@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <1308527474-20704-5-git-send-email-fweisbec@gmail.com> <BANLkTin_MA+Yc7=q=cK5s2CbCfu_xmqTAQ@mail.gmail.com>
 <20110623134759.GC8058@somewhere.redhat.com>
From: Paul Menage <menage@google.com>
Date: Fri, 24 Jun 2011 15:22:11 -0700
Message-ID: <BANLkTimiQBkDZ=L9UR-yGMATw9o-3JVtMEaMP36zey=_9pxL9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 6:48 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> Can't this fail spuriously in the presence of hierarchies?
>>
>> E.g. if cgroup A has children, and A is at its limit, then moving
>> tasks around between A and its children, or between different children
>> of A, seems like it would fail due to the temporary double counting.
>
> Good point. Probably I should first uncharge the old cgroup and its parents.
>

That can fail too - if a new task gets created between the uncharge
and the charge.

What we need is a res_counter_move_charge(A, B, amount) function which will:

- locate C, the nearest common ancestor of A and B
- lock up the chain from B up to but not including C, adding the new charge
- unlock up the chain from B to C
- uncharge along the chain from A up to but not including C (not sure
how much locking is needed there since there's no need for roll back).

Paul
