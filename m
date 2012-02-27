Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2B0Shj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:37:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5884 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2B0Shh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:37:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 Feb 2012 10:37:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Feb 2012 10:37:16 -0800
Subject: RE: [PATCH 19/20] pinctrl: API changes to support multiple states
 per device
Thread-Topic: [PATCH 19/20] pinctrl: API changes to support multiple states
 per device
Thread-Index: Acz1LlEhXFG8QbqyRQavxx96YPoV+gATtW8w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCFCD@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-20-git-send-email-swarren@nvidia.com>
 <20120227090721.GB26061@shlinux2.ap.freescale.net>
In-Reply-To: <20120227090721.GB26061@shlinux2.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Monday, February 27, 2012 2:07 AM:
> On Sun, Feb 19, 2012 at 11:45:59PM -0700, Stephen Warren wrote:

> > -	.name = "POWERMAP"
> > +	.dev_name = "pinctrl-foo",
> > +	.name = "active",
>
> I guess if we really decide to use a fixed state name for hog functions,
> we'd better not let users to write the state name, at least provide a macro.

Yes, that's a good point for adding the special-case macros. I have
added such special-case macros to my local version of patch 20, so they'll
be there in the repost.

> > +static struct pinctrl *pinctrl_get_locked(struct device *dev)
> > +{
> > +	struct pinctrl *p;
> >
> > -error:
> > -	list_for_each_entry(setting, &p->settings, node)
> > -		pinmux_free_setting(setting);
> > +	if (WARN_ON(!dev))
> > +		return ERR_PTR(-EINVAL);
> >
> > -	kfree(p);
> > +	p = find_pinctrl(dev);
> > +	if (p == NULL)
> > +		p = create_pinctrl(dev);
> > +	if (IS_ERR(p))
> > +		return p;
> > +
> > +	p->usecount++;
>
> I still can not understand what's the purpose of p->usecount?
> For allowing multi times calling of pinctrl_get for on the same device?

pinctrl_get() could be called multiple times for the same device. Rather
than create a whole new struct pinctrl each time it's called, we just
reference count the object so that each call returns the same one, and
it won't be destroyed until all users have called pinctrl_put().

Hopefully it is true that multiple different pieces of code won't be
screwing with the same device's pinctrl settings, but it's simple enough
to do this so we may as well. This somewhat of a the moral equivalent of
the old code's p->usecount manipulations in pinctrl_enable()/disable(),
although admittedly a little different.

> > +static inline struct pinctrl * __must_check pinctrl_get_select(
> > +					struct device *dev, const char *name)
> > +{
> > +	struct pinctrl *p;
> > +	struct pinctrl_state *s;
> > +	int ret;
> > +
> > +	p = pinctrl_get(dev);
> > +	if (IS_ERR(p))
> > +		return p;
> > +
> > +	s = pinctrl_lookup_state(p, name);
> > +	if (IS_ERR(s)) {
> > +		pinctrl_put(p);
> > +		return ERR_PTR(PTR_ERR(s));
> > +	}
> > +
> > +	ret = pinctrl_select_state(p, s);
> > +	if (ret < 0) {
> > +		pinctrl_put(p);
> > +		return ERR_PTR(ret);
>
> s/ERR_PTR(ret)/ret ?

The function returns a pointer, whereas ret is an int. ERR_PTR() is used
to wrap the int error code into a pointer value so that the function can
return either a valid pointer, or an error-code. See include/linux/err.h.

I've fixed locally up the other issues you pointed out. Thanks.

-- 
nvpublic

