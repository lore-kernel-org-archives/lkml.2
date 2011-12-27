Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1L0ORc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:17:32 -0500
Received: from d1.icnet.pl ([212.160.220.21]:44218 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab1L0OR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:17:28 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [PATCH 2/4] ASoC: cx20442: add bias control over a platform provided regulator
Date: Tue, 27 Dec 2011 15:16:08 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: alsa-devel@alsa-project.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl> <1324681944-19067-3-git-send-email-jkrzyszt@tis.icnet.pl> <20111226110201.GA8722@opensource.wolfsonmicro.com>
In-Reply-To: <20111226110201.GA8722@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112271516.09114.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 of December 2011 at 12:02:01, Mark Brown wrote:
> On Sat, Dec 24, 2011 at 12:12:22AM +0100, Janusz Krzysztofik wrote:
> 
> > +	case SND_SOC_BIAS_ON:
> > +	case SND_SOC_BIAS_PREPARE:
> > +		if (IS_ERR(cx20442->por.regulator)) {
> > +			err = PTR_ERR(cx20442->por.regulator);
> > +		} else if (!cx20442->por.enabled) {
> > +			err = regulator_enable(cx20442->por.regulator);
> > +			if (!err)
> > +				cx20442->por.enabled = true;
> > +		}
> > +		break;
> > +	case SND_SOC_BIAS_STANDBY:
> > +	case SND_SOC_BIAS_OFF:
> > +		if (IS_ERR(cx20442->por.regulator)) {
> > +			err = PTR_ERR(cx20442->por.regulator);
> > +		} else if (cx20442->por.enabled) {
> > +			err = regulator_disable(cx20442->por.regulator);
> > +			if (!err)
> > +				cx20442->por.enabled = false;
> > +		}
> > +	}
> > +	mutex_unlock(&cx20442->por.lock);
> 
> You can avoid the mutex and simplify the code by relying on the fact
> that the only possible transitions are:
> 
>    OFF <-> STANDBY <-> PREPARE <-> ON
> 
> which would look a lot more natural - you shouldn't need to remember if
> the regulator is enabled, you should just turn it on in the STANDBY to
> PREPARE transition and turn it off in the ON to PREPARE or PREPARE to
> STANDBY transitions.

Can I assume STANDBY or OFF at the time the codec .remove method is 
called? If not, is there a helper function available which can be called 
in order to perform all those ON -> PREPARE -> STANDBY [-> OFF] transitions before calling regulator_put()?

Thanks,
Janusz
