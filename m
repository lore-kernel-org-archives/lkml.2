Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2K2GNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:13:54 -0500
Received: from shutemov.name ([204.155.152.216]:37573 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2K2GNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:13:53 -0500
Date: Thu, 29 Nov 2012 08:14:13 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [RFC] Add mempressure cgroup
Message-ID: <20121129061412.GA26034@shutemov.name>
References: <20121128102908.GA15415@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128102908.GA15415@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 02:29:08AM -0800, Anton Vorontsov wrote:
> +static int mpc_pre_destroy(struct cgroup *cg)
> +{
> +	struct mpc_state *mpc = cg2mpc(cg);
> +	int ret = 0;
> +
> +	mutex_lock(&mpc->lock);
> +
> +	if (mpc->eventfd)
> +		ret = -EBUSY;

cgroup_rmdir() will unregister all events for you. No need to handle it
here.

> +
> +	mutex_unlock(&mpc->lock);
> +
> +	return ret;
> +}

> +static int mpc_register_level_event(struct cgroup *cg, struct cftype *cft,
> +				    struct eventfd_ctx *eventfd,
> +				    const char *args)
> +{
> +	struct mpc_state *mpc = cg2mpc(cg);
> +	int i;
> +	int ret;
> +
> +	mutex_lock(&mpc->lock);
> +
> +	/*
> +	 * It's easy to implement multiple thresholds, but so far we don't
> +	 * need it.
> +	 */
> +	if (mpc->eventfd) {
> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}

One user which listen for one threashold per cgroup?
I think it's wrong. It's essensial for API to serve multiple users.

> +
> +	ret = -EINVAL;
> +	for (i = 0; i < VMPRESSURE_NUM_LEVELS; i++) {
> +		if (strcmp(vmpressure_str_levels[i], args))
> +			continue;
> +		mpc->eventfd = eventfd;
> +		mpc->thres = i;
> +		ret = 0;
> +		break;
> +	}
> +out_unlock:
> +	mutex_unlock(&mpc->lock);
> +
> +	return ret;
> +}

-- 
 Kirill A. Shutemov
