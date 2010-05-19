Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0ESUaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:30:30 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:18969 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0ESUa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:30:29 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/2] staging: hv: Fix race condition in hv_utils module
 initialization.
Thread-Topic: [PATCH 1/2] staging: hv: Fix race condition in hv_utils module
 initialization.
Thread-Index: AQHK92uLW80ITLq46EC/wvbFNLfG5ZJZYgWA///QKxA=
Date: Wed, 19 May 2010 20:30:25 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B894B0@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7266B8930E@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100519161011.GA20266@suse.de>
In-Reply-To: <20100519161011.GA20266@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* Wait until all IC channels are initialized */
> > +	while (atomic_read(&hv_utils_initcnt) < MAX_MSG_TYPES)
> > +		msleep(100);
> 
> No, don't do this here, do something in your hv_vmbus core to handle
> registering sub-drivers properly.  Perhaps you need to sleep there
> before you can succeed on a initialization.

Thanks for the recommendation. I will put the sleep into vmbus_init to 
ensure all channels are ready before the vmbus_init function exits.

> >  	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =
> >  		&shutdown_onchannelcallback;
> 
> The problem is that you just have a bunch of callbacks you are setting
> up, it's not a "real" function call.  Please change it over to a
> function call, like all other subsystems have.  Then, you can handle
> any
> "sleep until we are set up properly" issues in the vmbus code, not in
> each and every individual bus driver.

Actually, we already assign a default callback function, chn_cb_negotiate(),
when the channels are opened in vmbus module. It's a real function and can 
handle common negotiation messages.
I will move the sleep into vmbus module as well.

Thanks,

- Haiyang
