Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1BOLBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:01:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57824 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1BOLBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:01:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IlZBcXoGVZVM0jhoLWhAzgCa9uwf0BynqyCKrQJH49xpLxBa7rNWZTfG0ICwwXWRzW
         iLxwdsn4aIW7lrLbv859h9aK8kccXR4uNoVOCoauBSf2g1wrCOxm+0iKzDyCIV80BVyO
         ZIsnmRtuRvqJMKbVBDQkgaxX+1mubDp5DrKbA=
MIME-Version: 1.0
In-Reply-To: <4D59B891.8010300@zytor.com>
References: <1297707868.5226.189.camel@laptop>
	<1297718964.23343.75.camel@gandalf.stny.rr.com>
	<1297719576.23343.80.camel@gandalf.stny.rr.com>
	<20110214.134600.179933733.davem@davemloft.net>
	<20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
	<4D59B891.8010300@zytor.com>
Date: Tue, 15 Feb 2011 11:01:21 +0000
Message-ID: <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Will Newton <will.newton@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, David Miller <davem@davemloft.net>,
        rostedt@goodmis.org, peterz@infradead.org, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/14/2011 02:37 PM, Matt Fleming wrote:
>>>
>>> I don't see how cache coherency can possibly work if the hardware
>>> behaves this way.
>>
>> Cache coherency is still maintained provided writes/reads both go
>> through the cache ;-)
>>
>> The problem is that for read-modify-write operations the arbitration
>> logic that decides who "wins" and is allowed to actually perform the
>> write, assuming two or more CPUs are competing for a single memory
>> address, is not implemented in the cache controller, I think. I'm not a
>> hardware engineer and I never understood how the arbitration logic
>> worked but I'm guessing that's the reason that the ll/sc instructions
>> bypass the cache.
>>
>> Which is why the atomic_t functions worked out really well for that
>> arch, such that any accesses to an atomic_t * had to go through the
>> wrapper functions.
>
> I'm sorry... this doesn't compute.  Either reads can work normally (go
> through the cache) in which case atomic_read() can simply be a read or
> they don't, so I don't understand this at all.

The CPU in question has two sets of instructions:

  load/store - these go via the cache (write through)
  ll/sc - these operate literally as if there is no cache (they do not
hit on read or write)

This may or may not be a sensible way to architect a CPU, but I think
it is possible to make it work. Making it work efficiently is more of
a challenge.
