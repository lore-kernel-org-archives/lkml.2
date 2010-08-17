Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0HQEp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:45:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:56876 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0HQEp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:45:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=L25Yohkpr9hUQOos2FUg1qdQpUmysyZeELlLlpdNS0X7v8OaSfbX9GDS/Bnmmo1xX
	wJqRtRFy2yzb3TXcAcFPg==
MIME-Version: 1.0
In-Reply-To: <AANLkTikDHG7Xo2hrrwxp1DYgGNbV6BXipY+p_Uo50498@mail.gmail.com>
References: <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
	<1281987236.1926.1895.camel@laptop>
	<AANLkTindpUo5tPiXVp6wXjOAqczrJvYegrOMBqSjr4_t@mail.gmail.com>
	<1281992801.1926.2019.camel@laptop>
	<AANLkTikDHG7Xo2hrrwxp1DYgGNbV6BXipY+p_Uo50498@mail.gmail.com>
Date: Mon, 16 Aug 2010 21:45:23 -0700
Message-ID: <AANLkTimk_16nz2BWB42yHAAseaEJP-DBdondBO5oznrQ@mail.gmail.com>
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and the implementation.
From: Salman Qazi <sqazi@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@us.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adurbin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 9:35 PM, Salman Qazi <sqazi@google.com> wrote:
> On Mon, Aug 16, 2010 at 2:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> (html damaged email alert)
>>
>> On Mon, 2010-08-16 at 13:59 -0700, Salman Qazi wrote:
>>> On Mon, Aug 16, 2010 at 12:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>         On Mon, 2010-08-16 at 11:30 -0700, Salman Qazi wrote:
>>>         > For the delete case,
>>>         > we no longer shrink the tree back to being just the root containing the
>>>         > only remaining object.  For the insert case, we no longer store the
>>>         > first object in the root, rather allocating a node structure for it.  The
>>>         > reason that this works is that deleting (or inserting) intermediate nodes
>>>         > does not make a difference to a reader holding a slot.
>>>
>>>
>>>         Ah, I through that was what it did. So you basically increase the memory
>>>         footprint for tiny files.. have you done any measurements on that?
>>>
>>
>>> You raise a valid concern.  I haven't.  What would you recommend as a
>>> benchmark/metric to measure this?
>>
>> One thing you could try is something like the below on a freshly booted
>> machine, once without and once with the patch:
>>
>>  cd /usr/src/linux-2.6
>>  echo 1 > /proc/sys/vm/drop_caches
>>  grep radix /proc/slabinfo
>>  make bzImage
>>  echo 1 > /proc/sys/vm/drop_caches
>>  grep radix /proc/slabinfo
>>
>>
>>
>>
>
> Here's what I see:
>
> Without the patch:
>
> Before:
> radix_tree_node      468   1400    568   28    4 : tunables    0    0
>  0 : slabdata     50     50      0
>
> After:
> radix_tree_node     1886   3192    568   28    4 : tunables    0    0
>  0 : slabdata    114    114      0
>
> With the patch:
>
> Before:
>
> radix_tree_node      495   1176    568   28    4 : tunables    0    0
>  0 : slabdata     42     42      0
>
> After:
>
> radix_tree_node     3173   7336    568   28    4 : tunables    0    0
>  0 : slabdata    262    262      0
>
>
> So, not particularly good news :(.
>

But considering that the kernel locks up, and we are still talking
about < 5MB after a kernel compile, should we really be all that
concerned?  If so, what are the alternatives that should be considered
for fixing this lock up?
