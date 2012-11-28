Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2K1Lwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:52:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52777 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab2K1Lw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:52:29 -0500
From: "Navada Kanyana, Mukund" <navada@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Thread-Topic: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Thread-Index: AQHNzUn3sp+aSR+ZB0iEZwLUiY4GmZf+nu6AgAB/Pg2AAAF0AA==
Date: Wed, 28 Nov 2012 11:52:22 +0000
Message-ID: <6817C817C9581447825BFB369EAC42163E959B6C@DBDE01.ent.ti.com>
References: <n> <1354094577-14967-1-git-send-email-navada@ti.com>
 <20121128092924.GJ32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959AED@DBDE01.ent.ti.com>
 <20121128113443.GM32691@opensource.wolfsonmicro.com>
In-Reply-To: <20121128113443.GM32691@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, November 28, 2012 5:05 PM
> To: Navada Kanyana, Mukund
> Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] regmap: Add support for continously numbered
> pages across regmap range
> 
> On Wed, Nov 28, 2012 at 10:11:05AM +0000, Navada Kanyana, Mukund wrote:
> 
> Fix your mailer to word wrap within paragraphs.
> 
> > > I'm sorry but I can't understand what this is supposed to do.  The
> > > current paging code expects pages to be numbered continuously with no
> > > gaps.  Can you please clarify?
> 
> > But the page number is expected to increase only till end of range.
> > But in devices like TLV320AIC3256, the page number increases beyond
> > range.
> 
> What does this mean?  How can we have a page beyond the end of the
> range?
> 
> > Pages 0 through Page 1 --> first register range for device
> > configuration. Page 8 through Page 16 --> second range for DSP1
> > coefficient memory Page 26 through Page 34 --> third range for DSP2
> > coefficient memory
> 
> > Window length of each page is 128. So if we need to correctly write
> > the page number in selector register for second range, start_page_num
> > would be 8. If we did not have start_page_num, it would write 0 to
> > selector register.
> 
> I'm sorry but I don't understand how that would happen?  What breaks
> accessing page 8?  This sounds like you're doing something wrong when
> you're trying ton use the paging.

I have my regmap_range_cfg as below

#define AIC325X_DSP_WINDOW_LEN  128
#define AIC325X_ADSP_CM_A_BASE  (9 * AIC325X_DSP_WINDOW_LEN)
static const struct regmap_range_cfg aic325x_ranges[] = {
        { .name = "CONF", .range_min = 128,
          .range_max = 383,
          .selector_reg = 0x0,
          .selector_mask = 0xff,
          .selector_shift = 0,
          .window_start = 0, .window_len =128,
        },
        { .name = "MINIDSP_A_CM_A", .range_min = AIC325X_ADSP_CM_A_BASE,
          .range_max = AIC325X_ADSP_CM_A_BASE + 1152,
          .selector_reg = 0x0,
          .selector_mask = 0xff,
          .selector_shift = 0,
          .window_start = 0, .window_len =128,
        },
};

In _regmap_select_page function that calculates win_page 

win_page = (*reg - range->range_min) / range->window_len;

So when my *reg is within MINIDSP_A_CM_A (that corresponds to Page 8), the above win_page calculation would be 0 instead of 8 for *reg value of AIC325X_ADSP_CM_A_BASE.
