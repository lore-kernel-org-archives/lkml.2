Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0HECrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:47:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2047 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0HECrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:47:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jUHrQg7r5aw4jgakYtq3JEWReCjwTkg3AmC9oUMgmTOLaPqfz0LozKIEuXcu5rk+9
	yNqYO73uywthx0iap7+tw==
MIME-Version: 1.0
In-Reply-To: <20100805023939.GA2987@linux.vnet.ibm.com>
References: <20100801054816.GI2470@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm>
	<20100804185520.GA2417@srcf.ucam.org>
	<201008042251.08266.rjw@sisk.pl>
	<20100804205654.GA4986@srcf.ucam.org>
	<AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com>
	<20100805023939.GA2987@linux.vnet.ibm.com>
Date: Wed, 4 Aug 2010 19:46:56 -0700
Message-ID: <AANLkTim9jaCb3NyRwsLNv5thGKOqpbWX_5vL8TPrtA0b@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/4 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Wed, Aug 04, 2010 at 03:08:33PM -0700, Arve Hjønnevåg wrote:
>> On Wed, Aug 4, 2010 at 1:56 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> [ . . . ]
>
>> > having this conversation? :) It'd be good to have some feedback from
>> > Google as to whether this satisfies their functional requirements.
>>
>> That is "this"? The merged code? If so, no it does not satisfy our
>> requirements. The in kernel api, while offering similar functionality
>> to the wakelock interface, does not use any handles which makes it
>> impossible to get reasonable stats (You don't know which pm_stay_awake
>> request pm_relax is reverting). The proposed in user-space interface
>> of calling into every process that receives wakeup events before every
>> suspend call is also not compatible with existing apps.
>
> I should have asked this earlier...  What exactly are the apps'
> compatibility constraints?  Source-level APIs?  Byte-code class-library
> invocations?  C/C++ dynamic linking?  C/C++ static linking (in other
> words, syscall)?

For Java/Dalvik apps, the wakelock API is pertty high level -- it
talks to a service via RPC (Binder) that actually interacts with the
kernel.  Changing the basic kernel<->userspace interface (within
reason) is not unthinkable.  For example, Arve's suspend_blocker patch
provides a device interface rather than the proc interface the older
wakelock patches use.  We'd have to make some userspace changes to
support that but they're pretty low level and minor.

In the current model, only a few processes need to specifically
interact with the kernel (the power management service in the
system_server, possibly the media_server and the radio interface
glue).  A model where every process needs to have a bunch of
instrumentation is not very desirable from our point of view.  We
definitely do need reasonable statistics in order to enable debugging
and to enable reporting to endusers (through the Battery Usage UI)
what's keeping the device awake.

Brian
