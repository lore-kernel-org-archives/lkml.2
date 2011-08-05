Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab1HEHpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:45:43 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:46074 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1HEHpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:45:42 -0400
Message-ID: <4E3B9FA2.3060303@ge.com>
Date: Fri, 05 Aug 2011 08:45:38 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch> <4E39555C.30507@ge.com> <20110803140630.GA29460@becoht-mvanga> <20110803152317.GA21903@flamenco.cs.columbia.edu> <4E3A4904.3040007@ge.com> <20110804163451.GA18422@flamenco.cs.columbia.edu>
In-Reply-To: <20110804163451.GA18422@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Aug 2011 07:42:28.0305 (UTC) FILETIME=[39B61410:01CC5343]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/11 17:34, Emilio G. Cota wrote:
> On Thu, Aug 04, 2011 at 08:23:48 +0100, Martyn Welch wrote:
>> On 03/08/11 16:23, Emilio G. Cota wrote:
>>> On Wed, Aug 03, 2011 at 16:06:30 +0200, Manohar Vanga wrote:
>>>>> Can we not do this inside vme_master_request, vme_slave_request, etc?
>>>>> I.e. Add reference count when resources are given out.
>>>>> This would then be done in the vme_*_free routines.
>>>>
>>>> I agree this would be much better. I will change this and resend :)
>>>
>>> To me it seems better to keep this as is, to be
>>> used by .probe and .release methods, in the same way
>>> usb_get_dev() and usb_put_dev() are used by usb drivers.
>>
>> The description of the functions in usb.c suggests, to me at least, that these
>> functions are the equivalent to the vme_*_request functions in the vme code.
>> Being called when a function binds to an interface and when it is finished
>> with it.
> 
> Which functions? usb_get_dev and usb_put_dev? These _only_
> in/de-crement the refcounts. They're called by .probe and
> .release methods of usb drivers. The "resources" or "services"
> the callers acquire from the usb bridge is orthogonal.
> 
> The point is to separate incrementing the refcounts from other
> functionality. We have currently five "request" functions:
> vme_{master,slave,dma,irq,lm}_request. The average driver
> would call two or three of these for each device. This would
> result in a fairly large refcount for the bridge, that would
> tell us nothing about how many users (devices) are hanging in
> there--"yeah, we have lots" is not good enough.
> 

Actually, it would give you a good indication of how many of the resources
provided by each VME bridge chip were used. I don't see the refcount
accurately reflecting the number of users as being important, more as a means
of tracking which bridges have resources that are being used (and therefore
can't be removed).

> So no, usb_get_dev and usb_put_dev are not equivalent to our
> vme_*_request functions. The get/put functions only operate
> on the refcounts, to mark the dependency of a struct device
> on another device (the bridge) so that the parent cannot
> be removed. This is the way things are done in other much
> more mature subsystems, I don't see why we should do it
> differently.
> 

The USB bus and VME bus are very different entities.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
