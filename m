Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0LOVFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:05:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab0LOVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:04:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
Subject: Re: [PATCH] msm: rmnet: msm rmnet smd virtual ethernet driver
Date: Wed, 15 Dec 2010 22:04:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Brian Swetland <swetland@google.com>
References: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
In-Reply-To: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012152204.42002.arnd@arndb.de>
X-Provags-ID: V02:K0:KPWTYugZKB+Uy7WTRR+UDQwXYlsW4zM72/2xXfqsLEi
 c03wka+JxIOz7hkBuyMUo1aWxW4v/nkNknKgRFc5cyzCu+o6/w
 6fl/HPt+i6c9QOEHmf6rlmG1IM2NEYpH+cWFtQvLR0tpF/Htec
 ara5YnH/W4uRZ+C8zXP4ilgiF+oRG+SMtr7ZwoZ+BuFJTsftuY
 XiSaLOSuwh/yaYCo5JkUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010 19:31:06 Niranjana Vishwanathapura wrote:
> +struct rmnet_private {
> +       smd_channel_t *ch;
> +       struct net_device_stats stats;
> +       const char *chname;
> +#ifdef CONFIG_MSM_RMNET_DEBUG
> +       ktime_t last_packet;
> +       short active_countdown; /* Number of times left to check */
> +       short restart_count; /* Number of polls seems so far */
> +       unsigned long wakeups_xmit;
> +       unsigned long wakeups_rcv;
> +       unsigned long timeout_us;
> +       unsigned long awake_time_ms;
> +       struct delayed_work work;
> +#endif
> +};

It feels like a significant portion of the code and the complexity
(of which there fortunately is very little otherwise) is in the
debugging code. How important is that debugging code still?

In my experience, once a driver gets stable enough for inclusion,
most of the debugging code that you have put in there to write
the driver becomes obsolete, because the next bug is not going
to be found with it anyway.

How about deleting the debug code now? You still have the code and
if something goes wrong, you can always put it back to analyse
the problem.

> +/* Called in soft-irq context */
> +static void smd_net_data_handler(unsigned long arg)
> +{
> ...
> +}
> +
> +static DECLARE_TASKLET(smd_net_data_tasklet, smd_net_data_handler, 0);
> +
> +static void smd_net_notify(void *_dev, unsigned event)
> +{
> +       if (event != SMD_EVENT_DATA)
> +               return;
> +
> +       smd_net_data_tasklet.data = (unsigned long) _dev;
> +
> +       tasklet_schedule(&smd_net_data_tasklet);
> +}

It appears strange to do all the receive work in a tasklet. The
common networking code already has infrastructure for deferring
the rx to softirq time, and using the NAPI poll() logic likely gives
you better performance as well.

Aside from these, the driver looks very nice and clean to me.

	Arnd
