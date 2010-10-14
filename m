Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0JNXbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:31:43 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:21154 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab0JNXbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:31:41 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Ben Hutchings <bhutchings@solarflare.com>,
        Stephen Hemminger <shemminger@vyatta.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 14 Oct 2010 16:31:35 -0700
Subject: RE: [PATCH 2.6.35-rc6] net-next: Add multiqueue support to vmxnet3
 driver
Thread-Topic: [PATCH 2.6.35-rc6] net-next: Add multiqueue support to vmxnet3
 driver
Thread-Index: ActrvTekFF7h4z61SPOhYzVaETRcFgAK5xmQ
Message-ID: <89E2752CFA8EC044846EB8499819134102BF0F3B1D@EXCH-MBX-4.vmware.com>
References: <alpine.LRH.2.00.1009290104130.464@sbhatewara-dev1.eng.vmware.com>
	 <alpine.LRH.2.00.1010131445080.25989@sbhatewara-dev1.eng.vmware.com>
	 <20101013145732.7d69d0f3@nehalam>
 <1287073868.2258.13.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1287073868.2258.13.camel@achroite.uk.solarflarecom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9ENVx5m013539



> -----Original Message-----
> From: Ben Hutchings [mailto:bhutchings@solarflare.com]
> Sent: Thursday, October 14, 2010 9:31 AM
> To: Stephen Hemminger; Shreyas Bhatewara
> Cc: netdev@vger.kernel.org; pv-drivers@vmware.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2.6.35-rc6] net-next: Add multiqueue support to
> vmxnet3 driver
> 
> On Wed, 2010-10-13 at 14:57 -0700, Stephen Hemminger wrote:
> > On Wed, 13 Oct 2010 14:47:05 -0700 (PDT)
> > Shreyas Bhatewara <sbhatewara@vmware.com> wrote:
> >
> > > #ifdef VMXNET3_RSS
> > > +static unsigned int num_rss_entries;
> > > +#define VMXNET3_MAX_DEVICES 10
> > > +
> > > +static int rss_ind_table[VMXNET3_MAX_DEVICES *
> > > +			 VMXNET3_RSS_IND_TABLE_SIZE + 1] = {
> > > +	[0 ... VMXNET3_MAX_DEVICES * VMXNET3_RSS_IND_TABLE_SIZE] = -1 };
> > > +#endif
> > > +static int num_tqs[VMXNET3_MAX_DEVICES + 1] = {
> > > +	[0 ... VMXNET3_MAX_DEVICES] = 1 };
> > > +static int num_rqs[VMXNET3_MAX_DEVICES + 1] = {
> > > +	[0 ... VMXNET3_MAX_DEVICES] = 1 };
> > > +static int share_tx_intr[VMXNET3_MAX_DEVICES + 1] = {
> > > +	[0 ... VMXNET3_MAX_DEVICES] = 0 };
> > > +static int buddy_intr[VMXNET3_MAX_DEVICES + 1] = {
> > > +	[0 ... VMXNET3_MAX_DEVICES] = 1 };
> > > +
> > > +static unsigned int num_adapters;
> > > +module_param_array(share_tx_intr, int, &num_adapters, 0400);
> > > +MODULE_PARM_DESC(share_tx_intr, "Share one IRQ among all tx queue
> completions. "
> > > +		 "Comma separated list of 1s and 0s - one for each NIC. "
> > > +		 "1 to share, 0 to not, default is 0");
> > > +module_param_array(buddy_intr, int, &num_adapters, 0400);
> > > +MODULE_PARM_DESC(buddy_intr, "Share one IRQ among corresponding tx
> and rx "
> > > +		 "queues. Comma separated list of 1s and 0s - one for each
> "
> > > +		 "NIC. 1 to share, 0 to not, default is 1");
> > > +module_param_array(num_tqs, int, &num_adapters, 0400);
> > > +MODULE_PARM_DESC(num_tqs, "Number of transmit queues in each
> adapter. Comma "
> > > +		 "separated list of integers. Setting this to 0 makes
> number"
> > > +		 " of queues same as number of CPUs. Default is 1.");
> > > +
> > > +#ifdef VMXNET3_RSS
> > > +module_param_array(rss_ind_table, int, &num_rss_entries, 0400);
> > > +MODULE_PARM_DESC(rss_ind_table, "RSS Indirection table. Number of
> entries "
> > > +		 "per NIC should be 32. Each integer in a comma separated
> list"
> > > +		 " is an rx queue number starting with 0. Repeat the same
> for"
> > > +		 " all NICs.");
> > > +module_param_array(num_rqs, int, &num_adapters, 0400);
> > > +MODULE_PARM_DESC(num_rqs, "Number of receive queues in each
> adapter. Comma "
> > > +		 " separated list of integers. Setting this to 0 makes
> number"
> > > +		 " of queues same as number of CPUs. Default is 1.");
> >
> > Module parameters are not right for this. They lead to different API
> > for interacting with each driver vendor. Is there a another better
> API?
> > Does it have to be this tweakable in a production environment.
> 
> The ethtool commands ETHTOOL_{G,S}RXFHINDIR cover the RSS indirection
> table.  These are new in 2.6.36 but already supported in the ethtool
> utility.

Thanks Ben,

Good to know. I will try and replace the module parameter for RSS indirection table with handlers for these ethtool commands.


> 
> As for numbers of queues and association of their completions with
> interrupts, we currently have nothing except ETHTOOL_GRXRINGS to get
> the
> number of RX queues.  I did post a tentative definition of an ethtool
> interface for this in
> <http://article.gmane.org/gmane.linux.network/172386> though it
> wouldn't
> provide quite as much control as these module parameters.  It is also
> significantly more difficult to support changing numbers of queues
> after
> an interface has been created, and I have not yet attempted to
> implement
> the 'set' command myself.


Okay. It would be best to keep module parameters to dictate number of queues till ethtool commands to do so become available/easy to use (command to change number of tx queues do not exist).

Regards.
Shreyas


> 
> Ben.
> 
> --
> Ben Hutchings, Senior Software Engineer, Solarflare Communications
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
