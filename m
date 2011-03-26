Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1CZNMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 09:12:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57053 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1CZNMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 09:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FoK92+nMQr7+wAT1Ae1cACFNxZp/jc7FEUo+oK2dACA+WwicLWUAOT7htmAwpJMWio
         C9DtgDd8VpkmP/EzAxf7M5eeFqKMfhap9LhWzk966sJqNH6AlEAsT5zNVrb2FIK5Y0zg
         lv0oxqk2+ZDzXCEh0D2Tc+Pf5SamLIYPLoydE=
Date: Sat, 26 Mar 2011 14:12:29 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V12 1/4] ptp: Added a brand new class driver for ptp
 clocks.
Message-ID: <20110326131229.GA23260@riccoc20.at.omicron.at>
References: <cover.1298878618.git.richard.cochran@omicron.at>
 <bf964489f4c6ee51bd8a2ab818cd6a5e2f544627.1298878618.git.richard.cochran@omicron.at>
 <1300915160.848.33.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300915160.848.33.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:19:20PM -0700, John Stultz wrote:
> On Mon, 2011-02-28 at 08:57 +0100, Richard Cochran wrote:
> > +++ b/drivers/ptp/ptp_clock.c
> > @@ -0,0 +1,320 @@
> [snip]
> > +static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
> > +				       struct ptp_clock_event *src)
> > +{
> > +	struct ptp_extts_event *dst;
> > +	unsigned long flags;
> > +	u32 remainder;
> > +
> > +	dst = &queue->buf[queue->tail];
> 
> Doesn't the lock need to happen before you access the
> queue->buf[queue->tail] ? 
> 
> For example: What happens if two cpus enter the function at the same
> time, both get the same tail index, one overwrite the other's data, then
> both take turns bumping up the tail pointer?

Yes, thanks for that catch.

> > +struct timestamp_event_queue {
> > +	struct ptp_extts_event buf[PTP_MAX_TIMESTAMPS];
> > +	int head;
> > +	int tail;
> > +	spinlock_t lock;
> > +};
> > +
> > +struct ptp_clock {
> > +	struct posix_clock clock;
> > +	struct device *dev;
> > +	struct ptp_clock_info *info;
> > +	dev_t devid;
> > +	int index; /* index into clocks.map */
> > +	struct pps_device *pps_source;
> > +	struct timestamp_event_queue tsevq; /* simple fifo for time stamps */
> > +	struct mutex tsevq_mux; /* one process at a time reading the fifo */
> > +	wait_queue_head_t tsev_wq;
> > +};
> > +
> > +static inline int queue_cnt(struct timestamp_event_queue *q)
> > +{
> > +	int cnt = q->tail - q->head;
> > +	return cnt < 0 ? PTP_MAX_TIMESTAMPS + cnt : cnt;
> > +}
> 
> q->tail and head access probably need to happen only when locked. 
> 
> So probably need a comment that queue_cnt must be called only when
> holding the proper lock.

In this case, calling without a lock is allowed. However, I'll add
comment like the following.

 * The function queue_cnt() is safe for readers to call without
 * holding q->lock. Readers use this function to verify that the queue
 * is nonempty before proceeding with a dequeue operation. The fact
 * that a writer might concurrently increment the tail does not
 * matter, since the queue remains nonempty nonetheless.

Thanks for your feedback,

Richard
