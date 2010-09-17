Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0IQPh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:37:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58284 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0IQPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:37:54 -0400
Date: Fri, 17 Sep 2010 16:36:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        linux-doc <linux-doc@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Madhusudhan Chikkature Rajashekar <madhu.cr@ti.com>,
        Sergio Alberto Aguirre Rodriguez <saaguirre@ti.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Eduardo Valentin <eduardo.valentin@nokia.com>,
        linux-omap <linux-omap@vger.kernel.org>, Thara Gopinath <thara@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Roberto Granados Dorado <x0095451@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Romit Dasgupta <ro.mit@ti.com>, Tero Kristo <Tero.Kristo@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjeev Premi <premi@ti.com>
Subject: Re: [linux-pm] [PATCH] opp: introduce library for device-specific
	OPPs
Message-ID: <20100917153643.GC29739@sirena.org.uk>
References: <1284686973-13993-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284686973-13993-1-git-send-email-nm@ti.com>
X-Cookie: Many suitcases look alike.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 08:29:33PM -0500, Nishanth Menon wrote:

> +struct opp_def {
> +	unsigned long freq;
> +	unsigned long u_volt;
> +
> +	bool enabled;
> +};

It might be clearer to use some term other than enabled in the code -
when reading I wasn't immediately sure if enabled meant that it was
available to be selected or if it was the active operating point.  How
about 'allowed' (though I'm not 100% happy with that)?

> +static inline int opp_add(struct device *dev, const struct opp_def *opp_def)
> +{
> +	return ERR_PTR(-EINVAL);
> +}

Mismatch with the return type and value here.

> +/**
> + * opp_enable() - Enable a specific OPP
> + * @opp:	Pointer to opp
> + *
> + * Enables a provided opp. If the operation is valid, this returns 0, else the
> + * corresponding error value.
> + *
> + * OPP used here is from the the opp_is_valid/opp_has_freq or other search
> + * functions
> + */
> +int opp_enable(struct opp *opp)
> +{
> +	if (unlikely(!opp || IS_ERR(opp))) {
> +		pr_err("%s: Invalid parameters being passed\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (!opp->enabled && opp->dev_opp)
> +		opp->dev_opp->enabled_opp_count++;
> +
> +	opp->enabled = true;
> +
> +	return 0;
> +}

When reading the description I'd expected to see some facility to
trigger selection of an active operating point in the library (possibly
as a separate call since you might have a bunch of operating points
being updated in quick succession) but it looks like that needs to be
supplied externally at the minute?
