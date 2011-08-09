Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1HIO0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:26:14 -0400
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:55458 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1HIO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:26:13 -0400
Message-ID: <4E414381.7070808@ge.com>
Date: Tue, 09 Aug 2011 15:26:09 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch> <4E39555C.30507@ge.com> <20110803140630.GA29460@becoht-mvanga> <20110803152317.GA21903@flamenco.cs.columbia.edu> <4E3A4904.3040007@ge.com> <20110804163451.GA18422@flamenco.cs.columbia.edu> <4E3B9FA2.3060303@ge.com> <20110805090416.GA4806@becoht-mvanga> <4E3BB6E7.6020809@ge.com> <20110809132413.GA9762@becoht-mvanga>
In-Reply-To: <20110809132413.GA9762@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2011 14:22:53.0242 (UTC) FILETIME=[D35789A0:01CC569F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/11 14:24, Manohar Vanga wrote:
> Hey Martyn,
> 
>> I think that by refcounting the resources being used we will know whether a
>> bridge module is being used or not, thus whether it can be unloaded or not. By
>> reference counting the use of resources we minimise the chance of poorly
>> written drivers using resources, but not registering the fact that they are in
>> fact using a VME bridge.
> 
> In the end, this discussion is about what we want the bride module reference count
> to represent. I see your point here that it would be really useful to know what
> resources have been allocated. I am just wondering whether the module refcount is
> a good place to give information on allocated resources (rather than the bridge
> module refcount).
> 
> I am not really an expert in these matters but would something like a sysfs file
> be a cleaner approach to providing information on allocated resources within the
> driver?
> 

That would probably be a better idea.

> With this approach, I am also thinking about cases where resources are not allocated
> within the probe call. This can cause issues if the bridge module is removed after
> a successful probe but before the resources are allocated. This would be a direct
> bug :-/
> 
> If we really don't want explicit module refcounting by drivers, can we perhaps use
> the return value of the probe to automatically do this? eg. in vme_bus_probe() like
> below:
> 
>     int ret = 0;
>     ...
>     vme_bridge_get(bridge);
>     if (driver->probe)
>             ret = driver->probe(vdev);
>     if (ret)
>         vme_bridge_put(bridge);
>     return ret;
> 
> Just a thought. Feel free to shoot it down if you think it's the incorrect
> approach :P
> 

After looking at the PCI and RapidIO subsystems, I think this is probably the
correct approach. I guess the only quiestion then is at which point is
vme_bridge_put() called assuming the probe is successful. I guess at module
unload time, though I haven't checked in the PCI and RapidIO code.

(Thank you for your patience)

Martyn

> Thanks!
> 
> --
> /manohar


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
