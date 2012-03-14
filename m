Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591Ab2CNWN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:13:58 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:39737 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761522Ab2CNWNy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:13:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203142218320.2466@ionos>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120313112447.GA29317@pengutronix.de>
 <CAJOA=zMTY+4dU9VUa-TkEbdE-WJd7V4tCG-af6vgq0CPN6rWpg@mail.gmail.com>
 <20120314084857.GL3852@pengutronix.de> <CAJOA=zMsCuZgmp1Hm0dq=EVoX6Zj62XQVqR=6GzDntSD5HnHzg@mail.gmail.com>
 <alpine.LFD.2.02.1203142218320.2466@ionos>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 14 Mar 2012 15:13:28 -0700
Message-ID: <CAJOA=zNj8eC+h-S9KqwuAEiGFZMAn2h0TNTR6nund4qM7Z97ug@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 2:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 14 Mar 2012, Turquette, Mike wrote:
>
> Could you folks please trim your replies? It's annoying to page down a
> gazillion of lines to find the gist.

Sure.  My mailer does this for me so I forget to do it sometimes...

>> On Wed, Mar 14, 2012 at 1:48 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> >> Also, do you forsee needing hole in parent_names for any reason other
>> >> than described above?
>> >
>> > I need it only for the case where a some values in the mux are marked as
>> > reserved in the datasheet or we simply do not have the corresponding
>> > clock in our tree (yet). We could also say that NULL pointers are not
>> > allowed in parent arrays, but instead "orphan" or "dummy" should be
>> > used. Then __clk_init should check for NULL pointers to make this clear.
>>
>> I've added a WARN in __clk_init if any entries in .parent_names are
>> NULL.  I think it best to populate it with "dummy", or maybe a
>> platform-specific name if it helps you during development.
>
> There is no guarantee that the selection of a parent can be mapped
> linear to register values.

Agreed.  I have always viewed .parent_names as only a list of the
names of all possible parents, nothing more.  And of course its array
indexing should line up with struct clk **parents.

> So the right way to deal with it is to have an array of valid names
> with no holes and NULL pointers allowed and have a mapping from the
> array index to the register value.

This is essentially what the .set_rate callback does.  It takes as
input "u8 index" and peforms the hardware specific magic to select the
correct parent clock.  This might be a register write using that exact
same index, or it might be a single-bit register write using that
index as the shift value, or it might translate that index into the
data sent to an i2c device (where the address would be stored in
struct clk_foo), etc etc.

We both agree that .parent_names must contain valid names and should
not have holes.  What I don't understand is if you are saying that we
should allow NULL ptrs as names; that seems contradictory but I want
to make sure I'm reading you correctly.

Thanks,
Mike

> That makes the core code robust and allows to handle all corner cases
> including reserved bits, not implemented clocks and weird register
> layouts.
>
> Thanks,
>
>        tglx
