Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1LAGkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 01:40:02 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:39727 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1LAGkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 01:40:00 -0500
Date: Wed, 30 Nov 2011 23:39:59 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: "Turquette, Mike" <mturquette@ti.com>
cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
In-Reply-To: <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com> <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-487756526-1322721599=:6289"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-487756526-1322721599=:6289
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Mike

a few brief comments.

On Wed, 30 Nov 2011, Turquette, Mike wrote:

> Likewise when a clk is requested to transition to a new frequency it
> will have to clear it with all of the clks below it, so there is still
> a need to propagate a request throughout the clk tree whenever
> clk_set_rate is called and take a decision.
>=20
> One way to solve this is for driver owners to sprinkle their code with
> clk_block_rate_change and clk_allow_rate_change as you propose.
> There is a problem with this method if it is not supplemented with=20
> rate-change notifications that drivers are allowed to handle=20
> asynchronously. =20

I don't think notifiers have a bearing on clk_get_rate().

> In this case it would be nice to have asynchronous notifiers that can
> interrupt the MMC driver with a pre-change notifier and say "please
> finish your current transaction, stall your next transaction, and then
> return so I can change your clk rate".  Then after the clk rate change
> occurs a post-change notification would also go out to the MMC driver
> saying "ok I'm done changing rates.  here is your new clk rate and
> please continue working".  The notification is very polite.

I haven't made any comments about clock notifiers yet, because my=20
comments so far have only concerned clk_get_rate() and=20
clk_get_parent().

Clock rate/parent-change notifiers are requirements for DVFS use-cases,=20
and they must be paired with something like the=20
clk_{allow,block}_rate_change() functions to work efficiently.  I intend=20
to comment on this later; it's not a simple problem.  It might be worth=20
noting that Tero and I implemented a simplified version of this for the=20
N900.

> It is worth nothing that the MMC driver can return NOTIFY_STOP in it's
> pre-change notification handler and this effectively does the same
> thing as traversing the clk subtree and checking to make sure that
> nobody is holding clk_block_rate_change against any of the children
> clocks.
>=20
> The point of all of that text above is to say: if we have to walk the
> whole clk subtree below the point where we want to change rates AND we
> want to make a dynamic case-by-case call on whether to allow the rate
> change to happen (as opposed to contending with the allow/block
> semantics) then I think that only having notifications will suffice.

That would not be good.  A notifier implementation without something like=
=20
clk_{allow,block}_rate_change() is going to waste a lot of CPU time making=
=20
pointless calls into the notifier chains by whatever is attempting to do=20
top-down DVFS.

With clk_{allow,block}_rate_change(), only a single comparison is needed=20
to determine whether or not the rate change can succeed.  A=20
blocking clk_set_rate() variant could also be efficiently implemented with=
=20
that information, if so desired.

In general, a clock rate change notifier should almost never return=20
NOTIFY_STOP.  That should only happen if some event occurred that took=20
place after the notifier chain started.

> > 3. For the above changes to work, the clock framework will need to
> > discriminate between different clock users' calls to clock functions li=
ke
> > clk_{get,set}_rate(), etc. =A0Luckily this should be possible within th=
e
> > current clock interface. =A0clk_get() can allocate and return a new str=
uct
> > clk that clk_put() can later free. =A0One useful side effect of doing t=
his
> > is that the clock framework could catch unbalanced clk_{enable,disable}=
()
> > calls.
>=20
> This is definitely worth thinking about.  Another way to accomplish
> this is stop treating prepare_count and enable_count as scalars and
> instead vectorize them by tracking a list of struct device *'s.

To return to my original comments on clk_get_rate(): how would this allow=
=20
the clock framework to discriminate between callers of clk_get_rate()? =20
(Or indeed any clock framework function?)  Or is your comment simply=20
addressing the unbalanced clk_{enable,disable}() case?

> > 4. clk_get_rate() must return an error when it's called in situations
> > where the caller hasn't ensured that the clock's rate won't be changed =
by
> > other entities. =A0For non-fixed rate clocks, these forbidden sections =
would
> > include code between a clk_get() and a clk_enable(), or between a
> > clk_disable() and a clk_put() or clk_enable(), or between a
> > clk_allow_rate_changes() and clk_block_rate_changes(). =A0The first and
> > second of those three cases will require some code auditing of
> > clk_get_rate() users to ensure that they are only calling it after they=
've
> > enabled the clock. =A0And presumably most of them are not checking for
> > error. =A0include/linux/clk.h doesn't define an error return value, so =
this
> > needs to be explicitly defined in clk.h.
>=20
> This adds a lot of burden to a driver that just wants to know a rate.
> Especially if that purpose is for something as simple/transient as a
> pr_debug message or something.

Could you clarify what burden are you referring to?

The above protocol requires few (if any) changes to existing clock=20
framework users.  So for example, the following code:

c =3D clk_get(dev, clk_name);
clk_enable(c);
rate =3D clk_get_rate(c);

would still continue to work, since the rate would be guaranteed not to=20
change after the clk_enable().  However, the (unsafe):

c =3D clk_get(dev, clk_name);
rate =3D clk_get_rate(c);

would need to be modified to become safe, by adding a=20
clk_block_rate_change() before the clk_get_rate().


- Paul
--155748971-487756526-1322721599=:6289--
