Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab1CDT6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:58:15 -0500
Received: from imr4.ericy.com ([198.24.6.8]:56275 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759778Ab1CDT6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:58:13 -0500
Subject: Re: [PATCH v5 00/11] hwmon: (w83627ehf) Add support for NCT6775F
 and NCT6776F
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Andrew Lutomirski <luto@mit.edu>
CC: Jean Delvare <khali@linux-fr.org>, Ian Dobson <i.dobson@planet-ian.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "binximeng@gmail.com" <binximeng@gmail.com>,
        "lmsensors@tapanitarvainen.fi" <lmsensors@tapanitarvainen.fi>,
        "andrea.rizzolo@gmail.com" <andrea.rizzolo@gmail.com>,
        "jeff.sadowski@gmail.com" <jeff.sadowski@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=yYOMA-eHnjzQDsLoH6RFtrG6b71HcjUMwjxNV@mail.gmail.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
	 <AANLkTinNrOG69Kzy=ZfRjurOedsz2Oazt-FT-m3Ro6Gg@mail.gmail.com>
	 <AANLkTi=yYOMA-eHnjzQDsLoH6RFtrG6b71HcjUMwjxNV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 4 Mar 2011 11:56:51 -0800
Message-ID: <1299268611.18605.68.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 13:53 -0500, Andrew Lutomirski wrote:
> On Fri, Mar 4, 2011 at 1:50 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> > On Fri, Mar 4, 2011 at 12:57 PM, Guenter Roeck
> > <guenter.roeck@ericsson.com> wrote:
> >> The following patch series adds support for NCT6775F and NCT6776F to the
> >> w83627ehf driver. It also includes some cleanup and adds support for
> >> the fourth temperature sensor on W83677HG-B.
> >>
> >> No code changes since v4. Resubmitting and widening audience in the hope that
> >> someone may find the time to review the changes prior to the next commit window.
> >
> > I'm not sure my review is worth much, but the driver seems to work.  I've tested
> > fan speed measurement, changing pwm2_enable to 1, changing the fan speed,
> > and changing back to 5.  Everything looks good.
> >
> > The only weird thing I noticed is that, the first time I ran sensors, I got:
> > fan2:                    0 RPM  (min =    0 RPM, div = 64)
> > and thereafter I get
> > fan2:                  136 RPM  (min =    0 RPM, div = 64)  ALARM
> >
> > I suspect (although I haven't checked) that sensors is just reading
> > div after it's already changed to 64.
> 
> I'll add one more weird thing on my NCT6775F.
> 
> [root@midnight w83627ehf.656]# echo 3200 >fan2_min
> [root@midnight w83627ehf.656]# cat fan2_div
> 8
> [root@midnight w83627ehf.656]# cat fan2_input
> 133
> [root@midnight w83627ehf.656]# cat fan2_div
> 16
> [root@midnight w83627ehf.656]# cat fan2_input
> 133
> [root@midnight w83627ehf.656]# cat fan2_div
> 32
> [root@midnight w83627ehf.656]# cat fan2_input
> 133
> [root@midnight w83627ehf.656]# cat fan2_div
> 64
> [root@midnight w83627ehf.656]# cat fan2_input
> 132
> [root@midnight w83627ehf.656]# cat fan2_div
> 64

This is actually as expected. rpm calculation is
	rpm = 1350000 / (rpm_reg * div)
In your case, this translates to
	rpm_reg * div ~ 8500
so for div < 64, the value of rpm_reg is larger than 255. If this
happens, the driver automatically increases fan_div until rpm_reg is
smaller than 255.

Reason for this is that while the chip has a 16 bit rpm register, the
min speed register is still only 8 bit wide. Plus, at least some
versions of NCT6775F report an rpm of 0 if the divisor is set too low.

Thanks,
Guenter


