Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0EFA6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 20:58:18 -0400
Received: from mail.perches.com ([173.55.12.10]:1931 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0EFA6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 20:58:16 -0400
Subject: Re: [PATCH 1/1] staging: hv: Add Time Sync feature to hv_utils
 module
From: Joe Perches <joe@perches.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       Hank Janssen <hjanssen@microsoft.com>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF72662A6D3B@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF72662A6D3B@TK5EX14MBXC130.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 17:58:14 -0700
Message-ID: <1273107494.1735.87.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 19:23 +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Subject: Add Time Sync feature to hv_utils module.
> The Time Sync feature synchronizes guest time to host UTC time after reboot,
> and restore from saved/paused state.
> +static void adj_guesttime(winfiletime_t hosttime, u8 flags)
> +{
> +	s64 host_tns;
> +	struct timespec host_ts;
> +	static s32 scnt = 50;

Why a maximum of 50 samples?

> +	host_tns = (hosttime - WLTIMEDELTA) * 100;
> +	host_ts = ns_to_timespec(host_tns);
> +
> +	if ((flags & ICTIMESYNCFLAG_SYNC) != 0) {
> +		do_settimeofday(&host_ts);
> +		return;
> +	}
> +
> +	if ((flags & ICTIMESYNCFLAG_SAMPLE) != 0 &&
> +	    scnt > 0) {
> +		scnt--;
> +		do_settimeofday(&host_ts);
> +	}

It might be better to do something like this
so the ns_to_timespec isn't performe when unnecessary.

static void settimeofday(winfiletime_t hosttime)
{
	s64 host_tns = (hosttime - WLTIMEDELTA) * 100;
	struct timespec host_ts = ns_to_timespec(host_tns);
	do_settimeofday(&host_ts);
}

static void adj_guesttime(winfiletime_t hosttime, u8 flags)
{
	static s32 scnt = 50;

	if ((flags & ICTIMESYNCFLAG_SYNC) != 0) {
		settimeofday(hosttime);
		return;
	}

	if ((flags & ICTIMESYNCFLAG_SAMPLE) != 0 && scnt > 0) {
		scnt--;
		settimeofday(hosttime);
	}
}



