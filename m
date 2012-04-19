Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2DSGTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:19:18 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57730 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2DSGTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120418150544.GE19802@pengutronix.de>
References: <1332741325-7746-1-git-send-email-tomoya.rohm@gmail.com>
	<1332741325-7746-2-git-send-email-tomoya.rohm@gmail.com>
	<20120418150544.GE19802@pengutronix.de>
Date: Thu, 19 Apr 2012 15:19:14 +0900
Message-ID: <CANKRQng5nb0nU_e1o6TLnvOwPoXX1C_bJguNyjrsVfo+mubKaw@mail.gmail.com>
Subject: Re: [PATCH 2/3] i2c-eg20t: Call init() when wait-event timeout occurs
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 12:05 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Mon, Mar 26, 2012 at 02:55:24PM +0900, Tomoya MORINAGA wrote:
>>
>> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
>
> Woha, that's copy&paste code all over. May I ask to refactor this?
> Something like:
>
>        rtn = pch_..._wait_for_checked_xfer();
>        if (rtn)
>                return rtn;
>        // All the things you have to do when rtn == 0
>
> in that new function (the name was only a suugestion), you can do all
> the checks which are now copy-pasted, e.g.:
>
>  458         rtn = pch_i2c_wait_for_xfer_complete(adap);
>  459         if (rtn == 0) {
>  460                 if (pch_i2c_getack(adap)) {
>  461                         pch_dbg(adap, "Receive NACK for slave address"
>  462                                 "setting\n");
>  463                         return -EIO;
>  464                 }
>  465         } else if (rtn == -EIO) { /* Arbitration Lost */
>  466                 pch_err(adap, "Lost Arbitration\n");
>  467                 pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMAL_BIT);
>  468                 pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
>  469                 pch_i2c_init(adap);
>  470                 return -EAGAIN;
>  471         } else { /* wait-event timeout */
>  472                 pch_i2c_stop(adap);
>                     // Your current fixes added here
>  473                 return -ETIME;
>  474         }
>             return 0;
>
> It is only pseudo-code, but I think it can be done and will help the driver.
>

OK.
I'm ready to submit new patch you are saying.

So, firstly, could you accept this patch ?
After your accept, new patch series can be applicable.

thanks.
-- 
ROHM Co., Ltd.
tomoya
