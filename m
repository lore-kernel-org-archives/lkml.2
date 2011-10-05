Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab1JECPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 22:15:15 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4897 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564Ab1JECPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 22:15:13 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Tue, 4 Oct 2011 19:14:23 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Xiao Jiang" <jgq516@gmail.com>
cc: "Joe Jin" <joe.jin@oracle.com>, "Matthew Carlson" <mcarlson@broadcom.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "Guru Anbalagane" <guru.anbalagane@oracle.com>,
        "Gurudas Pai" <gurudas.pai@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Marsden" <greg.marsden@oracle.com>
Subject: Re: [PATCH] tg3: Dont dump registers if interface not ready.
Message-ID: <20111005021423.GA2787@mcarlson.broadcom.com>
References: <4E83D3B3.7090508@oracle.com> <4E841519.6040201@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4E841519.6040201@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WSS-ID: 629560CC3JW1374158-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:50:01PM -0700, Xiao Jiang wrote:
> Joe Jin wrote:
> > When bootup the server with BCM5704 Gigabit Ethernet get below warning:
> >
> > tg3 0000:03:01.0: eth0: DMA Status error.  Resetting chip.
> > <Registers state of device>
> > tg3 0000:03:01.0: eth0: 0: Host status block [00000007:00000002:(0000:0000:0000):(0000:0000)]
> > tg3 0000:03:01.0: eth0: 0: NAPI info [00000001:00000002:(0000:0000:01ff):0000:(00c8:0000:0000:0000)]
> > tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
> > tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
> > tg3 0000:03:01.0: tg3_stop_block timed out, ofs=4800 enable_bit=2
> > tg3 0000:03:01.0: eth0: Link is down
> > tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
> > tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
> >
> > If device not ready, then would not dump registers info.
> >
> > Signed-off-by: Joe Jin <joe.jin@oracle.com>
> > Signed-off-by: Guru Anbalagane <guru.anbalagane@oracle.com>
> > Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
> > Cc: Matt Carlson <mcarlson@broadcom.com>
> > Cc: Michael Chan <mchan@broadcom.com>
> > ---
> >  drivers/net/tg3.c |   11 +++++++++--
> >   
> Maybe this one should based on net-next tree too, the tg3.c
> is lived below ./drivers/net/ethernet/broadcom/ in that tree.
> 
> Thanks,
> Xiao Jiang
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> > index 4a1374d..d79d344 100644
> > --- a/drivers/net/tg3.c
> > +++ b/drivers/net/tg3.c
> > @@ -5475,10 +5475,15 @@ static void tg3_process_error(struct tg3 *tp)
> >  {
> >  	u32 val;
> >  	bool real_error = false;
> > +	bool dump = true;
> >  
> >  	if (tg3_flag(tp, ERROR_PROCESSED))
> >  		return;
> >  
> > +	/* If interface not ready then dont dump error */
> > +	if (!netif_carrier_ok(tp->dev))
> > +		dump = false;

Would you still experience the problem if you did the following instead
of the above link check?

		if (tg3_flag(tp, INIT_COMPLETE))
			dump = false;

> >  	/* Check Flow Attention register */
> >  	val = tr32(HOSTCC_FLOW_ATTN);
> >  	if (val & ~HOSTCC_FLOW_ATTN_MBUF_LWM) {
> > @@ -5492,14 +5497,16 @@ static void tg3_process_error(struct tg3 *tp)
> >  	}
> >  
> >  	if (tr32(RDMAC_STATUS) || tr32(WDMAC_STATUS)) {
> > -		netdev_err(tp->dev, "DMA Status error.  Resetting chip.\n");
> > +		if (dump)
> > +			netdev_err(tp->dev, "DMA Status error.  Resetting chip.\n");
> >  		real_error = true;
> >  	}
> >  
> >  	if (!real_error)
> >  		return;
> >  
> > -	tg3_dump_state(tp);
> > +	if (dump)
> > +		tg3_dump_state(tp);
> >  
> >  	tg3_flag_set(tp, ERROR_PROCESSED);
> >  	schedule_work(&tp->reset_task);
> >   
> 
> 

