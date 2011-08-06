Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1HFUKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 16:10:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1HFUKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 16:10:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=NxNBvWR5LkeAGfUI0jpNdH+AkenaQUD35sWSP13O+Gw4qilci1aTDF78Zu5ClQg7b
	+HaJz2Y/x4cV4GPrfGWnw==
MIME-Version: 1.0
In-Reply-To: <1310740503-15608-7-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	<1310740503-15608-7-git-send-email-ming.m.lin@intel.com>
Date: Sat, 6 Aug 2011 13:10:10 -0700
Message-ID: <CABPqkBRTw5mcHn29gba8OyeUfMuGU3mQcKsrADug1401n6j0kw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 15, 2011 at 7:35 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> PMU can export general events to sysfs, for example,
>
> /sys/bus/event_source/devices/uncore/events
> └── cycle
>
> Then specify the event as <pmu>:<event>,
>
> $ sudo perf stat -a -C 0 -e uncore:cycle

I think this event syntax should be adjusted a bit.

How would the tool differentiate:
       perf stat -e uncore:cycle
form:
      perf stat -e cycle:u

It would have to scan sysfs for a 'cycle' PMU and conclude
there is none,  then resolve the 'cycle' event name. And if
you're unlucky and you have a event name that matches
the PMU name, you get into troubles.

I think, one could instead do:

    perf stat -e uncore::cycle:k

That way, by virtue of the '::' separator, the tool would know
that it needs to first look into sysfs for an 'uncore' PMU, then
it needs to look for the 'cycle' event.

I also use the '::' notation in libpfm4 to separate the PMU model
form the event+umask+modifiers.

I also suspect that with this sysfs interface for PMU models, you
would simply add a number to differentiate each instance of a PMU.
So for GPU, you would do:
    perf stat -e  gfx0::cycles

Is that right?
