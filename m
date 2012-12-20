Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2LTENp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 23:13:45 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60298 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2LTENi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 23:13:38 -0500
Message-ID: <1355976817.2968.12.camel@gitbox>
Subject: Re: Inconsistency in clk framework
From: Tony Prisk <linux@prisktech.co.nz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 20 Dec 2012 17:13:37 +1300
In-Reply-To: <20121219190824.GX14363@n2100.arm.linux.org.uk>
References: <1355890233.25599.4.camel@gitbox>
	 <20121219092636.GW14363@n2100.arm.linux.org.uk>
	 <1355938492.27893.8.camel@gitbox> <1355943649.2451.1.camel@gitbox>
	 <20121219190824.GX14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 19:08 +0000, Russell King - ARM Linux wrote:
> On Thu, Dec 20, 2012 at 08:00:49AM +1300, Tony Prisk wrote:
> > On Thu, 2012-12-20 at 06:34 +1300, Tony Prisk wrote:
> > > On Wed, 2012-12-19 at 09:26 +0000, Russell King - ARM Linux wrote:
> > > > On Wed, Dec 19, 2012 at 05:10:33PM +1300, Tony Prisk wrote:
> > > > > Hi Mike,
> > > > > 
> > > > > In attempting to remove some IS_ERR_OR_NULL references, it was pointed
> > > > > out that clk_get() can return NULL if CONFIG_HAVE_CLK is not defined.
> > > > 
> > > > That is correct - but why is that a problem?  As far as users are
> > > > concerned, NULL is a valid clock.  If HAVE_CLK is undefined, do you
> > > > want all your drivers to suddenly stop working?
> > > 
> > > That will be where the misunderstanding has occurred - I didn't consider
> > > NULL to be a valid clock.
> > > 
> > > Given that NULL is a valid clock, I guess all tests against get_clk and
> > > of_get_clk results should be IS_ERR_OR_NULL. Correct?
> > > 
> > For the sake of clarity, I should rephrase:
> > 
> > If the driver can't operate with a NULL clk, it should use a
> > IS_ERR_OR_NULL test to test for failure, rather than IS_ERR.
> 
> Why should a _consumer_ of a clock care?  It is _very_ important that
> people get this idea - to a consumer, the struct clk is just an opaque
> cookie.  The fact that it appears to be a pointer does _not_ mean that
> the driver can do any kind of dereferencing on that pointer - it should
> never do so.

As a simple example:
We have a PWM module that requires a clock source to be enabled before
registers can be read/written.

*pseudo code*
x = clk_get("pwm_clock")
if IS_ERR(x) then fail
err = clk_enable(x)
if (err != 0) then fail
start writing to module registers


Assuming HAVE_CLK is undefined:

x = clk_get("pwm_clock") (= NULL)
if IS_ERR(x) then fail (not an error)
err = clk_enable(x) (= 0)
if (err) then fail (not an error)
start writing to module registers
(register writes lock the bus because the clock wasn't really enabled,
but no errors occurred enabling the clock)


I apologise if it seems like I am not getting it, but I would like to
understand this properly to avoid further problems later.

Regards
Tony P

