Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0JFIcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:32:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0JFIb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WWJxJ+3B7Pa0iaMBTrJL/N+L3LK3/2aAUgxgZ3EHpohtkeaC6dmWiUk86n+OSPEkZS
         sm+Ook+sjHHdOX6cekcA==
MIME-Version: 1.0
In-Reply-To: <1286161717.7410.12.camel@marge.simson.net>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
 <1285682273.7469.3.camel@marge.simson.net> <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
 <1285724758.7440.11.camel@marge.simson.net> <AANLkTi=TQnYGLPC=Pi0o1As83W6VdWdjvimZNSrGT4qW@mail.gmail.com>
 <1286161717.7410.12.camel@marge.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Wed, 6 Oct 2010 01:23:55 -0700
Message-ID: <AANLkTinf7fj5A4DnQOWdj8QeMhf4exPGgpMUdTGA9mTC@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 3, 2010 at 8:08 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Wed, 2010-09-29 at 12:32 -0700, Nikhil Rao wrote:
>> The closest I have is a quad-core dual-socket machine (MC, CPU
>> domains). And I'm having trouble reproducing it on that machine as
>> well :-( I ran 5 soaker threads (one of them niced to -15) for a few
>> hours and didn't see the problem. Can you please give me some trace
>> data & schedstats to work with?
>
> Booting with isolcpus or offlining the excess should help.
>

Sorry for the late reply. Booting with isolcpus did the trick, thanks.

... and now to dig into why this is happening.

-Thanks,
Nikhil

>> Looking at the patch/code, I suspect active migration on the CPU
>> scheduling domain pushes the nice 0 task (running on the same socket
>> as the nice -15 task) to the other socket. This leaves you with an
>> idle core on the nice -15 socket, and with soaker threads there is no
>> way to come back to a 100% utilized state. One possible explanation is
>> the group capacity for a sched group in the CPU sched domain is
>> rounded to 1 (instead of 2). I have a patch below that throws a hammer
>> at the problem and uses group weight instead of group capacity (this
>> is experimental, will refine it if it works). Can you please see if
>> that solves the problem?
>
> Nope, didn't help.  I'll poke at it, but am squabbling elsewhere atm.
>
>        -Mike
>
>
