Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab2IGJJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:09:00 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41555 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2IGJI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:08:56 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Alex Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH v5 1/4] Runtime Interpreted Power Sequences
Date: Fri, 7 Sep 2012 11:08:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <201209061614.54022.heiko@sntech.de> <1887927.1deN8M9siP@percival>
In-Reply-To: <1887927.1deN8M9siP@percival>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071108.42083.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 7. September 2012, 10:04:24 schrieb Alex Courbot:
> > For your power_seq_run function you write that it simply returns an error
> > code on failure and looking through it I also just found the error return
> > statement. This would leave a device half turned on.
> > 
> > So I'm wondering, if it shouldn't turn off all the things it turned on
> > until the step that produced the error. All your possible step types
> > (execpt the delay) are booleans, so it should be possible to simply
> > negate them when backtracking through the previous steps.
> 
> Indeed, I think you raised an important point. Right now all step types are
> invertible, but we cannot rely on that statement to be true forever. For
> instance, one short-term improvement will be to allow finer regulator
> control, like voltage setting. In this case, how can we go back to the
> initial state without recording it?
>
> If e.g. the power on sequence fails at step N (of M steps for that
> sequence), one could try playing the corresponding power off sequence
> (either completely of from step M - N), but then again we cannot rely on
> sequences to be perfectly symetrical. Maybe this is more something for the
> calling driver to check for and control?

Am Freitag, 7. September 2012, 10:15:03 schrieb Mark Brown:
> On Fri, Sep 07, 2012 at 05:04:24PM +0900, Alex Courbot wrote:
> > If e.g. the power on sequence fails at step N (of M steps for that
> > sequence), one could try playing the corresponding power off sequence
> > (either completely of from step M - N), but then again we cannot rely on
> > sequences to be perfectly symetrical. Maybe this is more something for
> > the calling driver to check for and control?
> 
> That had been my thought too - depending on what the sequence is for it
> may be that the corrective action is something very different to
> reversing the sequence, for example a device reset may be required.


If I understood the description correctly, the power sequence should be 
transparent to the driver, as it implements board specific actions and 
shouldn't bother the driver with it to much. Therefore my thoughts went along 
the lines how gpio_request_array handles this, always producing a sane state 
at the end.

Recording the previous state, could be done by making a copy of the current 
sequence, and just noting the previous values (including voltages etc) in the 
respective entries. And in the error case running this new sequence from the 
error point instead to power down again.


As both Alex and Mark wrote, reversing the sequence might be the action of 
choice only for some devices, but others might need to run a completely 
different powerdown sequence and still others would need special handling.

Would it be possible to encode this in the sequence definition, something like
	on-error = "reverse"

	on-error = "sequence"
	error-seq = <&other_sequence>

	on-error = "driver"
with better names and types of course.

This would keep the power sequence transparent to most drivers and only the 
real esoteric ones would need to do their special handling on their own.


Heiko
