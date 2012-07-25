Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab2GYOrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:47:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51432 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933117Ab2GYOrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:47:33 -0400
Date: Wed, 25 Jul 2012 15:47:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <20120725144724.GD1894@decadent.org.uk>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-3-git-send-email-kys@microsoft.com>
 <1343178644.5132.103.camel@deadeye.wl.decadent.org.uk>
 <426367E2313C2449837CD2DE46E7EAF9236A8B61@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9236A8B61@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 03/17] Drivers: hv: kvp: Cleanup error handling in KVP
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:10:05PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Ben Hutchings [mailto:ben@decadent.org.uk]
> > Sent: Tuesday, July 24, 2012 9:11 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> > apw@canonical.com; netdev@vger.kernel.org
> > Subject: Re: [PATCH 03/17] Drivers: hv: kvp: Cleanup error handling in KVP
> > 
> > On Tue, 2012-07-24 at 09:01 -0700, K. Y. Srinivasan wrote:
> > > In preparation to implementing IP injection, cleanup the way we propagate
> > > and handle errors both in the driver as well as in the user level daemon.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/hv/hv_kvp.c      |  112 +++++++++++++++++++++++++++++++++++++-
> > --------
> > >  include/linux/hyperv.h   |   17 +++++---
> > >  tools/hv/hv_kvp_daemon.c |   70 +++++++++++++++-------------
> > >  3 files changed, 138 insertions(+), 61 deletions(-)
> > >
> > > diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
> > > index 0012eed..9b7fc4a 100644
> > > --- a/drivers/hv/hv_kvp.c
> > > +++ b/drivers/hv/hv_kvp.c
> > [...]
> > > @@ -109,27 +154,52 @@ kvp_cn_callback(struct cn_msg *msg, struct
> > netlink_skb_parms *nsp)
> > >  {
> > >  	struct hv_kvp_msg *message;
> > >  	struct hv_kvp_msg_enumerate *data;
> > > +	int	error = 0;
> > >
> > >  	message = (struct hv_kvp_msg *)msg->data;
> > > -	switch (message->kvp_hdr.operation) {
> > > +
> > > +	/*
> > > +	 * If we are negotiating the version information
> > > +	 * with the daemon; handle that first.
> > > +	 */
> > > +
> > > +	if (in_hand_shake) {
> > > +		if (kvp_handle_handshake(message))
> > > +			in_hand_shake = false;
> > > +		return;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Based on the version of the daemon, we propagate errors from the
> > > +	 * daemon differently.
> > > +	 */
> > > +
> > > +	data = &message->body.kvp_enum_data;
> > > +
> > > +	switch (dm_reg_value) {
> > >  	case KVP_OP_REGISTER:
> > > -		pr_info("KVP: user-mode registering done.\n");
> > > -		kvp_register();
> > > -		kvp_transaction.active = false;
> > > -		hv_kvp_onchannelcallback(kvp_transaction.kvp_context);
> > > +		/*
> > > +		 * Null string is used to pass back error condition.
> > > +		 */
> > > +		if (!strlen(data->data.key))
> > 
> > Do we know that the key is null-terminated here?  Shouldn't we just
> > check whether data->data.key[0] == 0?
> 
> Yes, currently we do return null string to indicate error.
[...]

So the kernel should assume userland input is always valid?

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
