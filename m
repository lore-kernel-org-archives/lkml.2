Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2GELqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 07:46:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40049 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2GELqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 07:46:53 -0400
Message-ID: <4FF57EA9.7060107@linaro.org>
Date: Thu, 05 Jul 2012 12:46:49 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org> <20120703123552.GC25995@sirena.org.uk> <4FF2EEA1.6080204@linaro.org> <20120703132447.GN29030@opensource.wolfsonmicro.com> <4FF2F82D.9080507@linaro.org> <20120703142123.GQ29030@opensource.wolfsonmicro.com> <4FF54406.3000307@linaro.org> <20120705094541.GK4111@opensource.wolfsonmicro.com>
In-Reply-To: <20120705094541.GK4111@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 10:45, Mark Brown wrote:
> On Thu, Jul 05, 2012 at 08:36:38AM +0100, Lee Jones wrote:
>> On 03/07/12 15:21, Mark Brown wrote:
> 
>>> This doesn't explain any of the issues, it just says that they exist.
>>> My best guess would be that at least some of the issue is due to
>>> instantiating the MFD cells from the device tree but it's hard to say
>>> clearly.
> 
>> I'm guessing Arnd's email answered some of the questions you had.
>> Let me know of you would like me to explain it in any greater
>> detail.
> 
> No, frankly.  It was just a general "why might we put things in DT"
> answer which (especially given what you say below) isn't related to the
> issue at all.

Okay, so currently we have something like this:

/ {
	soc-u9500 {
		#address-cells = <1>;
		#size-cells = <1>;
		ranges;

/* 
 * The nodes below which have addresses associated with 
 * them all have correctly formed reg properties: 
 *   i.e. "reg = <0xa0411000 0x1000>" 
 */
		intc: interrupt-controller@a0411000
		L2: l2-cache
		pmu
		timer@a0410600
		rtc@80154000
		gpio0: gpio@8012e000
		pinctrl
		usb@a03e0000
		dma-controller@801C0000

/* 
 * Then it becomes more interesting. We have the PRCMU
 * which has the same address space as above, but its
 * children have mixed address spaces. Some have their
 * own set of memory mapped registers, others are
 * communicated with by i2c. So:
 */

		prcmu@80157000 {
			reg = <0x80157000 0x1000>;
			#address-cells = <1>;
			#size-cells = <1>;
			ranges;

/* The timer has its own memory mapped address space. */

			prcmu-timer-4@80157450

/* Ignore the regulators, no one really cares about those ;) */

			db8500-prcmu-regulators

/* 
 * Then the ab8500 communicates with the PRCMU via a selection
 * of i2c mailboxes. So we did have this:
 *         mailbox {
 *                 #address-cells = <1>;
 *                 #size-cells = <0>;
 *
 *                 ab8500 { <blah> };
 *        }
 * But then Device Tree complains at you because of this:

drivers/of/address.c:
> #define OF_CHECK_COUNTS(na, ns) ((na) > 0 && (na) <= OF_MAX_ADDR_CELLS && (ns) > 0)
> 
> 	/* Cound address cells & copy address locally */
> 	bus->count_cells(dev, &na, &ns);
> 	if (!OF_CHECK_COUNTS(na, ns)) {
> 		printk(KERN_ERR "prom_parse: Bad cell count for %s\n",
> 		       dev->full_name);
> 		goto bail;
> 	}

 * Device Tree doesn't allow you to have zero size cells, 
 * which we would require if we were to register all of the
 * AB8500 devices separately during a DT boot.
 */


			ab8500@5 {
				reg = <5>; /* mailbox 5 is i2c */

				ab8500-rtc
				ab8500-gpadc
				ab8500-usb
				        reg = <1>;
				ab8500-ponkey
				ab8500-sysctrl
				ab8500-pwm
				ab8500-debugfs
				ab8500-regulators
			};
		};

		i2c@80004000
		ssp@80002000
		uart@80120000
		sdi@80126000
		external-bus@50000000
	};
};

Besides, the main role of Device Tree is to eradicate platform code.
Whereas the code in the MFD driver used to register the AB8500 devices
is not platform code.

Does that answer your question better?

>> By the way, this patch has nothing to do with registering these
>> devices when DT is enabled. The code already does that. This is a
>> bug fix, to stop multiple registration of the ab8500 when DT is
>> _not_ enabled.
> 
> Really?  It seems really surprising that adding more DT support to the
> MFD core would have any bearing on something like this...

I'm not really sure what you mean by this.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515 
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


