Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0FXRgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:36:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:34918 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0FXRgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,475,1272870000"; 
   d="scan'208";a="579579919"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, "henuxd@gmail.com" <henuxd@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "mattij.lammi@gmail.com" <mattij.lammi@gmail.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Jun 2010 10:36:10 -0700
Subject: RE: [PATCH 2/2] Staging: memrar: Fixed memrar_handler.c
Thread-Topic: [PATCH 2/2] Staging: memrar: Fixed memrar_handler.c
Thread-Index: AcsTfFPWcbOtW/hwQhqn3KUOrttiUgARcNXg
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950CEA181604@orsmsx510.amr.corp.intel.com>
References: <1277363386-4817-1-git-send-email-henuxd@gmail.com>
	<1277363386-4817-2-git-send-email-henuxd@gmail.com>
 <20100624100948.6446f8bd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100624100948.6446f8bd@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> >  size_t memrar_allocator_largest_free_area(struct memrar_allocator
> *allocator)
> >  {
> > -	if (allocator == NULL)
> > -		return 0;
> > -	return allocator->largest_free_area;
> > +	size_t tmp = 0;
> > +
> > +	if (allocator != NULL) {
> > +		mutex_lock(&allocator->lock);
> > +		tmp = allocator->largest_free_area;
> > +		mutex_unlock(&allocator->lock);
> 
> This doesn't seem to make any sense (in either version). The moment you
> drop the lock the value in "tmp" becomes stale as the allocator could
> change it. ?

Agreed, but I don't think there's anything we can do about it with the current interface.  We will always have a time-of-check-time-of-use TOCTOU race with this function as it stands.  I pointed out the issue in my response to Henri as well, but I focused more on hiding the lock from the caller.  The TOCTOU race exists in both versions, i.e. the old code and proposed new code.  The value returned from this function in this particular case will ultimately be passed to the user when the user issues a RAR_HANDLER_STAT ioctl to the /dev/memrar device.  For the most part, this function is only used for debugging.  It is not needed for general operation of the memrar_allocator or the memrar_handler (/dev/memrar).

-Ossama

