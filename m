Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1BBECk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 23:02:40 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56286 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1BBECi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 23:02:38 -0500
MIME-Version: 1.0
In-Reply-To: <20110201212605.GB5294@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
	<201101270942.07689.sgrubb@redhat.com>
	<20110128184901.GA5134@localhost>
	<201101281410.29794.sgrubb@redhat.com>
	<20110128193809.GB8854@localhost>
	<1296584221.3145.12.camel@localhost.localdomain>
	<20110201212605.GB5294@localhost>
Date: Tue, 1 Feb 2011 20:02:37 -0800
X-Google-Sender-Auth: 8YZUFbuBEHAfh9K6NOGXGr5s5wY
Message-ID: <AANLkTin6Msom+b8wHULvzEjA+VL5ofQ9wx-ZN5SiK6-p@mail.gmail.com>
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: "Andrew G. Morgan" <morgan@kernel.org>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 1:26 PM, Serge E. Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Eric Paris (eparis@redhat.com):
>> What are we thinking?  Any suggestions how to do what we need other than
>>
>> global bounding such that  pP' = gbset & (fI | pI)
>
> That should be sufficient for what you want.
>
> I would however like to hear whether Andrew has had any other ideas
> given the broader picture.
>

I think I now see what you are after.

You want some sort of transient TCB that can lock all of the doors you
care to lock and then run the whole system in a partially crippled
sandbox.

I have some concerns about how you know you have truly locked down the
system and question the viability of a VM that doesn't virtualize IO
too, but presumably you have some way to protect the storage of the
kernel binary and initrd that cannot be overcome, and protections from
DMA etc. being used by the guest to to overwrite kernel memory.

In this case, I would like to suggest what you need is a user
configurable state for kernel threads to launch helper programs - a
kernel side equivalent to Sergey's wrapper idea.  I continue to
dislike the global bounding set idea, but I would support a base
credential set for this kthread launcher. I'd include pI, bset, and
securebits and uid as something your initrd could initialize away from
their default values for kernel launched helper binaries. I'd prefer
it if you allowed the regular capability convolution rules to apply
and propagate this bounding set for all kernel launched binaries, and
also add the relevant code to init to enforce your desired bounding
set for init parented processes.

This way you will both meet your current needs and also maintain
support for a capability managed 'raw' kernel experience with no
asynchronous capability manipulation system-wide.

Cheers

Andrew


>> Or an interface in which I can force things out of the bset and pI of
>> other tasks?  Possibly the interface could be specific to the "khelper"
>> thread?
>
> No no no no no :)
>
> thanks,
> -serge
>
