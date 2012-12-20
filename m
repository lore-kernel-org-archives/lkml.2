Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2LTLGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:06:47 -0500
Received: from mx2.parallels.com ([64.131.90.16]:55376 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab2LTLGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:06:39 -0500
Message-ID: <50D2F142.401@parallels.com>
Date: Thu, 20 Dec 2012 15:06:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH 05/19] shrinker: convert superblock shrinkers to new API
References: <1354058086-27937-1-git-send-email-david@fromorbit.com> <1354058086-27937-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1354058086-27937-6-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 03:14 AM, Dave Chinner wrote:
> +static long super_cache_count(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +	struct super_block *sb;
> +	long	total_objects = 0;
> +
> +	sb = container_of(shrink, struct super_block, s_shrink);
> +
> +	if (!grab_super_passive(sb))
> +		return -1;
> +


You're missing the GFP_FS check here. This leads to us doing all the
counting only to find out later, in the scanner, that we won't be able
to free it. Better exit early.
