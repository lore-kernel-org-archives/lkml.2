Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab0FJVEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 17:04:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:60978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565Ab0FJVEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 17:04:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=DBABP/DGicUrwVmHn4wfzfRJ13yU42jSU6nFVitvRs+kmp5wKUjERqKEhV8ntPsK5
	dVThJFuhcD/zs94Yc59NA==
MIME-Version: 1.0
In-Reply-To: <20100610203815.GA15868@thunk.org>
References: <20100610200911.18287.29658.stgit@bumblebee1.mtv.corp.google.com>
	<20100610203815.GA15868@thunk.org>
Date: Thu, 10 Jun 2010 14:04:25 -0700
Message-ID: <AANLkTimCWkl2cxt2Yz0IB6ou_lSfWPssvvTjGplKTaIT@mail.gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
	reused immediately.
From: Salman Qazi <sqazi@google.com>
To: tytso@mit.edu, Salman <sqazi@google.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, tytso@google.com,
       akpm@linux-foundation.org, walken@google.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 1:38 PM,  <tytso@mit.edu> wrote:
> On Thu, Jun 10, 2010 at 01:09:11PM -0700, Salman wrote:
>> A program that repeatedly forks and waits is susceptible to having the
>> same pid repeated, especially when it competes with another instance of the
>> same program.  This is really bad for bash implementation.  Furthermore, many shell
>> scripts assume that pid numbers will not be used for some length of time.
>
> This should probably get wrapped at column 74 or so....
>
>> +static int pid_before(int base, int a, int b)
>> +{
>> +     /*
>> +      * This is the same as saying
>> +      *
>> +      * (a - base + MAXUINT) % MAXUINT < (b - base + MAXUINT) % MAXUINT
>> +      * and that mapping orders 'a' and 'b' with respect to 'base'.
>> +      *
>> +      */
>> +     return (unsigned)(a - base) < (unsigned)(b - base);
>> +}
>
> Does this work though if /proc/sys/kernel/pid_max is not set to
> MAXUINT?

Yes it does.  It should work for all values of pid_max.
>
> I like the optimization, but it looks like pid_max defaults to 4096 if
> CONFIG_BASE_SMALL is set, and 32768 otherwise.
>
> Am I missing something?

Yes.

(a - base + pid_max) % pid_max < (b - base + max_pid) % pid_max iff
(a - base + MAXUINT) % MAXUINT < (b - base + MAXUINT) % MAXUINT
for all pid_max <= MAXUINT.

The values of 'a' (or 'b')  in the range [base, pid_max) gets mapped
to [0, pid_max - base) and the range [0, base) gets mapped to
[MAXUINT, MAXUINT - base).  So, the order is essentially maintained by
this mapping.

>
>                                        - Ted
>
