Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab1HIN1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:27:21 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:57656 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1HIN1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:27:18 -0400
Date: Tue, 9 Aug 2011 15:24:13 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: "Emilio G. Cota" <cota@braap.org>, <gregkh@suse.de>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110809132413.GA9762@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>,
	"Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch>
 <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
 <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E3BB6E7.6020809@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

> I think that by refcounting the resources being used we will know whether a
> bridge module is being used or not, thus whether it can be unloaded or not. By
> reference counting the use of resources we minimise the chance of poorly
> written drivers using resources, but not registering the fact that they are in
> fact using a VME bridge.

In the end, this discussion is about what we want the bride module reference count
to represent. I see your point here that it would be really useful to know what
resources have been allocated. I am just wondering whether the module refcount is
a good place to give information on allocated resources (rather than the bridge
module refcount).

I am not really an expert in these matters but would something like a sysfs file
be a cleaner approach to providing information on allocated resources within the
driver?

With this approach, I am also thinking about cases where resources are not allocated
within the probe call. This can cause issues if the bridge module is removed after
a successful probe but before the resources are allocated. This would be a direct
bug :-/

If we really don't want explicit module refcounting by drivers, can we perhaps use
the return value of the probe to automatically do this? eg. in vme_bus_probe() like
below:

    int ret = 0;
    ...
    vme_bridge_get(bridge);
    if (driver->probe)
            ret = driver->probe(vdev);
    if (ret)
        vme_bridge_put(bridge);
    return ret;

Just a thought. Feel free to shoot it down if you think it's the incorrect
approach :P

Thanks!

--
/manohar
