Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2GXGv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:51:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2GXGv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:51:27 -0400
Date: Tue, 24 Jul 2012 08:51:22 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: "Philip, Avinash" <avinashphilip@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH] PWM: Add support for configuring polarity of PWM
Message-ID: <20120724065121.GA30417@avionic-0098.mockup.avionic-design.de>
References: <1342616053-7793-1-git-send-email-avinashphilip@ti.com>
 <20120723083032.GA12868@avionic-0098.mockup.avionic-design.de>
 <500DB0CB.1000600@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <500DB0CB.1000600@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:N66sMm97VnaS5qSgXnLO2EJ9CENkP1JaFcBnVSpP4TE
 r3wsD03fMlXNssyulbUqWFyElkExZ6RfFRFSO5zu9nHw0Ckeys
 7oOQoIclWaOa6Av3P+Va1ecZXjWjasaUZ08K0/0FmzmTUkRXK9
 HGGcFpb9lNcvcpiES5ocQAgX2rB9fxegm9gYhNNPCdB2Z5hDRS
 C4Z1b/CcMktpbDglJaSmBYIa0n3ucXoWAVPxBzzOw04ZMYssw1
 31rK1kVFhjLL3oIirZfw5SBoUi953rWhtrxihmcghRp6Oh5MX0
 fwipLnnS8/r5rSgznfuF3Kr5o90Op3iaczSkjxe9DOnSQdmPQv
 eC9qLKA533mP5GopWwMFUMDgxnNu6DKEgueVDoFO0skoxfhcnP
 Gpcy5IUXdKxjbWWnZD9CrYbYbPV3o0uAe4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 23, 2012 at 10:15:07PM +0200, Lars-Peter Clausen wrote:
> On 07/23/2012 10:30 AM, Thierry Reding wrote:
> > On Wed, Jul 18, 2012 at 06:24:13PM +0530, Philip, Avinash wrote:
> >>[...]
> >> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> >> index 21d076c..2e4e960 100644
> >> --- a/include/linux/pwm.h
> >> +++ b/include/linux/pwm.h
> >> @@ -21,6 +21,16 @@ void pwm_free(struct pwm_device *pwm);
> >>   */
> >>  int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> >> =20
> >> +enum {
> >> +	PWM_POLARITY_NORMAL,	/* ON period depends on duty_ns */
> >> +	PWM_POLARITY_INVERSE,	/* OFF period depends on duty_ns */
> >> +};
> >=20
> > You should name this enumeration so that it can actually be used as a
> > type (enum pwm_polarity). Also you can drop the comments because they
> > only apply to the specific use-case of simulating duty-cycle inversion
>=20
> I think we should make it very explicit what normal polarity and inverse
> polarity is. There are certain applications where it is important. E.g. o=
ne
> such application would be using it in the IIO framework to generate a tri=
gger
> pulse to synchronize devices. If we do not specify how each of these modes
> should behave drivers may interpret and implement them differently.

I agree, the definition should be on a physical level.

> I'd vote for the following definitions:
> PWM_POLARITY_NORMAL: A high signal for the duration of duty_ns, followed =
by a
> low signal for the duration of (period_ns - duty_ns).
> PWM_POLARITY_INVERSE: A low signal for the duration duty_ns, followed by =
a high
> signal for the duration of (period_ns - duty_ns).

That's my understanding of normal vs. inversed as well. I haven't yet
seen a formal definition of the standard PWM waveform, but I believe
this describes the most common implementation.

> Maybe even rename them to PWM_POLARITY_ACTIVE_HIGH and PWM_POLARITY_ACTIV=
E_LOW
> since it is a bit more explicit on how the waveform should look like. "NO=
RMAL"
> and "INVERSE" sort of depend on what you consider to be normal.

But aren't active-high and -low equally arbitrary? They don't make it
obvious as to where the active period is, either. I think it'd be enough
if we use your definitions above as comments for the enumerations. After
all the important thing here is to have an unambiguous definition. And I
think for consistency we should call it PWM_POLARITY_INVERSED, that is
if we keep those two definitions.

How about the following?

/**
 * enum pwm_polarity - polarity of a PWM signal
 * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
 *   cycle, followed by a low signal for the remainder of the pulse
 *   period
 * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
 *   cycle, followed by a high signal for the remainder of the pulse
 *   period
 */
enum pwm_polarity {
	PWM_POLARITY_NORMAL,
	PWM_POLARITY_INVERSED,
};

Thierry

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQDkXoAAoJEN0jrNd/PrOh5o0P/jfqWppBdKhZFP9KaMMWw6Sn
ztoXXj4q7hKdo8urVrAERutZinn+BSYl8rkEAl58a5gNqqVdys6sr/FLuvg0c7sf
HGkdnKslm7RMXgmbeNW/HBPYVh6kKw9QjORxxD19kBittVq9GsUIgPUfFDxxkoV8
EjnQfppBv8yd9hX0G+4XKTR8YYVxL6w3JfQ6KEUNHionAES6YbBWtWBmQJdwl5kQ
YZCMi1Oj4muckrbsQtYQVIgNc86GKzWnZlYLi2fp3NkJmFp9C37FD3jn6Egh7wfE
bXHWdUt2ZFwYMsAy8kelap5PEqI2UoGrKsBzu9VHJWRhXEFy2KSY5HHsoOb1d+ZW
54/c0FYsJ54bD5wO8nQ44qAQ4VZgjY7j/d7qunpL/0cVrJbJsXQSLyJJs+7aDapG
CYnTpSDx6kDp5XGUmI9OEgsxesF92JzTc5DW5QTHjcZe6kepUGbjUCWU+MxAlRNl
y4AXKesfb5ued+Div4dGSvZMMOOdGFWMmW7NEcfg2nPqwqUD+J+A8CHjiiCY9FUj
SCaKKIQ0ncBpfCefUPVpbqkPL0RRmEoWWnbx2zK12xf8n3SULHmvtaeSuzoxwX8i
Q4MWyoOkqxyjlCmdDzYyKFrCoGCnDM4THEtBlZrYuMrcTyyW93G0v0nQsSXBm8EK
ehsq5/3EygA7HGSwgoE3
=tftr
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
