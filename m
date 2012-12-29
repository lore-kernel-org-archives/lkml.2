Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2L2Ads (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 19:33:48 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38221 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab2L2Adq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 19:33:46 -0500
Date: Sat, 29 Dec 2012 01:33:41 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, viresh kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix problem with cpufreq_pndemand or cpufreq_conservative
Message-ID: <20121229003341.GA30982@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	viresh kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
	Linux PM list <linux-pm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <50DE1A74.4040607@lwfinger.net>
 <3226192.H2BxHSuKio@vostro.rjw.lan>
 <50DE2F32.1010207@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50DE2F32.1010207@lwfinger.net>
X-Operating-System: Linux balto 3.8.0-rc1-00004-g637704c x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 05:45:54PM -0600, Larry Finger wrote:
> >I wonder if that's avoidable?  The intention is not to create an additional
> >module, clearly.
> 
> It appears not to be possible. I don't know enough about to kmake to
> understand why it is forcing a new module. Perhaps some expert knows
> what Kconfig or Makefile magic will prevent that.

kbuild is building an additional module just because the makefile is
adding the new objects in the obj-m list directly, as in:

obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)     += cpufreq_ondemand.o cpufreq_governor.o
obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE) += cpufreq_conservative.o cpufreq_governor.o

To build just two modules the Makefile would have to be modified [1]
into something into something like:

obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)     += cpufreq_ondemand_mod.o
cpufreq_ondemand_mod-y                  := cpufreq_ondemand.o cpufreq_governor.o
obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE) += cpufreq_conservative_mod.o
cpufreq_conservative_mod-y              := cpufreq_conservative.o cpufreq_governor.o

so that only two .o are added to obj-m, but that's not correct either as
you end up with cpufreq_governor symbols exported twice.

I think the only way would be to force cpufreq_governor as builtin with
an automatic Kconfig option.

Fabio

1. http://lxr.linux.no/#linux+v3.7.1/Documentation/kbuild/makefiles.txt#L191

-- 
Fabio Baltieri
