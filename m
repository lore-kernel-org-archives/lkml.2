Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1GJOYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 10:24:36 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44178 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1GJOYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 10:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6sypBwP6aKoaxq1ipoEfqvnqq2RMhi9d0KU=LHjJm9x_g@mail.gmail.com>
References: <20110704170949.11059.92774.stgit@ponder> <20110704180159.GA11278@ponder.secretlab.ca>
 <20110705142149.GA3498@suse.de> <201107051721.02079.arnd@arndb.de>
 <20110705155040.GB16682@suse.de> <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
 <CACxGe6sypBwP6aKoaxq1ipoEfqvnqq2RMhi9d0KU=LHjJm9x_g@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 10 Jul 2011 16:24:12 +0200
Message-ID: <CAPXgP11wKfp7CMuXpoensQ9ey+CeH86h6KT3aW5NrQx1WZaWHg@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 18:28, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Jul 5, 2011 at 10:11 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Tue, Jul 5, 2011 at 17:50, Greg KH <gregkh@suse.de> wrote:
>>
>>> I wonder if doing this all from a workqueue in the first place is going
>>> to cause problems as probe isn't normally done this way at all.
>>
>> Yeah, I would expect unforeseen problems with the async thread too.
>> It's probably all solvable, but it sounds troublesome to find out if
>> things go wrong.
>>
>> We have sync hooks (BUS_NOTIFY_*) where any kind of code can subscribe
>> to when devices get added or get bound to a driver. Can't the code
>> that relies on later hookups to already existing devices/bindings not
>> just plug into that?
>
> I tried that.  It resulted in a lot of complexity that each driver
> needs to implement correctly which is why I started looking for a
> different way to go about it.

What I mean is that we might not necessarily need to have that in
'struct device' and the driver-binding code. Can't we just allocate
the reprobe-in-the-back logic in its own object, let this object hook
into the existing notifier chain (if needed add more notifiers) and
have your reprobe object itself check for the device, carry its own
list of devices and trigger the needed work?

(As a general note, not specifically related to this patch: The
current 'struct device' is a total mess already, and really needs to
be cleaned up. The list.h way of doing lists might perform nice in
some always-be-a-list-member used cases, but it is really not the
appropriate way of doing non-common functionality on common objects:
performance does not matter at all here, and the object-to-add itself
has to carry the list-data needed for every non-common list.)

Kay
