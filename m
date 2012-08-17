Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2HQLck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:32:40 -0400
Received: from antcom.de ([188.40.178.216]:46743 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab2HQLcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:32:39 -0400
Message-ID: <502E2BD4.5090803@antcom.de>
Date: Fri, 17 Aug 2012 13:32:36 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: balbi@ti.com
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de> <20120817105103.GE4651@arwen.pp.htv.fi> <502E2498.4090106@linutronix.de> <20120817110256.GG4651@arwen.pp.htv.fi>
In-Reply-To: <20120817110256.GG4651@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 01:02 PM, Felipe Balbi wrote:
> On Fri, Aug 17, 2012 at 01:01:44PM +0200, Sebastian Andrzej Siewior wrote:
>> On 08/17/2012 12:51 PM, Felipe Balbi wrote:
>>>> Sounds reasonable?
>>>
>>> no it doesn't. Please remove that static global. Sorry but one of the
>>> goals with udc_start/udc_stop was really to get rid of all those
>>> nonsensical static globals.
>>
>> I wouldn't insist on it. If you look at pxa25x, " static struct
>> pxa25x_udc memory = {" they do the same thing. It is only a simple way
>> to onetime initialize variables.
> 
> fair enough. Though that's wrong too and should be changed. The whole
> idea of allowing multiple UDCs on the same kernel image is mostly to aid
> development. Specially on pre-silicon phase. We could have a bunch of
> PCIe FPGA boards and instantiate a different controller on each one and
> have the same kernel work with them all.

Yes, that's a good thing and I like to support it.

How about the following: Below, I show how the initialization of the
current controller is done (statically). Removing this struct
initialization completely would make the code much uglier, introducing
many individual assignments.

Would it be OK to kzalloc() on initialization to enable multiple UDCs
and then memcpy() from a statically prepared template as below? (Some
dynamic pointer adjustments necessary, of course.)

Thanks in advance,

Roland



static struct lpc32xx_udc controller = {
        .gadget = {
                .ops    = &lpc32xx_udc_ops,
                .ep0    = &controller.ep[0].ep,
                .name   = driver_name,
                .dev    = {
                        .init_name = "gadget",
                        .release = nop_release,
                }
        },
        .ep[0] = {
                .ep = {
                        .name   = "ep0",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 0,
                .hwep_num       = 0, /* Can be 0 or 1, has special
handling */
                .lep            = 0,
                .eptype         = EP_CTL_TYPE,
        },
        .ep[1] = {
                .ep = {
                        .name   = "ep1-int",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 2,
                .hwep_num       = 0, /* 2 or 3, will be set later */
                .lep            = 1,
                .eptype         = EP_INT_TYPE,
        },
        .ep[2] = {
                .ep = {
                        .name   = "ep2-bulk",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 4,
                .hwep_num       = 0, /* 4 or 5, will be set later */
                .lep            = 2,
                .eptype         = EP_BLK_TYPE,
        },
        .ep[3] = {
                .ep = {
                        .name   = "ep3-iso",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 1023,
                .hwep_num_base  = 6,
                .hwep_num       = 0, /* 6 or 7, will be set later */
                .lep            = 3,
                .eptype         = EP_ISO_TYPE,
        },
        .ep[4] = {
                .ep = {
                        .name   = "ep4-int",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 8,
                .hwep_num       = 0, /* 8 or 9, will be set later */
                .lep            = 4,
                .eptype         = EP_INT_TYPE,
        },
        .ep[5] = {
                .ep = {
                        .name   = "ep5-bulk",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 10,
                .hwep_num       = 0, /* 10 or 11, will be set later */
                .lep            = 5,
                .eptype         = EP_BLK_TYPE,
        },
        .ep[6] = {
                .ep = {
                        .name   = "ep6-iso",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 1023,
                .hwep_num_base  = 12,
                .hwep_num       = 0, /* 12 or 13, will be set later */
                .lep            = 6,
                .eptype         = EP_ISO_TYPE,
        },
        .ep[7] = {
                .ep = {
                        .name   = "ep7-int",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 14,
                .hwep_num       = 0,
                .lep            = 7,
                .eptype         = EP_INT_TYPE,
        },
        .ep[8] = {
                .ep = {
                        .name   = "ep8-bulk",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 16,
                .hwep_num       = 0,
                .lep            = 8,
                .eptype         = EP_BLK_TYPE,
        },
        .ep[9] = {
                .ep = {
                        .name   = "ep9-iso",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 1023,
                .hwep_num_base  = 18,
                .hwep_num       = 0,
                .lep            = 9,
                .eptype         = EP_ISO_TYPE,
        },
        .ep[10] = {
                .ep = {
                        .name   = "ep10-int",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 20,
                .hwep_num       = 0,
                .lep            = 10,
                .eptype         = EP_INT_TYPE,
        },
        .ep[11] = {
                .ep = {
                        .name   = "ep11-bulk",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 22,
                .hwep_num       = 0,
                .lep            = 11,
                .eptype         = EP_BLK_TYPE,
        },
        .ep[12] = {
                .ep = {
                        .name   = "ep12-iso",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 1023,
                .hwep_num_base  = 24,
                .hwep_num       = 0,
                .lep            = 12,
                .eptype         = EP_ISO_TYPE,
        },
        .ep[13] = {
                .ep = {
                        .name   = "ep13-int",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 26,
                .hwep_num       = 0,
                .lep            = 13,
                .eptype         = EP_INT_TYPE,
        },
        .ep[14] = {
                .ep = {
                        .name   = "ep14-bulk",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 64,
                .hwep_num_base  = 28,
                .hwep_num       = 0,
                .lep            = 14,
                .eptype         = EP_BLK_TYPE,
        },
        .ep[15] = {
                .ep = {
                        .name   = "ep15-bulk",
                        .ops    = &lpc32xx_ep_ops,
                },
                .udc            = &controller,
                .maxpacket      = 1023,
                .hwep_num_base  = 30,
                .hwep_num       = 0,
                .lep            = 15,
                .eptype         = EP_BLK_TYPE,
        },
};
