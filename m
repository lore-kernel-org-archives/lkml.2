Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0KXQhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:37:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52330 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab0KXQhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mz/lO1VQ7KfBiuLAw4BExQ4TBEfZWw9LfiQ2UJToZ9KwGemi4bdeFbaQS2oshLuHcp
         V4237J083xkgysMD2zMEo8fmwtkuD7OAGsp8CY5kLZ1RSkxz8gTJKSXam494mnnmBWCq
         m144ks0yjNDZJtaO1bD3lj3wCdFVnX6QEYANw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011241012180.14268@router.home>
References: <20101123235139.908255844@linux.com>
	<20101123235201.758191189@linux.com>
	<AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com>
	<alpine.DEB.2.00.1011241012180.14268@router.home>
Date: Wed, 24 Nov 2010 18:37:19 +0200
X-Google-Sender-Auth: NnVnqGlua6WL4JpZn_PR-unfGso
Message-ID: <AANLkTikxrvbDJ=rDhj=gC-FJTa1Jeky1uLWjnP6VF_pX@mail.gmail.com>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 6:17 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 24 Nov 2010, Pekka Enberg wrote:
>
>> > +       /*
>> > +        * The transaction ids are globally unique per cpu and per operation on
>> > +        * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
>> > +        * occurs on the right processor and that there was no operation on the
>> > +        * linked list in between.
>> > +        */
>> > +       tid = c->tid;
>> > +       barrier();
>>
>> You're using a compiler barrier after every load from c->tid. Why?
>
> To make sure that the compiler does not do something like loading the tid
> later. The tid must be obtained before the rest of the information from
> the per cpu slab data is retrieved in order to ensure that we have a
> consistent set of data to operate on.
>
> The critical section begins with the retrieval of the tid and it ends with
> the replacement of the tid with the newly generated one. This means that
> all state data for the alloc and free operation needs to be retrieved in
> that critical section. The change must be saved with the final
> cmpxchg_double of the critical section.

Right and we don't need a *memory barrier* here because we're
accessing a per-CPU variable which means operations appear in-order.

                        Pekka
