Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab0ESWMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:12:54 -0400
Received: from maila.microsoft.com ([131.107.115.212]:47517 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0ESWMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:12:53 -0400
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
Thread-Index: AQHK92uLW80ITLq46EC/wvbFNLfG5ZJZYgWA///QKxCAAHrxgP//nqdQ
Date: Wed, 19 May 2010 22:12:51 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8951F@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7266B8930E@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100519161011.GA20266@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B894B0@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100519203901.GA23214@suse.de>
In-Reply-To: <20100519203901.GA23214@suse.de>
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

> > Actually, we already assign a default callback function,
> chn_cb_negotiate(),
> > when the channels are opened in vmbus module. It's a real function
> and can
> > handle common negotiation messages.
> 
> Then why don't you use it here?

When vmbus is loaded and channel is offered from HyperV host, the default
callback function, chn_cb_negotiate(), is assigned to the function ptr, and
used to do basic responses of negotiation messages. 

After hv_utils modules is loaded the callback function ptr is overridden by 
a specialized function in hv_utils module, and handles each feature (shutdown, 
timesync, etc.) differently.

> I still think there's a real problem somewhere else in the architecture
> if such a sleep is necessary...
> 
> Is the issue that the modprobe of the hv_vmbus can return before the
> bus
> is really all set up and ready to go?  If so, just fix that, then you
> will not need any "sleep" calls anywhere, right?

After vmbus is loaded, the channel offering will come from the host, then
it initializes the channel. The channel offering can happen a little later
after vmbus_init() is done and modprobe returns. So I think we should let
vmbus_init function wait(sleep) until all channel offerings are received before
returning. This will ensure all channels are ready before modprobe returns.

Thanks,

- Haiyang
