Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1CJFZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:25:41 -0500
Received: from smtp-out.google.com ([74.125.121.67]:52463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1CJFZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 00:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=EYQYslx0781KBI+2ftqtxS1ZUdfVOGsy54zy3ctBO9nyDrEJgNG/LEZPYyKcjCIq/F
         fX7zOgSHrTWLPKebZPcw==
MIME-Version: 1.0
In-Reply-To: <1299727594.15854.310.camel@gandalf.stny.rr.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
 <1299715137-22768-3-git-send-email-dhsharp@google.com> <4D7828F9.7000906@linux.intel.com>
 <1299720997.15854.276.camel@gandalf.stny.rr.com> <4D783038.8080103@linux.intel.com>
 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
 <1299725486.15854.281.camel@gandalf.stny.rr.com> <1299727594.15854.310.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 9 Mar 2011 21:25:17 -0800
Message-ID: <AANLkTi=WRv2PekEyuEh5k9VOv9LmGCWa6KxXn0BeZVSk@mail.gmail.com>
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 7:26 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-03-09 at 21:51 -0500, Steven Rostedt wrote:
>
>> I'll play with some other make tricks and see if I can come up with a
>> better solution.
>
> OK, it didn't take me long to come up with "Makefiles suck" ;)

Yes, except for very basic things.

>
> But I did come up with a solution:
>
> ifneq ("$(origin CC)", "environment")
> CC = gcc
> endif
>
> CC := $(CROSS_COMPILE)$(CC)
>
> This wont let make CC=xx work unless I also add a:
>
> ifneq ("$(origin CC)", "command line")
>
> around the above if, but do we care?
>
> -- Steve

This seems to do it all:

define allow-override
  $(if $(or $(findstring environment,$(origin $(1))),
            $(findstring command line,$(origin $(1)))),,\
    $(eval $(1) = $(2)))
endef

$(call allow-override,CC,$(CROSS_COMPILE)gcc)
$(call allow-override,AR,$(CROSS_COMPILE)ar)
