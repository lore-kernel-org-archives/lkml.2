Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0KXQu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:50:58 -0500
Received: from www.tglx.de ([62.245.132.106]:53576 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab0KXQu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:50:57 -0500
Date: Wed, 24 Nov 2010 17:49:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
cc: linux-kernel@vger.kernel.org, "Nikita V\\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        John Stultz <johnstul@us.ibm.com>, David Howells <dhowells@redhat.com>,
        "H\\. Peter Anvin" <hpa@zytor.com>, Magnus Damm <damm@opensource.se>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 14/17] pps: capture MONOTONIC_RAW timestamps as well
In-Reply-To: <5192d173ed6e6d392a76790b771be94f548d8ac8.1290599845.git.lasaine@lvk.cs.msu.su>
Message-ID: <alpine.LFD.2.00.1011241746500.2900@localhost6.localdomain6>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su> <5192d173ed6e6d392a76790b771be94f548d8ac8.1290599845.git.lasaine@lvk.cs.msu.su>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Alexander Gordeev wrote:
>  /**
> + * getnstime_raw_and_real - Returns both the time of day an raw
> + * monotonic time in a timespec format

IIRC then kerneldoc does not handle multiline comments for the
function name

> + * @ts_mono_raw:	pointer to the timespec to be set to raw
> + *			monotonic time
> + * @ts_real:		pointer to the timespec to be set to the time
> + *			of day
> + */
> +void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
> +{
> +	unsigned long seq;
> +	s64 nsecs_raw, nsecs_real;
> +
> +	WARN_ON_ONCE(timekeeping_suspended);

  Shouldn't this just return an error code instead of reading some
  stale or random value ?

> +	do {
> +		u32 arch_offset;
> +
> +		seq = read_seqbegin(&xtime_lock);
> +
> +		*ts_raw = raw_time;
> +		*ts_real = xtime;
> +
> +		nsecs_raw = timekeeping_get_ns_raw();
> +		nsecs_real = timekeeping_get_ns();
> +
> +		/* If arch requires, add in gettimeoffset() */
> +		arch_offset = arch_gettimeoffset();
> +		nsecs_raw += arch_offset;
> +		nsecs_real += arch_offset;
> +
> +	} while (read_seqretry(&xtime_lock, seq));
> +
> +	timespec_add_ns(ts_raw, nsecs_raw);
> +	timespec_add_ns(ts_real, nsecs_real);
> +}
> +EXPORT_SYMBOL(getnstime_raw_and_real);

Otherwise, I'm fine with that.

Thanks,

	tglx
