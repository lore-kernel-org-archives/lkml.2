Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab1DMQPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:15:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34135 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab1DMQPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1104130954270.2005-100000@iolanthe.rowland.org>
References: <201104130205.26988.rjw@sisk.pl> <Pine.LNX.4.44L0.1104130954270.2005-100000@iolanthe.rowland.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 13 Apr 2011 10:15:16 -0600
X-Google-Sender-Auth: sGLFEtOrN8x9AYm0WctvUdB3hUM
Message-ID: <BANLkTiknpAkUQMaq3WZSTHy2cs-vXkv08Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM: Make power domain callbacks take precedence over
 subsystem ones
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 8:17 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 13 Apr 2011, Rafael J. Wysocki wrote:
>
>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>
>> Change the PM core's behavior related to power domains in such a way
>> that, if a power domain is defined for a given device, its callbacks
>> will be executed instead of and not in addition to the device
>> subsystem's PM callbacks.
>>
>> The idea behind the initial implementation of power domains handling
>> by the PM core was that power domain callbacks would be executed in
>> addition to subsystem callbacks, so that it would be possible to
>> extend the subsystem callbacks by using power domains.  It turns out,
>> however, that this wouldn't be really convenient in some important
>> situations.
>>
>> For example, there are systems in which power can only be removed
>> from entire power domains.  On those systems it is not desirable to
>> execute device drivers' PM callbacks until it is known that power is
>> going to be removed from the devices in question, which means that
>> they should be executed by power domain callbacks rather then by
>> subsystem (e.g. bus type) PM callbacks, because subsystems generally
>> have no information about what devices belong to which power domain.
>> Thus, for instance, if the bus type in question is the platform bus
>> type, its PM callbacks generally should not be called in addition to
>> power domain callbacks, because they run device drivers' callbacks
>> unconditionally if defined.
>
> What about systems where it makes sense to execute the subsystem
> callbacks even if power isn't going to be removed from the device?
> It's quite possible that the subsystem could reduce the device's power
> consumption even when the device isn't powered down completely.

The understanding Rafael and I came to was that if a power domain is
attached to a device, then the power domain becomes the responsible
party.  Normally this means it will turn around and immediately call
the bus_type pm ops, but it has the option to not call them if for a
particular system it knows better, or to defer calling them.

Basically, if you're using a power domain, it is assumed that the
power domain has particular knowledge about the system, and it should
have the option to override the default behaviour.

>
> Is the extra overhead of invoking the subsystem callback really all
> that troublesome?

It isn't an overhead problem.  It's a control & complexity problem.
We could try to implement a heuristic or api to control when the bus
type PM ops should be overridden, but I think it is cleaner to make it
a rule that if you implement a power domain, then that power domain
becomes responsible for all PM operations.

g.
