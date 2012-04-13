Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2DMQQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:16:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49045 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2DMQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:16:33 -0400
Message-ID: <4F88515A.2020805@linaro.org>
Date: Sat, 14 Apr 2012 00:16:26 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Anish Trivedi <anish@freescale.com>,
        Eric Miao <eric.miao@linaro.org>, Anson Huang <b20788@freescale.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] rtc: add support for Freescale SNVS RTC
References: <1332162269-16789-1-git-send-email-paul.liu@linaro.org> <20120322151156.GF2213@S2101-09.ap.freescale.net>
In-Reply-To: <20120322151156.GF2213@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年03月22日 23:11), Shawn Guo wrote:
> On Mon, Mar 19, 2012 at 09:04:29PM +0800, Ying-Chun Liu (PaulLiu) wrote:
>> +
>> +#define RTC_READ_TIME_47BIT	_IOR('p', 0x20, unsigned long long)
>> +/* blocks until LPSCMR is set, returns difference */
>> +#define RTC_WAIT_TIME_SET	_IOR('p', 0x21, int64_t)
>> +
> 
> What are these local ioctl number exactly for?  How can user space
> use these driver private numbers?
> 
>> +
>> +	rtc_write_sync_lp(ioaddr);
>> +
>> +	new_time_47bit = (((u64) (readl(ioaddr + SNVS_LPSRTCMR) &
>> +		((0x1 << CNTR_TO_SECS_SH) - 1)) << 32) |
>> +		((u64) readl(ioaddr + SNVS_LPSRTCLR)));
>> +
>> +	time_diff = new_time_47bit - old_time_47bit;
>> +
>> +	/* signal all waiting threads that time changed */
>> +	complete_all(&snvs_completion);
>> +
>> +	/* allow signalled threads to handle the time change notification */
>> +	schedule();
>> +
>> +	/* reinitialize completion variable */
>> +	INIT_COMPLETION(snvs_completion);
>> +
> 
> Are you sure all these sync need to get done in driver?
> 
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	spin_lock_irqsave(&rtc_lock, lock_flags);
>> +
>> +	ret = rtc_update_alarm(dev, &alrm->time);
>> +	if (ret)
>> +		goto out;
>> +
>> +	lp_cr = readl(ioaddr + SNVS_LPCR);
>> +
>> +	if (alrm->enabled)
>> +		lp_cr |= (SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
>> +	else
>> +		lp_cr &= ~(SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
>> +
>> +	if (lp_cr & SNVS_LPCR_ALL_INT_EN) {
>> +		if (!pdata->irq_enable) {
>> +			enable_irq(pdata->irq);
>> +			pdata->irq_enable = true;
>> +		}
>> +	} else {
>> +		if (pdata->irq_enable) {
>> +			disable_irq(pdata->irq);
>> +			pdata->irq_enable = false;
>> +		}
>> +	}
>> +
>> +	writel(lp_cr, ioaddr + SNVS_LPCR);
>> +
>> +out:
>> +	rtc_write_sync_lp(ioaddr);
>> +	spin_unlock_irqrestore(&rtc_lock, lock_flags);
>> +
>> +	return ret;
>> +}
>> +
>> +/*!
>> + * This function is used to provide the content for the /proc/driver/rtc
>> + * file.
>> + *
>> + * @param  seq  buffer to hold the information that the driver wants to write
>> + *
>> + * @return  The number of bytes written into the rtc file.
>> + */
>> +static int snvs_rtc_proc(struct device *dev, struct seq_file *seq)
>> +{
>> +	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
>> +	void __iomem *ioaddr = pdata->ioaddr;
>> +
>> +	seq_printf(seq, "alarm_IRQ\t: %s\n",
>> +		   (((readl(ioaddr + SNVS_LPCR)) & SNVS_LPCR_LPTA_EN) !=
>> +		    0) ? "yes" : "no");
>> +
>> +	return 0;
>> +}
>> +
>> +static int snvs_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
>> +{
>> +	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
>> +	void __iomem *ioaddr = pdata->ioaddr;
>> +	u32 lp_cr;
>> +	unsigned long lock_flags = 0;
>> +
>> +	spin_lock_irqsave(&rtc_lock, lock_flags);
>> +
>> +	if (enable) {
>> +		if (!pdata->irq_enable) {
>> +			enable_irq(pdata->irq);
>> +			pdata->irq_enable = true;
>> +		}
>> +		lp_cr = readl(ioaddr + SNVS_LPCR);
>> +		lp_cr |= (SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
>> +		writel(lp_cr, ioaddr + SNVS_LPCR);
>> +	} else {
>> +		lp_cr = readl(ioaddr + SNVS_LPCR);
>> +		lp_cr &= ~(SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
>> +		if (((lp_cr & SNVS_LPCR_ALL_INT_EN) == 0)
>> +		    && (pdata->irq_enable)) {
>> +			disable_irq(pdata->irq);
>> +			pdata->irq_enable = false;
>> +		}
>> +		writel(lp_cr, ioaddr + SNVS_LPCR);
>> +	}
>> +
>> +	rtc_write_sync_lp(ioaddr);
>> +	spin_unlock_irqrestore(&rtc_lock, lock_flags);
>> +
>> +	return 0;
>> +}
>> +
>> +/*!
>> + * This function is used to support some ioctl calls directly.
>> + * Other ioctl calls are supported indirectly through the
>> + * arm/common/rtctime.c file.
>> + *
>> + * @param  cmd          ioctl command as defined in include/linux/rtc.h
>> + * @param  arg          value for the ioctl command
>> + *
>> + * @return  0 if successful or negative value otherwise.
>> + */
>> +static int snvs_rtc_ioctl(struct device *dev, unsigned int cmd,
>> +			 unsigned long arg)
>> +{
>> +	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
>> +	void __iomem *ioaddr = pdata->ioaddr;
>> +	u64 time_47bit;
>> +	int retVal;
>> +
>> +	switch (cmd) {
>> +	case RTC_READ_TIME_47BIT:
>> +		time_47bit = (((u64) (readl(ioaddr + SNVS_LPSRTCMR) &
>> +			((0x1 << CNTR_TO_SECS_SH) - 1)) << 32) |
>> +			((u64) readl(ioaddr + SNVS_LPSRTCLR)));
>> +
>> +		if (arg && copy_to_user((u64 *) arg, &time_47bit, sizeof(u64)))
>> +			return -EFAULT;
>> +
>> +		return 0;
>> +
>> +	/* This IOCTL to be used by processes to be notified of time changes */
>> +	case RTC_WAIT_TIME_SET:
>> +		/* don't block without releasing mutex first */
>> +		mutex_unlock(&pdata->rtc->ops_lock);
>> +
>> +		/* sleep till awakened by SRTC driver when LPSCMR is changed */
>> +		wait_for_completion(&snvs_completion);
>> +
>> +		/* relock mutex because rtc_dev_ioctl will unlock again */
>> +		retVal = mutex_lock_interruptible(&pdata->rtc->ops_lock);
>> +
>> +		/* copy the new time difference = new time - previous time
>> +		 * to the user param. The difference is a signed value */
>> +		if (arg && copy_to_user((int64_t *) arg, &time_diff,
>> +			sizeof(int64_t)))
>> +			return -EFAULT;
>> +
>> +		return retVal;
>> +
>> +	}
>> +
>> +	return -ENOIOCTLCMD;
>> +}
> 
> I haven't completely understood this, and will need more study.
> 

Hi Shawn,

About the above ioctl() related blocks. I think it is used by some user
space libs that requires accurate time (47BIT TIME). And it have to be
sure that the time continuously flowing so the apps wants to be notified
that the rtc is changed dramatically by the set command.

I'm guessing that it might be related to the Multimedia binary libs. A/V
sync or something like that. But I don't have those source code. Please
make sure those libs are not using it.

I also see other Freescale RTC driver implement the same function. For
example:
http://tinyurl.com/cnp93jv
So I guess it might be a common ioctl that Freescale uses somewhere.

So my plan is to split the IOR to a header file. And keep the rest as is.

Yours Sincerely,
Paul
