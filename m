Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab2CFJdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:33:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab2CFJdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:33:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Date: Tue, 6 Mar 2012 09:10:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca> <201203051915.45197.arnd@arndb.de> <CACxGe6ujqF3st0y5jbWxx=amr534NY3RHdUzmVVdjqt=fJMJmA@mail.gmail.com>
In-Reply-To: <CACxGe6ujqF3st0y5jbWxx=amr534NY3RHdUzmVVdjqt=fJMJmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203060910.52207.arnd@arndb.de>
X-Provags-ID: V02:K0:kxPtv0Uj30ycKIHTSDTYXaDKH48rVJFoCkmDR6tAlci
 ad64oBPyKFThtzmehYnYYFSREIdUg7mSRZhChJDmqa9q2eZ/Nf
 8Ekuj6gRiAKLRDUqRUIuu32/FYB5+oIaH0NOU6fGQqKL6d/GvD
 L/Pp5Y/mrSFo4HS/BZ6R6PmX9XlA/28yVyRR4/PDVkTu0gCvXo
 WKkmD1dhONB0TDZPBsOcqENSKOlhK/n0GY+paZgSi27vuRVtzq
 urcdv3i0VKmuV6tIz9+gg5Yyh9czzu1mDEUUeuTX0hapMsi75y
 2gllPDeU7UJQUGp7UBuY7/0zCZNc5wEyczNScelgSNuYdNS65+
 ADGnane+q+x8PktNlynI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2012, Grant Likely wrote:
> >
> > Also, What protects the device from going away between being put on the list
> > and taken off of it? Don't you have to do the device_get during
> > driver_deferred_probe_add()?
> 
> The deferred_probe_mutex.  Nothing can be removed from the deferred
> list without holding the deferred_probe_mutex, and no device can be
> freed before it is taken off the deferred list.  If the device is in
> the process of being removed, then get_device() occurs before dropping
> the mutex to protect against freeing, and bus_probe_device() won't
> attach a driver to a device getting removed.

Ok, got it now. So there were actually three bugs that I found that
turned out to be correct in the end. This also means that if you
want to change to making deferred_probe_active_list local
to the work function and not locked, you actually will need to
get the reference count on the device as soon as you put it on
the pending list. Since that would be a major design change with
little benefit, I agree that you should not change it from the tested
version for now.

	Arnd

