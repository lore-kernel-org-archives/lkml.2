Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1DBUav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 16:30:51 -0400
Received: from fep33.mx.upcmail.net ([62.179.121.51]:60444 "EHLO
	fep33.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1DBUat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 16:30:49 -0400
X-Greylist: delayed 1011 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Apr 2011 16:30:49 EDT
X-SourceIP: 84.114.185.220
Message-ID: <4D978378.7060106@gmx.at>
Date: Sat, 02 Apr 2011 22:13:44 +0200
From: Andreas Huber <hobrom@gmx.at>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-media@vger.kernel.org, Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        andrew.walker27@ntlworld.com, Ben Hutchings <ben@decadent.org.uk>,
        Trent Piepho <xyzzy@speakeasy.org>, Roland Stoll <dvb.rs@xindex.de>
Subject: Re: [PATCH 3/3] [media] cx88: use a mutex to protect cx8802_devlist
References: <20110327150610.4029.95961.reportbug@xen.corax.at> <20110327152810.GA32106@elie> <20110402093856.GA17015@elie> <20110402094451.GD17015@elie> <4D971B8D.4040305@corax.at> <20110402192902.GD20064@elie>
In-Reply-To: <20110402192902.GD20064@elie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=tMVj8KYobzzX0EiRnC7vY2isLrCxFvdg4RrHWPZXwJ0= c=1 sm=0 a=5CFtLWRejkUA:10 a=z4zzRH9NVs0A:10 a=8nJEP1OIZ-IA:10 a=IluopYmYG6V7XhCwiIEA:9 a=as9cG7d6W40BcTcgR-AA:7 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan, thanks for locking into it.
I'll try to debug more deeply what's going wrong and keep you up to date.
Andi.

On 02.04.2011 21:29, Jonathan Nieder wrote:
> Hi Andreas,
>
> (please turn off HTML mail.)
> Andreas Huber wrote:
>
>> There is a reference count bug in the driver code. The driver's
>> active_ref count may become negative which leads to unpredictable
>> behavior. (mpeg video device inaccessible, etc ...)
> Hmm, the patchset didn't touch active_ref handling.
>
> active_ref was added by v2.6.25-rc3~132^2~7 (V4L/DVB (7194):
> cx88-mpeg: Allow concurrent access to cx88-mpeg devices, 2008-02-11)
> and relies on three assumptions:
>
>   * (successful) calls to cx8802_driver::request_acquire are balanced
>     with calls to cx8802_driver::request_release;
>
>   * cx8802_driver::advise_acquire is non-null if and only if
>     cx8802_driver::advise_release is (since both are NULL for
>     blackbird, non-NULL for dvb);
>
>   * no data races.
>
> I suppose it would be more idiomatic to use an atomic_t, but access to
> active_ref was previously protected by the BKL and now it is protected
> by core->lock.  So it's not clear to me why this doesn't work.
>
> Any hints?  (e.g., a detailed reproduction recipe, or a log after
> adding a printk to find out when exactly active_ref becomes negative)
>
> Thanks for reporting.
> Jonathan

