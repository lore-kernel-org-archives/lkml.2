Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1AKWIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:08:15 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1AKWIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Fx6eM4ME1AqW3PnpzfNcl3b12pP6hyx+CPcZeQM+MhU70Tkx2ljnrkdV3yhFxeapwD
         TgGUJu+TQSu71+MsMUqQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
 <1294700597-24239-1-git-send-email-mikew@google.com> <20110111065540.GA16036@aftab>
 <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
From: Duncan Laurie <dlaurie@google.com>
Date: Tue, 11 Jan 2011 14:07:55 -0800
Message-ID: <AANLkTik6ykkg9f+3gpMGa-EGZrYEMVusTC5=MP5usVDM@mail.gmail.com>
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
To: Mike Waychison <mikew@google.com>
Cc: Borislav Petkov <bp@amd64.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:56 AM, Mike Waychison <mikew@google.com> wrote:
>
> As for using EDAC, I know we tried using it a few years ago, but have
> since reverted to processing MCE ourselves.  I don't know all the
> details as to why, however Duncan Laurie might be able to share more
> (CCed).
>


The short answer is that we needed access to the raw chipset error
registers rather than the parsed and collated counters (or printk
output) that we got with EDAC.

The long answer is that our goals have changed over time.  For a long
time our goal with ECC was simply identifying the actual bad DIMM in a
system so it can be replaced.  For systems which report ECC via
machine checks this is done by collecting the physical addresses and
converting it with an external utility.  For other systems which did
not report memory errors via machine checks EDAC was used to poll and
decode the chipset error registers and export row+channel sysfs
counters because there was not a physical memory address supplied with
each event.

However as the scale of our operations grows so too does the number of
DIMMs that have to be replaced.  By gathering and analyzing complete
error data (row, column, bank, rank, etc) we are able to identify if
there is a single chip on a module that is bad, which could
potentially get repaired rather than replacing the whole module.

Gathering this data is easy enough with machine checks since you have
the physical address on which it occurred and doing the translation of
that address into a particular DIMM ends up providing the other
relevant geometry information along the way.  It also has a convenient
interface via mcelog that makes it easy to consume the event and do
the translation in userspace (as long as you run with a high mce
tolerance level) and has other advantages of being able to develop and
maintain the utility outside of our internal kernel release schedule.

For platforms that were reporting counters via EDAC there are several
values that need to be read from different chipset registers and
exported.  Because parsing printk output for this data is messy we
decided that rather than invent another mcelog type interface (or
subvert an existing interface) we might as well do the polling for
events in userspace and simply save all the data we care about at that
point.

As has been noted this requires us to have intimate knowledge of the
hardware that we're running on.  It isn't an approach that I would
recommend to many and your efforts to do decoding of errors with EDAC
is something that most people will benefit from.

-duncan
