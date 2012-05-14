Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2ENGFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:05:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36828 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751819Ab2ENGFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:05:41 -0400
Message-ID: <1336975539.2656.21.camel@joe2Laptop>
Subject: Re: [RFC 1/1] driver core: Add dev_*_ratelimited() family
From: Joe Perches <joe@perches.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Sun, 13 May 2012 23:05:39 -0700
In-Reply-To: <20120514.084014.1683295633804914511.hdoyu@nvidia.com>
References: <1336836695.17605.12.camel@joe2Laptop>
	 <20120514.080008.1401340884821155549.hdoyu@nvidia.com>
	 <1336973155.2656.10.camel@joe2Laptop>
	 <20120514.084014.1683295633804914511.hdoyu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 07:40 +0200, Hiroshi Doyu wrote:
> Joe Perches <joe@perches.com> wrote @ Mon, 14 May 2012 07:25:55 +0200:
> > On Mon, 2012-05-14 at 07:00 +0200, Hiroshi Doyu wrote:
> > > Joe Perches <joe@perches.com> wrote @ Sat, 12 May 2012 17:31:35 +0200:
> > > > On Sat, 2012-05-12 at 12:52 +0200, Hiroshi Doyu wrote:
> > > > > An unclosed "if" statement in the MACRO seems a bit risky, but I don't
> > > > > have any better/simple solution for this, ATM. Is there any alternative?
> > > > 
> > > > maybe something like:
> > > > 
> > > > #define dev_ratelimited_level(dev, level, fmt, ...)
> > > > do {
> > > > 	static DEFINE_RATELIMIT_STATE(_rs,				\
> > > > 				      DEFAULT_RATELIMIT_INTERVAL,	\
> > > > 				      DEFAULT_RATELIMIT_BURST);		\
> > > > 	if (__ratelimit(&_rs))						\
> > > > 		dev_##level(fmt, ##__VA_ARGS__);			\
> > > > } while (0)
> > > > 
> > > > #define dev_emerg_ratelimited(dev, fmt, ...)				\
> > > > 	dev_ratelimited_level(dev, emerg, fmt, ##__VA_ARGS__)
[...]
> > > > #define dev_dbg_ratelimited(dev, fmt, ...)				\
> > > > 	dev_ratelimited_level(dev, dbg, fmt, ##__VA_ARGS__)
> > > 
> > > "dev" isn't handled separately with __VA_ARGS__, and failed to build
> > > as below:
> > > 
> > >   Example:
> > >     dev_err_ratelimited(&pdev->dev, "%d\n", __LINE__);
> > >   
> > >   After preprocessded:
> > >     do { ... if (___ratelimit(&_rs, __func__)) dev_err("%d\n", 18); } while (0);
> > > 
> > 
> > Sorry, I was just typing in the email client and
> > I missed the "dev" argument.
> > 
> > Add "dev" to the dev_##level statement like:
> > 
> > #define dev_ratelimited_level(dev, level, fmt, ...)			\
> > do {									\
> > 	static DEFINE_RATELIMIT_STATE(_rs,				\
> > 				      DEFAULT_RATELIMIT_INTERVAL,	\
> > 				      DEFAULT_RATELIMIT_BURST);		\
> > 	if (__ratelimit(&_rs))						\
> > 		dev_##level(dev, fmt, ##__VA_ARGS__);			\
> > } while (0)
> 
> Verified that the above works. Would you mind sending the complete version of this patch?

Hello Hiroshi.

It's your patch and your idea.
I think you should submit it.
You were just asking for alternatives or a bit
of guidance.

Maybe a better name for dev_ratelimited_level is
dev_level_ratelimited and the macro should be

#define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
do {									\
	static DEFINE_RATELIMIT_STATE(_rs,				\
				      DEFAULT_RATELIMIT_INTERVAL,	\
				      DEFAULT_RATELIMIT_BURST);		\
	if (__ratelimit(&_rs))						\
		dev_level(dev, fmt, ##__VA_ARGS__);			\
} while (0)

with uses like

#define dev_notice_ratelimited(dev, fmt, ...)				\
	dev_level_ratelimited(dev_notice, fmt, ##__VA_ARGS__)


Your choice though I think the last option above
may be better because it more closely follows the
style a dev_printk_ratelimited would use.

cheers, Joe

