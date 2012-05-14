Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2ENFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:25:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50426 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751443Ab2ENFZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:25:57 -0400
Message-ID: <1336973155.2656.10.camel@joe2Laptop>
Subject: Re: [RFC 1/1] driver core: Add dev_*_ratelimited() family
From: Joe Perches <joe@perches.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Sun, 13 May 2012 22:25:55 -0700
In-Reply-To: <20120514.080008.1401340884821155549.hdoyu@nvidia.com>
References: <20120512.135227.1196366807162247040.hdoyu@nvidia.com>
	 <1336836695.17605.12.camel@joe2Laptop>
	 <20120514.080008.1401340884821155549.hdoyu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 07:00 +0200, Hiroshi Doyu wrote:
> Hi Joe,
> 
> Joe Perches <joe@perches.com> wrote @ Sat, 12 May 2012 17:31:35 +0200:
> 
> > On Sat, 2012-05-12 at 12:52 +0200, Hiroshi Doyu wrote:
> > > Hi,
> > > 
> > > An unclosed "if" statement in the MACRO seems a bit risky, but I don't
> > > have any better/simple solution for this, ATM. Is there any alternative?
> > 
> > maybe something like:
> > 
> > #define dev_ratelimited_level(dev, level, fmt, ...)
> > do {
> > 	static DEFINE_RATELIMIT_STATE(_rs,				\
> > 				      DEFAULT_RATELIMIT_INTERVAL,	\
> > 				      DEFAULT_RATELIMIT_BURST);		\
> > 	if (__ratelimit(&_rs))						\
> > 		dev_##level(fmt, ##__VA_ARGS__);			\
> > } while (0)
> > 
> > #define dev_emerg_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, emerg, fmt, ##__VA_ARGS__)
> > #define dev_alert_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, alert, fmt, ##__VA_ARGS__)
> > #define dev_crit_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, crit, fmt, ##__VA_ARGS__)
> > #define dev_err_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, err, fmt, ##__VA_ARGS__)
> > #define dev_warn_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, warn, fmt, ##__VA_ARGS__)
> > #define dev_notice_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, notice, fmt, ##__VA_ARGS__)
> > #define dev_info_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, info, fmt, ##__VA_ARGS__)
> > #define dev_dbg_ratelimited(dev, fmt, ...)				\
> > 	dev_ratelimited_level(dev, dbg, fmt, ##__VA_ARGS__)
> 
> "dev" isn't handled separately with __VA_ARGS__, and failed to build
> as below:
> 
>   Example:
>     dev_err_ratelimited(&pdev->dev, "%d\n", __LINE__);
>   
>   After preprocessded:
>     do { ... if (___ratelimit(&_rs, __func__)) dev_err("%d\n", 18); } while (0);
> 

Sorry, I was just typing in the email client and
I missed the "dev" argument.

Add "dev" to the dev_##level statement like:

#define dev_ratelimited_level(dev, level, fmt, ...)			\
do {									\
	static DEFINE_RATELIMIT_STATE(_rs,				\
				      DEFAULT_RATELIMIT_INTERVAL,	\
				      DEFAULT_RATELIMIT_BURST);		\
	if (__ratelimit(&_rs))						\
		dev_##level(dev, fmt, ##__VA_ARGS__);			\
} while (0)
 

