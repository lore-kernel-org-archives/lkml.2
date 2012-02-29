Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966231Ab2B2CUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:20:31 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:5630
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757562Ab2B2CUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:20:30 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371I179dN1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 29 Feb 2012 10:26:28 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/20] pinctrl: API changes to support multiple states
 per device
Message-ID: <20120229022627.GA3816@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-20-git-send-email-swarren@nvidia.com>
 <20120227090721.GB26061@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCFCD@HQMAIL01.nvidia.com>
 <20120228031851.GA1249@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BDDF1D55@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF1D55@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 09:04:10AM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Monday, February 27, 2012 8:19 PM:
> > On Mon, Feb 27, 2012 at 10:37:16AM -0800, Stephen Warren wrote:
> > > Dong Aisheng wrote at Monday, February 27, 2012 2:07 AM:
> > > > On Sun, Feb 19, 2012 at 11:45:59PM -0700, Stephen Warren wrote:
> > ..........
> > >
> > > > > +static struct pinctrl *pinctrl_get_locked(struct device *dev)
> > > > > +{
> > > > > +	struct pinctrl *p;
> > > > >
> > > > > -error:
> > > > > -	list_for_each_entry(setting, &p->settings, node)
> > > > > -		pinmux_free_setting(setting);
> > > > > +	if (WARN_ON(!dev))
> > > > > +		return ERR_PTR(-EINVAL);
> > > > >
> > > > > -	kfree(p);
> > > > > +	p = find_pinctrl(dev);
> > > > > +	if (p == NULL)
> > > > > +		p = create_pinctrl(dev);
> > > > > +	if (IS_ERR(p))
> > > > > +		return p;
> > > > > +
> > > > > +	p->usecount++;
> > > >
> > > > I still can not understand what's the purpose of p->usecount?
> > > > For allowing multi times calling of pinctrl_get for on the same device?
> > >
> > > pinctrl_get() could be called multiple times for the same device. Rather
> > > than create a whole new struct pinctrl each time it's called, we just
> > > reference count the object so that each call returns the same one, and
> > > it won't be destroyed until all users have called pinctrl_put().
> ...
> > I still can't find in which case the device will have such requirement
> > since per my understanding pinctrl is a little different from clock
> > (clock can be used by different devices but we do not allow pins to be
> > used by difference devices at the same time).
> 
> True. It's actually very easy to make pinctrl_get() fail if a struct
> pinctrl was already created for the device in question. If we do that,
> we can completely remove the usecount field. I'll update my patch to do
> that.
Great.

> 
> > > > > +static inline struct pinctrl * __must_check pinctrl_get_select(
> > > > > +					struct device *dev, const char *name)
> > > > > +{
> > > > > +	struct pinctrl *p;
> > > > > +	struct pinctrl_state *s;
> > > > > +	int ret;
> > > > > +
> > > > > +	p = pinctrl_get(dev);
> > > > > +	if (IS_ERR(p))
> > > > > +		return p;
> > > > > +
> > > > > +	s = pinctrl_lookup_state(p, name);
> > > > > +	if (IS_ERR(s)) {
> > > > > +		pinctrl_put(p);
> > > > > +		return ERR_PTR(PTR_ERR(s));
> > > > > +	}
> > > > > +
> > > > > +	ret = pinctrl_select_state(p, s);
> > > > > +	if (ret < 0) {
> > > > > +		pinctrl_put(p);
> > > > > +		return ERR_PTR(ret);
> > > >
> > > > s/ERR_PTR(ret)/ret ?
> > >
> > > The function returns a pointer, whereas ret is an int. ERR_PTR() is used
> > > to wrap the int error code into a pointer value so that the function can
> > > return either a valid pointer, or an error-code. See include/linux/err.h.
> >
> > Hmm, below is what i see in your patch:
> > +int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
> >  {
> > +       int ret;
> > +
> >         mutex_lock(&pinctrl_mutex);
> > -       pinctrl_disable_locked(p);
> > +       ret = pinctrl_select_state_locked(p, state);
> >         mutex_unlock(&pinctrl_mutex);
> > +
> > +       return ret;
> >  }
> >
> > It seems pinctrl_select_state does not return a pointer.
> 
> pinctrl_select()_state() returns an int error code.
> 
> pinctrl_get_select() returns a pointer, or an error code encoded into a
> pointer.
> 
> ERR_PTR(ret) is used to convert pinctrl_select()'s int error code into
> a pointer representation of the error code for pinctrl_get_select() to
> return.
> 
Oh, i see.
You're right, sorry for the noise.

Regards
Dong Aisheng

